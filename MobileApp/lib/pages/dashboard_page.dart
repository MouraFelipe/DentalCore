import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../providers/dashboard_provider.dart';
import '../theme/app_theme.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<DashboardProvider>().fetchDashboard(null);
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<DashboardProvider>();
    final dashboard = provider.dashboard;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Cockpit de Insights'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => provider.fetchDashboard(null),
          )
        ],
      ),
      body: provider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : provider.erro != null
              ? Center(child: Text(provider.erro!, style: const TextStyle(color: Colors.red)))
              : dashboard == null
                  ? const Center(child: Text('Nenhum dado disponível.'))
                  : SingleChildScrollView(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Hoje, ${dashboard.dataFormatada}',
                            style: GoogleFonts.manrope(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.primaryNavy,
                            ),
                          ),
                          const SizedBox(height: 20),
                          _buildTaxaAproveitamento(dashboard.taxaRealizacao),
                          const SizedBox(height: 24),
                          GridView.count(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            crossAxisCount: 2,
                            crossAxisSpacing: 16,
                            mainAxisSpacing: 16,
                            childAspectRatio: 1.1,
                            children: [
                              _buildMetricCard('Agendadas', dashboard.agendadas.toString(), Icons.calendar_today, Colors.blue),
                              _buildMetricCard('Realizadas', dashboard.realizadas.toString(), Icons.check_circle, Colors.green),
                              _buildMetricCard('Faltas', dashboard.faltas.toString(), Icons.person_off, Colors.orange),
                              _buildMetricCard('Canceladas', dashboard.canceladas.toString(), Icons.cancel, Colors.red),
                            ],
                          ),
                        ],
                      ),
                    ),
    );
  }

  Widget _buildTaxaAproveitamento(double taxa) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppTheme.primaryNavy, Color(0xFF3F51B5)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: AppTheme.primaryNavy.withOpacity(0.3), blurRadius: 15, offset: const Offset(0, 8)),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Aproveitamento do Dia',
                  style: TextStyle(color: Colors.white70, fontSize: 14),
                ),
                const SizedBox(height: 8),
                Text(
                  '${(taxa * 100).toStringAsFixed(1)}%',
                  style: const TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 60,
            width: 60,
            child: CircularProgressIndicator(
              value: taxa,
              backgroundColor: Colors.white24,
              color: AppTheme.secondaryGold,
              strokeWidth: 8,
            ),
          )
        ],
      ),
    );
  }

  Widget _buildMetricCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(icon, color: color, size: 28),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(value, style: GoogleFonts.manrope(fontSize: 24, fontWeight: FontWeight.bold, color: AppTheme.primaryNavy)),
              Text(title, style: GoogleFonts.manrope(fontSize: 13, color: AppTheme.textLight)),
            ],
          )
        ],
      ),
    );
  }
}
