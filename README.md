# 🦷 DentalCore BI - ERP & Dashboard Odontológico

O **DentalCore** é um sistema de gestão clínica e inteligência de negócio (BI) desenvolvido para otimizar a operação de consultórios odontológicos. O foco do projeto é fornecer uma visão clara da agenda, controle rigoroso de pacientes e métricas de desempenho em tempo real para o dono da clínica.

---

## 🚀 Status do Projeto: Backend MVP Concluído 🎯
Atualmente, o motor da aplicação (API) está totalmente operacional, com regras de negócio blindadas, tratamento de erros global e persistência de dados otimizada.

---

## 🛠️ Stack Tecnológica
- **Linguagem Principal:** C# (.NET 8)
- **Banco de Dados:** SQLite (escolhido pela portabilidade e agilidade no desenvolvimento local)
- **ORM:** Entity Framework Core (Code-First)
- **Documentação:** Swagger (OpenAPI)
- **Padrão de Resposta:** Envelope padronizado `ApiResponse<T>`
- **Frontend (Em progresso):** Flutter (Mobile/Tablet) com integração via Dio.

---

## 🏗️ Arquitetura e Decisões Técnicas

### 1. Camada de Domínio e Persistência
- **Soft Delete:** Implementado via propriedade `DataExclusao`. Os dados nunca são removidos fisicamente, garantindo integridade para auditoria.
- **Global Query Filters:** O sistema filtra automaticamente registros "excluídos" em todas as consultas LINQ.
- **Indexação:** Índices aplicados em campos de alta consulta, como `DataHora` na tabela de Consultas, otimizando buscas por intervalo de tempo.

### 2. Regras de Negócio Implementadas (Backend)
- **Validação de Conflito de Horário:** A API impede agendamentos sobrepostos ou no passado.
- **Matriz de Status de Consulta:**
    - `Agendada`: Pode ser marcada como Realizada, Faltou ou Cancelada.
    - `Faltou`: Pode retornar para Agendada (correção de erro).
    - `Realizada/Cancelada`: Estados finais e imutáveis para preservação de histórico.
- **Gestão de Fuso Horário:** Operação padronizada em "E. South America Standard Time" (Horário de Brasília), evitando erros de fuso entre servidor e aplicativo.

### 3. Segurança e Robustez
- **Tratamento Global de Exceções:** Middleware customizado que captura erros internos e devolve mensagens amigáveis no formato JSON, evitando que o App pare de funcionar.
- **DTOs (Data Transfer Objects):** Isolamento total das entidades de banco de dados. A comunicação externa é feita apenas por contratos de entrada e saída.

---

## 📊 Endpoints da API

### Pacientes
- `POST /api/paciente`: Cadastro com validação de CPF único.
- `GET /api/paciente`: Listagem de pacientes ativos.
- `PUT /api/paciente/{id}`: Atualização cadastral.
- `DELETE /api/paciente/{id}`: Exclusão lógica (Soft Delete).

### Consultas & Agenda
- `POST /api/consultas`: Agendamento inteligente (valida conflitos).
- `GET /api/consultas/dia`: Lista de atendimentos com range de data otimizado.
- `PATCH /api/consultas/{id}/status`: Alteração de estado da consulta (Realizou/Faltou).
- `GET /api/consultas/dashboard`: Extração de métricas (Total, Realizadas, Faltas) processada diretamente no banco via `GroupBy`.

---

## 🔧 Configuração de Desenvolvimento
O projeto utiliza um `DataSeeder` automático que popula o banco de dados no primeiro acesso, permitindo testes imediatos da interface.

### Como rodar o Backend:
1. Navegue até a pasta `/api`.
2. Inicie o servidor:
   ```bash
   dotnet run
   ```

---

## 📈 Próximos Passos (Sprint Mobile)
- [ ] Implementação do ApiService no Flutter.
- [ ] Construção da Smart Agenda com atualização de status em tempo real.
- [ ] Desenvolvimento do Cockpit de Métricas com cards coloridos para o gestor.
- [ ] Integração de feedback visual (SnackBars) para respostas da API.
