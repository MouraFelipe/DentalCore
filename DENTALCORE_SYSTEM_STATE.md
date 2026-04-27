# 🦷 DentalCore BI - Estado Atual do Sistema (v1.1)

Este documento reflete o estado técnico e funcional do projeto **DentalCore** em 26 de Abril de 2026.

---

## 🏛️ Arquitetura Geral
O sistema utiliza uma arquitetura desacoplada com foco em performance e segurança:
- **Backend:** .NET 8 Web API (C#) com Entity Framework Core.
- **Frontend:** Flutter (Dart) responsivo para Web e Desktop (Windows).
- **Banco de Dados:** SQLite (agilidade em desenvolvimento) com suporte a Migrations e Data Seeding.

---

## 🔐 Segurança & Identidade (AUTH-01)
Implementamos uma camada de segurança robusta:
- **Autenticação:** Baseada em **JWT (JSON Web Tokens)**.
- **Autorização:** Role-Based Access Control (RBAC) com suporte a:
    - `Admin`: Acesso total.
    - `Dentista`: Acesso clínico.
    - `Recepcionista`: Gestão de agenda e pacientes.
- **Criptografia:** Senhas armazenadas com hashing **BCrypt**.
- **Persistência Móvel:** Sessão armazenada via `shared_preferences` no Flutter.

---

## 📊 Módulos Implementados

### 🚀 Cockpit (Dashboard)
- Dashboard executivo responsivo.
- Métricas: Total de Pacientes, Consultas do Dia, Faturamento (Mock), Taxa de Comparecimento.
- Gráficos de desempenho clínico.

### 👥 Gestão de Pacientes
- CRUD completo de pacientes.
- Validação rigorosa de CPF.
- Busca inteligente e listagem otimizada.

### 📅 Agenda Inteligente
- Visualização de consultas diárias.
- Controle de status (Agendada, Realizada, Cancelada).
- Regras de negócio: Proibição de conflitos de horário.

---

## 🛠️ Stack Tecnológica Detalhada
| Tecnologia | Função | Detalhes |
| :--- | :--- | :--- |
| **.NET 8** | Backend | API Restful, JWT, EF Core |
| **Flutter** | Frontend | Provider (Estado), Dio (HTTP), Material 3 |
| **SQLite** | Database | Persistência local, EnsureCreated logic |
| **BCrypt** | Segurança | Hashing de senhas seguro |
| **Manrope** | Design | Tipografia Premium |
| **Deep Navy & Gold** | Design | Identidade visual de alto padrão |

---

## 📂 Estado do Repositório
- **`/api`**: Código-fonte do servidor .NET.
- **`/MobileApp`**: Código-fonte do aplicativo Flutter.
- **`.gitignore`**: Configurado para remover binários (`bin`, `obj`), artefatos do Dart e banco de dados local.

---

## 🎯 Próximos Passos (Roadmap)
1. **[CLIN-01] Odontograma Interativo:** Mapeamento visual da boca do paciente.
2. **[FIN-01] Módulo Financeiro:** Fluxo de caixa e orçamentos.
3. **[COM-01] Notificações WhatsApp:** Lembretes automáticos de consulta.

---
*Atualizado por Antigravity AI em 26/04/2026.*
