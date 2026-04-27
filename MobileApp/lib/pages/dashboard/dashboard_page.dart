import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
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
  int  _sidebarIndex = 0;
  bool _loaded       = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && !_loaded) {
        context.read<DashboardProvider>().carregarMetricasDoDia(DateTime.now());
        _loaded = true;
      }
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
                
                // Conteúdo Escrolável e Responsivo (High-Performance Slivers)
                Expanded(
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final isMobile = constraints.maxWidth < 1100;
                      return IgnorePointer(
                        ignoring: context.watch<DashboardProvider>().isLoading,
                        child: AnimatedOpacity(
                          opacity:  context.watch<DashboardProvider>().isLoading ? 0.7 : 1,
                          duration: const Duration(milliseconds: 300),
                          child: CustomScrollView(
                            physics: const BouncingScrollPhysics(),
                            slivers: [
                              const SliverToBoxAdapter(child: SizedBox(height: 28)),
                              SliverPadding(
                                padding: const EdgeInsets.symmetric(horizontal: 28),
                                sliver: SliverToBoxAdapter(child: _GreetingHeader()),
                              ),
                              const SliverToBoxAdapter(child: SizedBox(height: 28)),
                              SliverPadding(
                                padding: const EdgeInsets.symmetric(horizontal: 28),
                                sliver: const SliverToBoxAdapter(child: MetricCardsRow()),
                              ),
                              const SliverToBoxAdapter(child: SizedBox(height: 28)),
                              SliverPadding(
                                padding: const EdgeInsets.fromLTRB(28, 0, 28, 40),
                                sliver: SliverToBoxAdapter(
                                  child: isMobile 
                                    ? _buildVerticalLayout() 
                                    : _buildHorizontalLayout(),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVerticalLayout() {
    return Column(
      children: [
        const FilaAtendimentoCard(),
        const SizedBox(height: 24),
        const MetasMensaisCard(),
        const SizedBox(height: 24),
        const OccupationGauge(),
        const SizedBox(height: 24),
        QuickActionsPanel(
          onVerAgenda: () {},
          onNovoAgendamento: () {},
          onNovoPaciente: () {},
        ),
      ],
    );
  }

  Widget _buildHorizontalLayout() {
    return Row(
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
              'Olá, Dr. Roberto',
              style: GoogleFonts.manrope(
                color: AppColors.textPrimary,
                fontSize: 24,
                fontWeight: FontWeight.w800,
              ),
            ),
            Text(
              'Acompanhe o desempenho da sua clínica hoje.',
              style: GoogleFonts.manrope(
                color: AppColors.textSecondary,
                fontSize: 14,
              ),
            ),
          ],
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppColors.divider),
          ),
          child: Row(
            children: [
              const Icon(Icons.calendar_today_rounded, size: 14, color: AppColors.navy),
              const SizedBox(width: 8),
              Text(
                'HOJE',
                style: GoogleFonts.manrope(
                  color: AppColors.navy,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const Icon(Icons.keyboard_arrow_down_rounded, size: 18, color: AppColors.textDisabled),
            ],
          ),
        ),
      ],
    );
  }
}
