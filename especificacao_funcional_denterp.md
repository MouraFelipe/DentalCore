# Especificação Funcional e Técnica - DentERP

## 1. Visão Geral
O **DentERP** é um sistema de gestão integrada projetado para clínicas odontológicas. O objetivo é unificar o atendimento clínico, o gerenciamento de pacientes e o controle financeiro/operacional em uma plataforma multiplataforma (Web/Mobile).

---

## 2. Arquitetura Proposta
- **Backend:** ASP.NET Core (.NET 9) seguindo o padrão de Camadas (Domain, Application, Infrastructure, API).
- **Banco de Dados:** SQL Server com Entity Framework Core (Code First).
- **Mobile:** Flutter (Arquitetura Clean ou Bloc/Provider para gerenciamento de estado).
- **Autenticação:** JWT (JSON Web Token) com Identity Framework.

---

## 3. Módulos Funcionais (O que o sistema deve fazer)

### 3.1. Gestão de Pacientes (CRM Clínico)
- **Cadastro Completo:** Dados pessoais, anamnese (histórico de saúde), alergias e termos de consentimento.
- **Prontuário Digital:** Linha do tempo de todos os atendimentos, evoluções clínicas e anexos (raios-X e fotos).
- **Odontograma:** Interface gráfica para marcar procedimentos realizados ou planejados em cada dente.

### 3.2. Agenda e Fluxo de Atendimento
- **Multiprofissional:** Visualização de agendas por dentista e por sala/cadeira.
- **Status de Consulta:** Fluxo completo: `Agendada` -> `Confirmada` -> `Em Atendimento` -> `Finalizada` -> `Faltou`.
- **Lembretes:** Integração com APIs de mensageria (WhatsApp/E-mail) para redução de No-Show.

### 3.3. Financeiro e Faturamento
- **Orçamentos:** Geração de propostas comerciais com aprovação formal.
- **Contas a Receber:** Gestão de parcelamentos, boletos e integração com máquinas de cartão (PDV).
- **Split de Comissões:** Cálculo automático da porcentagem devida ao dentista após a quitação do procedimento.
- **Fluxo de Caixa:** Relatórios de entradas e saídas operacionais.

### 3.4. Controle de Estoque
- **Insumos:** Cadastro de materiais (resinas, luvas, anestésicos) com controle de lote e validade.
- **Baixa Automática:** Ao finalizar um procedimento, o sistema deve sugerir a baixa dos itens utilizados.

---

## 4. Requisitos Não-Funcionais e Qualidade (QA)

### 4.1. Segurança e Integridade de Dados
- **Autenticação e Autorização:** Controle de acesso baseado em Roles (Admin, Dentista, Recepcionista).
- **Soft Delete:** Implementação do `BaseEntity` com `DataExclusao` para impedir perda acidental de dados históricos.
- **Auditoria (Logs):** Registro de "quem alterou o quê" em registros sensíveis como orçamentos e prontuários.

### 4.2. Validações e Regras de Negócio
- **Integridade de Banco de Dados:** Impedir "registros órfãos" e garantir que campos obrigatórios (Telefone, CPF) sejam validados via DataAnnotations e FluentValidation.
- **Concorrência:** Tratamento de conflitos quando dois usuários tentam agendar o mesmo horário simultaneamente.

---

## 5. Próximos Passos de Desenvolvimento
1. **API Expansion:** Criar o `PacienteController` e `FinanceiroController`.
2. **Auth Layer:** Implementar Login e proteção de endpoints.
3. **Mobile UI:** Desenvolver as telas de Listagem de Pacientes e Detalhes da Consulta no Flutter.
4. **DevOps:** Configurar o `appsettings.json` com variáveis de ambiente e gerenciar segredos de forma segura.