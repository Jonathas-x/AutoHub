# AutoHub - Backend

Backend do projeto **AutoHub**, um sistema de gestão para oficina mecânica.

O objetivo do sistema é centralizar o controle operacional da oficina, permitindo gerenciar clientes, veículos, ordens de serviço, peças utilizadas, serviços executados, pagamentos e acompanhamento do andamento do serviço.

## Tecnologias utilizadas

- Java
- Spring Boot
- Spring Web
- Spring Data JPA
- PostgreSQL
- Flyway
- Maven

## Objetivo do projeto

O AutoHub foi pensado para atender as principais rotinas de uma oficina mecânica, oferecendo uma base estruturada para:

- cadastro de clientes
- cadastro de veículos
- abertura e gerenciamento de ordens de serviço
- registro de serviços executados
- controle de peças utilizadas
- controle de pagamentos
- histórico de status da ordem de serviço
- consulta de histórico por placa
- acompanhamento do serviço pelo cliente

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

## Stack de persistência

O projeto utiliza:

- **PostgreSQL** como banco de dados relacional
- **Flyway** para versionamento e execução das migrações
- **JPA / Hibernate** para mapeamento das entidades

## Organização esperada do projeto

Exemplo de organização da aplicação:

```bash
src/
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
