CREATE EXTENSION IF NOT EXISTS "pgcrypto";

CREATE TABLE clients (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    nome VARCHAR(150) NOT NULL,
    telefone VARCHAR(20),
    email VARCHAR(150),
    cpf_cnpj VARCHAR(20),
    endereco TEXT,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE vehicles (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    client_id UUID NOT NULL,
    placa VARCHAR(10) NOT NULL,
    marca VARCHAR(80) NOT NULL,
    modelo VARCHAR(100) NOT NULL,
    ano INTEGER,
    cor VARCHAR(50),
    chassi VARCHAR(50),
    km_atual INTEGER,
    observacoes TEXT,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_vehicles_client
        FOREIGN KEY (client_id) REFERENCES clients(id) ON DELETE CASCADE,

    CONSTRAINT uq_vehicles_placa UNIQUE (placa)
);

CREATE TABLE users (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    nome VARCHAR(150) NOT NULL,
    email VARCHAR(150) NOT NULL,
    senha_hash TEXT NOT NULL,
    cargo VARCHAR(30) NOT NULL,
    ativo BOOLEAN NOT NULL DEFAULT TRUE,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT uq_users_email UNIQUE (email)
);

CREATE TABLE service_orders (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    client_id UUID NOT NULL,
    vehicle_id UUID NOT NULL,
    numero_os VARCHAR(30) NOT NULL,
    status VARCHAR(30) NOT NULL,
    problema_relato TEXT,
    diagnostico TEXT,
    observacoes TEXT,
    data_entrada TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    previsao_entrega TIMESTAMP,
    data_saida TIMESTAMP,
    km_entrada INTEGER,
    km_saida INTEGER,
    valor_servicos NUMERIC(10,2) NOT NULL DEFAULT 0,
    valor_pecas NUMERIC(10,2) NOT NULL DEFAULT 0,
    valor_desconto NUMERIC(10,2) NOT NULL DEFAULT 0,
    valor_total NUMERIC(10,2) NOT NULL DEFAULT 0,
    valor_pago NUMERIC(10,2) NOT NULL DEFAULT 0,
    status_pagamento VARCHAR(20) NOT NULL DEFAULT 'pendente',
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_service_orders_client
        FOREIGN KEY (client_id) REFERENCES clients(id),

    CONSTRAINT fk_service_orders_vehicle
        FOREIGN KEY (vehicle_id) REFERENCES vehicles(id),

    CONSTRAINT uq_service_orders_numero_os UNIQUE (numero_os),

    CONSTRAINT chk_service_orders_status
        CHECK (status IN (
            'aberta',
            'em_diagnostico',
            'aguardando_aprovacao',
            'em_execucao',
            'finalizada',
            'cancelada'
        )),

    CONSTRAINT chk_service_orders_status_pagamento
        CHECK (status_pagamento IN (
            'pendente',
            'parcial',
            'pago'
        )),

    CONSTRAINT chk_service_orders_valor_servicos
        CHECK (valor_servicos >= 0),

    CONSTRAINT chk_service_orders_valor_pecas
        CHECK (valor_pecas >= 0),

    CONSTRAINT chk_service_orders_valor_desconto
        CHECK (valor_desconto >= 0),

    CONSTRAINT chk_service_orders_valor_total
        CHECK (valor_total >= 0),

    CONSTRAINT chk_service_orders_valor_pago
        CHECK (valor_pago >= 0)
);

CREATE TABLE service_order_services (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    service_order_id UUID NOT NULL,
    descricao VARCHAR(200) NOT NULL,
    quantidade NUMERIC(10,2) NOT NULL DEFAULT 1,
    valor_unitario NUMERIC(10,2) NOT NULL,
    valor_total NUMERIC(10,2) NOT NULL,
    observacoes TEXT,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_service_order_services_order
        FOREIGN KEY (service_order_id) REFERENCES service_orders(id) ON DELETE CASCADE,

    CONSTRAINT chk_service_order_services_quantidade
        CHECK (quantidade > 0),

    CONSTRAINT chk_service_order_services_valor_unitario
        CHECK (valor_unitario >= 0),

    CONSTRAINT chk_service_order_services_valor_total
        CHECK (valor_total >= 0)
);

CREATE TABLE parts (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    nome VARCHAR(150) NOT NULL,
    codigo_interno VARCHAR(50),
    fabricante VARCHAR(100),
    categoria VARCHAR(80),
    preco_custo NUMERIC(10,2) NOT NULL DEFAULT 0,
    preco_venda NUMERIC(10,2) NOT NULL DEFAULT 0,
    quantidade_estoque INTEGER NOT NULL DEFAULT 0,
    estoque_minimo INTEGER NOT NULL DEFAULT 0,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT uq_parts_codigo_interno UNIQUE (codigo_interno),

    CONSTRAINT chk_parts_preco_custo
        CHECK (preco_custo >= 0),

    CONSTRAINT chk_parts_preco_venda
        CHECK (preco_venda >= 0),

    CONSTRAINT chk_parts_quantidade_estoque
        CHECK (quantidade_estoque >= 0),

    CONSTRAINT chk_parts_estoque_minimo
        CHECK (estoque_minimo >= 0)
);

CREATE TABLE service_order_parts (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    service_order_id UUID NOT NULL,
    part_id UUID NOT NULL,
    quantidade NUMERIC(10,2) NOT NULL,
    valor_unitario NUMERIC(10,2) NOT NULL,
    valor_total NUMERIC(10,2) NOT NULL,
    observacoes TEXT,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_service_order_parts_order
        FOREIGN KEY (service_order_id) REFERENCES service_orders(id) ON DELETE CASCADE,

    CONSTRAINT fk_service_order_parts_part
        FOREIGN KEY (part_id) REFERENCES parts(id),

    CONSTRAINT chk_service_order_parts_quantidade
        CHECK (quantidade > 0),

    CONSTRAINT chk_service_order_parts_valor_unitario
        CHECK (valor_unitario >= 0),

    CONSTRAINT chk_service_order_parts_valor_total
        CHECK (valor_total >= 0)
);

CREATE TABLE payments (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    service_order_id UUID NOT NULL,
    metodo_pagamento VARCHAR(30) NOT NULL,
    valor NUMERIC(10,2) NOT NULL,
    data_pagamento TIMESTAMP,
    observacoes TEXT,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_payments_order
        FOREIGN KEY (service_order_id) REFERENCES service_orders(id) ON DELETE CASCADE,

    CONSTRAINT chk_payments_metodo_pagamento
        CHECK (metodo_pagamento IN (
            'pix',
            'dinheiro',
            'cartao_credito',
            'cartao_debito',
            'transferencia'
        )),

    CONSTRAINT chk_payments_valor
        CHECK (valor > 0)
);

CREATE TABLE service_order_status_history (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    service_order_id UUID NOT NULL,
    status VARCHAR(30) NOT NULL,
    descricao TEXT,
    alterado_por UUID,
    data_alteracao TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_status_history_order
        FOREIGN KEY (service_order_id) REFERENCES service_orders(id) ON DELETE CASCADE,

    CONSTRAINT fk_status_history_user
        FOREIGN KEY (alterado_por) REFERENCES users(id),

    CONSTRAINT chk_status_history_status
        CHECK (status IN (
            'aberta',
            'em_diagnostico',
            'aguardando_aprovacao',
            'em_execucao',
            'finalizada',
            'cancelada'
        ))
);

CREATE TABLE service_order_tracking (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    service_order_id UUID NOT NULL,
    token_publico VARCHAR(120) NOT NULL,
    ativo BOOLEAN NOT NULL DEFAULT TRUE,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_tracking_order
        FOREIGN KEY (service_order_id) REFERENCES service_orders(id) ON DELETE CASCADE,

    CONSTRAINT uq_tracking_service_order UNIQUE (service_order_id),
    CONSTRAINT uq_tracking_token UNIQUE (token_publico)
);

CREATE INDEX idx_vehicles_client_id ON vehicles(client_id);
CREATE INDEX idx_vehicles_placa ON vehicles(placa);

CREATE INDEX idx_service_orders_client_id ON service_orders(client_id);
CREATE INDEX idx_service_orders_vehicle_id ON service_orders(vehicle_id);
CREATE INDEX idx_service_orders_status ON service_orders(status);
CREATE INDEX idx_service_orders_status_pagamento ON service_orders(status_pagamento);
CREATE INDEX idx_service_orders_data_entrada ON service_orders(data_entrada);

CREATE INDEX idx_service_order_services_order_id ON service_order_services(service_order_id);

CREATE INDEX idx_parts_nome ON parts(nome);
CREATE INDEX idx_parts_categoria ON parts(categoria);

CREATE INDEX idx_service_order_parts_order_id ON service_order_parts(service_order_id);
CREATE INDEX idx_service_order_parts_part_id ON service_order_parts(part_id);

CREATE INDEX idx_payments_order_id ON payments(service_order_id);
CREATE INDEX idx_payments_data_pagamento ON payments(data_pagamento);

CREATE INDEX idx_status_history_order_id ON service_order_status_history(service_order_id);
CREATE INDEX idx_status_history_data_alteracao ON service_order_status_history(data_alteracao);

CREATE INDEX idx_tracking_token_publico ON service_order_tracking(token_publico);