# AutoHub ⚙️

Sistema de gestão para oficina mecânica.

## Stack do projeto

- **Back-end:** Java Spring Boot
- **Banco de dados:** PostgreSQL
- **Migrações:** Flyway
- **Front-end:** Angular

## Descrição

O **AutoHub** foi projetado para centralizar o controle operacional de uma oficina mecânica, permitindo gerenciar clientes, veículos, ordens de serviço, peças utilizadas, serviços executados, pagamentos e acompanhamento do andamento do serviço.

## Objetivo

A proposta do sistema é oferecer uma base estruturada para as principais rotinas da oficina, como:

- cadastro de clientes
- cadastro de veículos
- abertura e gerenciamento de ordens de serviço
- registro de serviços executados
- controle de peças utilizadas
- controle de pagamentos
- histórico de status da ordem de serviço
- consulta de histórico por placa
- acompanhamento do serviço pelo cliente

## Arquitetura do projeto

O projeto será dividido em:

- **Back-end em Java Spring Boot**
  - responsável pelas regras de negócio
  - APIs REST
  - integração com o banco
  - autenticação e segurança futuramente

- **Banco de dados PostgreSQL**
  - armazenamento relacional dos dados do sistema
  - estrutura modelada para o MVP e pronta para evolução

- **Flyway**
  - versionamento das alterações do banco
  - controle de migrations
  - padronização entre ambientes

- **Front-end em Angular**
  - interface do sistema
  - consumo das APIs do back-end
  - telas administrativas e acompanhamento do cliente

## Estrutura principal de dados

A modelagem inicial do sistema foi organizada com as seguintes entidades principais:

- `clients`
- `vehicles`
- `users`
- `service_orders`
- `service_order_services`
- `parts`
- `service_order_parts`
- `payments`
- `service_order_status_history`
- `service_order_tracking`

## Regras da modelagem

Algumas regras importantes da estrutura de dados:

- um cliente pode ter vários veículos
- um veículo pode ter várias ordens de serviço
- uma ordem de serviço pode ter vários serviços executados
- uma ordem de serviço pode ter várias peças usadas
- uma ordem de serviço pode ter vários pagamentos
- uma ordem de serviço pode ter vários registros de histórico
- a placa do veículo deve ser única
- o número da ordem de serviço deve ser único
- o email do usuário deve ser único
- o token de rastreamento público deve ser único

## Organização esperada

```bash
 backend/
   └─ src/
       └─ main/
            ├─ java/
            │   └─ com/autohub/
            │       ├─ config/
            │       ├─ controller/
            │       ├─ dto/
            │       ├─ entity/
            │       ├─ repository/
            │       ├─ service/
            │       └─ AutoHubApplication.java
            └─ resources/
                ├─ db/
                │   └─ migration/
                │       └─ V1__initial_schema.sql
                └─ application.yml
frontend/
     └─ src/
