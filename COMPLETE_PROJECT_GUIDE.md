# 🦷 DentalCore BI - Guia Definitivo do Projeto (100%)

Este documento é a "bíblia" técnica e funcional do **DentalCore BI**. Ele detalha cada camada, decisão de arquitetura e regra de negócio implementada até o momento.

---

## 1. Visão Geral e Objetivo
O DentalCore é um ERP odontológico com foco em inteligência de negócio. Ele resolve o problema da gestão fragmentada, unificando a agenda clínica, o cadastro de pacientes e o cockpit de métricas em uma experiência premium e integrada.

---

## 2. Arquitetura do Sistema

### 🔙 Backend (Motor C#)
Baseado em **.NET 9**, focado em robustez e consistência de dados.
- **Padrão de Resposta:** Todas as requisições retornam um envelope `ApiResponse<T>`, garantindo que o Frontend sempre saiba se houve sucesso ou erro de forma padronizada.
- **Isolamento via DTOs:** Entidades de banco nunca são expostas. DTOs (Data Transfer Objects) gerenciam o contrato de entrada e saída.

### 📱 Frontend (App Flutter)
Construído para ser rápido, bonito e reativo.
- **Gerência de Estado:** `Provider` é utilizado para desacoplar a lógica de negócio (Providers) da interface (Pages).
- **Consumo de API:** Centralizado no `ApiService` usando o cliente `Dio` com interceptores de log e tratamento de erros integrado.

---

## 3. Mergulho Técnico: Backend

### 🧼 Persistência e Soft Delete
- **Conceito:** Dados clínicos nunca são removidos fisicamente.
- **Implementação:** Todas as entidades herdam de `BaseEntity` com a propriedade `DataExclusao`.
- **Global Query Filters:** No `AppDbContext`, configuramos filtros globais para que `WHERE DataExclusao IS NULL` seja aplicado automaticamente em todas as consultas SQL geradas pelo EF Core.

### 🛡️ Tratamento Global de Erros
- **ExceptionHandler:** Um middleware captura qualquer exceção não tratada e a transforma em uma `ApiResponse` amigável com status HTTP adequado, impedindo o vazamento de stack traces para o usuário final.

### ⏰ Gestão de Fuso Horário
- **Regra:** Todas as datas são processadas no fuso **"E. South America Standard Time"** (Brasília). Isso evita que uma consulta marcada às 14h no servidor seja exibida em outro horário no celular.

---

## 4. Mergulho Técnico: Frontend

### 🎨 Design System Premium
- **Paleta de Cores:**
  - `Primary Navy` (#1A237E): Autoridade e seriedade.
  - `Secondary Gold` (#D4AF37): Prestígio e qualidade.
  - `Background Beige` (#F5F5F5): Higiene e conforto visual.
- **Tipografia:** `Manrope` via Google Fonts, escolhida pela legibilidade moderna.

### ⚡ Fluxo de Dados Reativo
1. O usuário aciona uma ação (ex: mudar status de consulta).
2. O `Page` chama o `Provider`.
3. O `Provider` chama o `ApiService`.
4. O `ApiService` envia o JSON para o Backend e recebe a `ApiResponse`.
5. O `Provider` processa o resultado e notifica os ouvintes (`notifyListeners()`).
6. A Interface se reconstrói automaticamente com os novos dados.

---

## 5. Regras de Negócio Implementadas

### 📅 Regras de Agenda
- **Conflitos:** Não é possível agendar duas consultas no exato mesmo horário.
- **Data Retroativa:** Bloqueio de agendamentos no passado.
- **Máquina de Status:**
  - `Agendada` → `Realizada`, `Faltou` ou `Cancelada`.
  - `Faltou` → Pode retornar para `Agendada` (correção de fluxo).
  - Estados `Realizada` e `Cancelada` são imutáveis após finalizados.

---

## 6. Referência de Endpoints

| Método | Endpoint | Descrição |
| :--- | :--- | :--- |
| `GET` | `/api/consulta/dia` | Lista atendimentos por data. |
| `GET` | `/api/consulta/dashboard` | Retira métricas p/ o Cockpit. |
| `PATCH` | `/api/consulta/{id}/status` | Atualiza o estado do atendimento. |
| `POST` | `/api/paciente` | Cadastro com validação de CPF. |
| `GET` | `/api/paciente` | Lista pacientes ativos. |

---

## 🔧 Configurações de Ambiente
- **Backend:** Configurado via `appsettings.json` e `launchSettings.json` (Porta 5273).
- **SQLite:** Banco local `DentalCore.db` persistente na pasta raiz da API.
- **Flutter:** Detecta `10.0.2.2` para emuladores Android e `localhost` para Desktop/Web automaticamente no `ApiService`.

---
**Documentação atualizada em:** 26/04/2026
**Responsável:** Antigravity AI
