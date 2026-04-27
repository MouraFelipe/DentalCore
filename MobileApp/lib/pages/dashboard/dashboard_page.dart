import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/dashboard_provider.dart';
import '../../theme/app_colors.dart';
import 'widgets/sidebar.dart';
import 'widgets/top_bar.dart';
import 'widgets/metric_cards.dart';
import 'widgets/bi_widgets.dart';
import 'widgets/occupation_gauge.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  int _sidebarIndex = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<DashboardProvider>().carregarMetricasDoDia(DateTime.now());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Row(
        children: [
          // Sidebar Lateral (Fixa no Desktop/Web)
          Sidebar(
            selectedIndex: _sidebarIndex,
            onSelected: (idx) => setState(() => _sidebarIndex = idx),
          ),
          
          // Área Principal
          Expanded(
            child: Column(
              children: [
                // Barra Superior
                TopBar(
                  onNovoAgendamento: () {},
                  onNovoPaciente: () {},
                ),
                
                // Conteúdo Escrolável
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(28),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Saudação e Título
                        _GreetingHeader(),
                        const SizedBox(height: 28),
                        
                        // Linha de Métricas (Faltas, Realizadas, Próximos)
                        const MetricCardsRow(),
                        const SizedBox(height: 28),
                        
                        // Grade de Widgets BI (Fila, Ocupação, Ações, Metas)
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Coluna da Esquerda (Fila e Metas)
                            Expanded(
                              flex: 7,
                              child: Column(
                                children: [
                                  const FilaAtendimentoCard(),
                                  const SizedBox(height: 24),
                                  const MetasMensaisCard(),
                                ],
                              ),
                            ),
                            const SizedBox(width: 24),
                            
                            // Coluna da Direita (Ocupação e Ações)
                            Expanded(
                              flex: 4,
                              child: Column(
                                children: [
                                  const OccupationGauge(),
                                  const SizedBox(height: 24),
                                  QuickActionsPanel(
                                    onVerAgenda: () {},
                                    onNovoAgendamento: () {},
                                    onNovoPaciente: () {},
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _GreetingHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Bom dia, Dr. Roberto 👋',
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 24,
                fontWeight: FontWeight.w900,
                letterSpacing: -0.5,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Sua clínica está com 82% de aproveitamento hoje.',
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        
        // Seletor de período (Simulado)
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: AppColors.divider),
          ),
          child: Row(
            children: [
              const Icon(Icons.calendar_today_outlined, size: 14, color: AppColors.textSecondary),
              const SizedBox(width: 8),
              Text(
                'HOJE',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.5,
                ),
              ),
              const Icon(Icons.keyboard_arrow_down_rounded, color: AppColors.textSecondary),
            ],
          ),
        ),
      ],
    );
  }
}
