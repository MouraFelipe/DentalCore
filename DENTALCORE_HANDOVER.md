# 🦷 DentalCore BI - Handover Técnico MVP

Este documento resume o estado atual do projeto **DentalCore BI** após a conclusão da fase de MVP (Minimum Viable Product). O sistema agora conta com um backend robusto em .NET 8 e um frontend mobile premium em Flutter.

---

## 🏗️ Arquitetura do Sistema

### 🔙 Backend (.NET 8)
- **Localização:** `/api`
- **Banco de Dados:** SQLite (`DentalCore.db`)
- **ORM:** Entity Framework Core com suporte a **Soft Delete** global.
- **Segurança:** Middleware de tratamento de erros global (`GlobalExceptionHandler`) que garante respostas JSON amigáveis em qualquer falha.
- **Porta Padrão:** `5273`

### 📱 Frontend (Flutter)
- **Localização:** `/MobileApp` (Espelhado de `/app`)
- **Arquitetura:** `State Management` via **Provider** and `Service oriented architecture` com **Dio**.
- **Design System:** 
  - **Cores:** Deep Navy (`#1A237E`) e Gold (`#D4AF37`).
  - **Tipografia:** Manrope.
  - **Aesthetics:** Material 3 com foco em UX premium.

---

## 🚀 Funcionalidades Implementadas

### 📅 Gestão de Consultas (Smart Agenda)
- **Dashboard de Hoje:** Cockpit com métricas (Total, Realizadas, Faltas, Canceladas).
- **Update de Status:** Alteração de status da consulta em tempo real (Realizada/Falta/Cancelada) com validações de regra de negócio no backend.
- **Timezone:** Operação travada em Horário de Brasília (UTC-3).

### 👥 Gestão de Pacientes
- **CRUD Completo:** Cadastro de pacientes com validação de CPF e telefone.
- **Persistência Social:** Soft delete implementado para não perder históricos financeiros/clínicos.

---

## 🛠️ Guia de Manutenção e Execução

### Como iniciar o ambiente de desenvolvimento:
1. **No Backend:** `dotnet run` (Sempre inicie o backend primeiro).
2. **No App:** `flutter run -d windows` (ou selecione o emulador Android).

### Endpoints Principais:
- `GET  /api/consulta/dia`: Lista agenda do dia.
- `GET  /api/consulta/dashboard`: Métricas do Cockpit.
- `PATCH /api/consulta/{id}/status`: Muda estado da consulta.
- `GET  /api/paciente`: Lista todos os pacientes ativos.

---

## 📈 Próximos Passos Sugeridos
- [ ] **Módulo Financeiro:** Integração de pagamentos por consulta.
- [ ] **Histórico Clínico:** Prontuário digital com upload de imagens.
- [ ] **Notificações:** Alertas de WhatsApp automáticos para os pacientes (via API externa).

---
**Status:** 🟢 Estável | **Versão:** 1.0.0-MVP
