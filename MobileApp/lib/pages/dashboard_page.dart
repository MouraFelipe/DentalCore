import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth > 800) {
          return _buildWebLayout(context);
        } else {
          return _buildMobileLayout(context);
        }
      },
    );
  }

  // ════════════════════════════════════════════════════════════════════════
  // 1. LAYOUTS (WEB & MOBILE)
  // ════════════════════════════════════════════════════════════════════════

  Widget _buildWebLayout(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: Row(
        children: [
          _buildSideNavBar(context, isWeb: true),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildTopAppBar(context, isWeb: true),
                  const SizedBox(height: 24),
                  _buildHeader(),
                  const SizedBox(height: 32),
                  Row(
                    children: [
                      Expanded(child: _buildTermometroCard("Faltas: 4", Icons.warning_amber_rounded, const Color(0xFFFFEBEE), const Color(0xFFC62828))),
                      const SizedBox(width: 16),
                      Expanded(child: _buildTermometroCard("Realizadas: 12", Icons.check_circle_outline, const Color(0xFFE8F5E9), const Color(0xFF2E7D32))),
                      const SizedBox(width: 16),
                      Expanded(child: _buildTermometroCard("Restantes: 8", Icons.access_time_rounded, const Color(0xFF1A237E), const Color(0xFFD4AF37))),
                    ],
                  ),
                  const SizedBox(height: 32),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(flex: 2, child: _buildQuickActions(context)),
                      const SizedBox(width: 24),
                      Expanded(flex: 1, child: _buildOcupacaoDia()),
                    ],
                  ),
                  const SizedBox(height: 32),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(flex: 2, child: _buildFilaAtendimento()),
                      const SizedBox(width: 24),
                      Expanded(flex: 1, child: _buildMetasBI()),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMobileLayout(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: _buildTopAppBar(context, isWeb: false),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            const SizedBox(height: 24),
            _buildTermometroCard("Faltas: 4", Icons.warning_amber_rounded, const Color(0xFFFFEBEE), const Color(0xFFC62828)),
            const SizedBox(height: 12),
            _buildTermometroCard("Realizadas: 12", Icons.check_circle_outline, const Color(0xFFE8F5E9), const Color(0xFF2E7D32)),
            const SizedBox(height: 12),
            _buildTermometroCard("Restantes: 8", Icons.access_time_rounded, const Color(0xFF1A237E), const Color(0xFFD4AF37)),
            const SizedBox(height: 32),
            _buildQuickActions(context),
            const SizedBox(height: 24),
            _buildOcupacaoDia(),
            const SizedBox(height: 32),
            _buildFilaAtendimento(),
            const SizedBox(height: 24),
            _buildMetasBI(),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color(0xFF1A237E),
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.dashboard_rounded), label: 'Dashboard'),
          BottomNavigationBarItem(icon: Icon(Icons.calendar_today_rounded), label: 'Agenda'),
          BottomNavigationBarItem(icon: Icon(Icons.people_outline_rounded), label: 'Pacientes'),
          BottomNavigationBarItem(icon: Icon(Icons.account_balance_wallet_outlined), label: 'Financeiro'),
        ],
      ),
    );
  }

  // ════════════════════════════════════════════════════════════════════════
  // 2. COMPONENTES (WIDGETS PRIVADOS)
  // ════════════════════════════════════════════════════════════════════════

  Widget _buildSideNavBar(BuildContext context, {required bool isWeb}) {
    return Container(
      width: 260,
      color: const Color(0xFF1A237E),
      child: Column(
        children: [
          const SizedBox(height: 40),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              children: [
                Image.asset('assets/images/dental_clinical_logo_1777244816520.png', height: 40),
                const SizedBox(width: 12),
                Text(
                  "Dental Clinical",
                  style: GoogleFonts.manrope(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 60),
          _buildNavItem(Icons.dashboard_rounded, "Dashboard", active: true),
          _buildNavItem(Icons.calendar_today_rounded, "Agenda"),
          _buildNavItem(Icons.people_outline_rounded, "Pacientes"),
          _buildNavItem(Icons.account_balance_wallet_outlined, "Financeiro"),
          _buildNavItem(Icons.bar_chart_rounded, "Relatórios"),
          const Spacer(),
          _buildNavItem(Icons.support_agent_rounded, "Suporte"),
          _buildNavItem(Icons.logout_rounded, "Sair"),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, {bool active = false}) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: active ? Colors.white.withOpacity(0.1) : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: Icon(icon, color: active ? const Color(0xFFD4AF37) : Colors.white70),
        title: Text(label, style: GoogleFonts.manrope(color: active ? Colors.white : Colors.white70, fontSize: 15)),
        onTap: () {},
      ),
    );
  }

  Widget _buildTopAppBar(BuildContext context, {required bool isWeb}) {
    return Row(
      children: [
        if (isWeb)
          Text(
            "DentalCockpit",
            style: GoogleFonts.manrope(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF1A237E),
            ),
          ),
        const Spacer(),
        Container(
          width: 250,
          height: 45,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
          ),
          child: const TextField(
            decoration: InputDecoration(
              hintText: "Buscar...",
              prefixIcon: Icon(Icons.search, color: Colors.grey),
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(vertical: 10),
            ),
          ),
        ),
        const SizedBox(width: 16),
        ElevatedButton.icon(
          onPressed: () {},
          icon: const Icon(Icons.add),
          label: const Text("Novo Agendamento"),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFD4AF37),
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
        const SizedBox(width: 12),
        IconButton(icon: const Icon(Icons.notifications_none_rounded), onPressed: () {}),
        const SizedBox(width: 12),
         CircleAvatar(
          backgroundImage: const AssetImage('assets/images/dr_roberto_profile_1777244829172.png'),
          backgroundColor: const Color(0xFF1A237E),
        ),
      ],
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Olá, Dr. Roberto",
              style: GoogleFonts.manrope(fontSize: 28, fontWeight: FontWeight.bold, color: const Color(0xFF1A237E)),
            ),
            Text(
              "Hoje, 26 de Abril de 2026",
              style: GoogleFonts.manrope(fontSize: 16, color: Colors.grey[600]),
            ),
          ],
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.withOpacity(0.2)),
          ),
          child: const Row(
            children: [
              Icon(Icons.calendar_month_rounded, size: 20),
              SizedBox(width: 8),
              Text("Hoje"),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTermometroCard(String title, IconData icon, Color bgColor, Color textColor) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Row(
        children: [
          Icon(icon, color: textColor, size: 30),
          const SizedBox(width: 16),
          Text(
            title,
            style: GoogleFonts.manrope(fontSize: 18, fontWeight: FontWeight.bold, color: textColor),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF1A237E), Color(0xFF283593)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Ações Rápidas", style: GoogleFonts.manrope(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),
          Row(
            children: [
              _buildActionButton(Icons.calendar_today, "Ver Agenda", Colors.white24),
              const SizedBox(width: 16),
              _buildActionButton(Icons.add_task, "Novo Agendamento", const Color(0xFFD4AF37)),
              const SizedBox(width: 16),
              _buildActionButton(Icons.person_add, "Novo Paciente", Colors.white24),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(IconData icon, String label, Color color) {
    return Expanded(
      child: Container(
        height: 100,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color == const Color(0xFFD4AF37) ? Colors.white : Colors.white, size: 28),
            const SizedBox(height: 8),
            Text(label, style: GoogleFonts.manrope(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }

  Widget _buildOcupacaoDia() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
      ),
      child: Column(
        children: [
          Text("Ocupação do Dia", style: GoogleFonts.manrope(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),
          SizedBox(
            height: 120,
            width: 120,
            child: Stack(
              alignment: Alignment.center,
              children: [
                const CircularProgressIndicator(
                  value: 0.6,
                  strokeWidth: 10,
                  backgroundColor: Color(0xFFF1F1F1),
                  color: Color(0xFF1A237E),
                ),
                Text("60%", style: GoogleFonts.manrope(fontSize: 20, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          const SizedBox(height: 20),
          const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _Legend(color: Color(0xFF1A237E), label: "Ativo"),
              SizedBox(width: 16),
              _Legend(color: Colors.grey, label: "Livre"),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFilaAtendimento() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Fila de Atendimento (Ao Vivo)", style: GoogleFonts.manrope(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),
          _buildFilaRow("Maria Oliveira", "Profilaxia", "Aguardando", Colors.blue),
          const Divider(),
          _buildFilaRow("João Silva", "Ccanal", "Na Cadeira", Colors.orange),
          const Divider(),
          _buildFilaRow("Ana Costa", "Avaliação", "Finalizado", Colors.green),
        ],
      ),
    );
  }

  Widget _buildFilaRow(String name, String proc, String status, Color statusColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: const Color(0xFF1A237E).withOpacity(0.1),
            child: Text(name[0], style: const TextStyle(color: Color(0xFF1A237E))),
          ),
          const SizedBox(width: 16),
          Expanded(child: Text(name, style: GoogleFonts.manrope(fontWeight: FontWeight.bold))),
          Expanded(child: Text(proc, style: GoogleFonts.manrope(color: Colors.grey))),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: statusColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(status, style: GoogleFonts.manrope(color: statusColor, fontSize: 12, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  Widget _buildMetasBI() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Metas Mensais (BI)", style: GoogleFonts.manrope(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),
          _buildProgressTile("Faturamento Projetado", 0.82, Colors.blue),
          _buildProgressTile("Retenção", 0.60, Colors.orange),
          _buildProgressTile("NPS", 0.94, Colors.green),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFF8F9FA),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Row(
              children: [
                Icon(Icons.lightbulb_outline, color: Color(0xFFD4AF37)),
                SizedBox(width: 12),
                Expanded(child: Text("Dica: Foque na fidelização para aumentar o NPS em 2%.", style: TextStyle(fontSize: 12))),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressTile(String label, double value, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: const TextStyle(fontSize: 12)),
            Text("${(value * 100).toInt()}%", style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
          ],
        ),
        const SizedBox(height: 8),
        LinearProgressIndicator(value: value, backgroundColor: Colors.grey[200], color: color, minHeight: 8),
        const SizedBox(height: 16),
      ],
    );
  }
}

class _Legend extends StatelessWidget {
  final Color color;
  final String label;
  const _Legend({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(width: 12, height: 12, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
        const SizedBox(width: 8),
        Text(label, style: const TextStyle(fontSize: 12)),
      ],
    );
  }
}
