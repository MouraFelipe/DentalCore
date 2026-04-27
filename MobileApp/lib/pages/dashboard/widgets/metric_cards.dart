import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../providers/dashboard_provider.dart';
import '../../../theme/app_colors.dart';

class MetricCardsRow extends StatelessWidget {
  const MetricCardsRow({super.key});

  @override
  Widget build(BuildContext context) {
    // Otimização: Rebuild apenas quando as métricas mudarem
    final m = context.select<DashboardProvider, DashboardMetrics>((p) => p.metrics);

    return Row(
      children: [
        Expanded(
          child: _AnimatedCard(
            delay: Duration.zero,
            child: AlertCard(
              valor:    m.faltas.toString(),
              sublabel: 'Acima da média semanal',
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _AnimatedCard(
            delay: const Duration(milliseconds: 100),
            child: SuccessCard(
              valor:    m.realizadas.toString(),
              sublabel: 'Meta diária atingida',
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _AnimatedCard(
            delay: const Duration(milliseconds: 200),
            child: InfoCard(
              valor:    m.proximos.toString(),
              sublabel: 'Atendimento ${m.ultimoAtendimento}',
            ),
          ),
        ),
      ],
    );
  }
}

class _AnimatedCard extends StatefulWidget {
  final Widget   child;
  final Duration delay;
  const _AnimatedCard({required this.child, required this.delay});
  @override
  State<_AnimatedCard> createState() => _AnimatedCardState();
}

class _AnimatedCardState extends State<_AnimatedCard> with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double>   _fade;
  late Animation<Offset>   _slide;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 500));
    _fade  = CurvedAnimation(parent: _ctrl, curve: Curves.easeOut);
    _slide = Tween<Offset>(begin: const Offset(0, 0.06), end: Offset.zero).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOut));
    Future.delayed(widget.delay, () { if (mounted) _ctrl.forward(); });
  }

  @override
  void dispose() { _ctrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) => FadeTransition(opacity: _fade, child: SlideTransition(position: _slide, child: widget.child));
}

class AlertCard extends StatelessWidget {
  final String valor;
  final String sublabel;
  const AlertCard({super.key, required this.valor, required this.sublabel});
  @override
  Widget build(BuildContext context) => _BaseCard(
    tag: 'DESTAQUE MÁXIMO', tagColor: AppColors.danger, bgColor: AppColors.dangerSurface,
    iconBg: AppColors.danger, icon: Icons.warning_rounded, valor: valor, label: 'Faltas', 
    sublabel: sublabel, sublabelColor: AppColors.danger,
  );
}

class SuccessCard extends StatelessWidget {
  final String valor;
  final String sublabel;
  const SuccessCard({super.key, required this.valor, required this.sublabel});
  @override
  Widget build(BuildContext context) => _BaseCard(
    tag: 'CONCLUÍDOS', tagColor: AppColors.success, bgColor: AppColors.successSurface,
    iconBg: AppColors.success, icon: Icons.check_circle_rounded, valor: valor, label: 'Realizadas', 
    sublabel: sublabel, sublabelColor: AppColors.success,
  );
}

class InfoCard extends StatelessWidget {
  final String valor;
  final String sublabel;
  const InfoCard({super.key, required this.valor, required this.sublabel});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: AppColors.navy, borderRadius: BorderRadius.circular(16), boxShadow: [BoxShadow(color: AppColors.navy.withValues(alpha: 0.25), blurRadius: 16, offset: const Offset(0, 6))]),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('PRÓXIMOS', style: GoogleFonts.manrope(color: AppColors.gold, fontSize: 10, fontWeight: FontWeight.w800, letterSpacing: 0.8)),
              Container(width: 32, height: 32, decoration: const BoxDecoration(color: AppColors.gold, shape: BoxShape.circle), child: const Icon(Icons.schedule_rounded, color: Colors.white, size: 16)),
            ],
          ),
          const SizedBox(height: 12),
          Text(valor, style: GoogleFonts.manrope(color: Colors.white, fontSize: 38, fontWeight: FontWeight.w900, height: 1)),
          Text('Restantes', style: GoogleFonts.manrope(color: Colors.white60, fontSize: 13, fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          Text(sublabel, style: GoogleFonts.manrope(color: Colors.white38, fontSize: 11)),
        ],
      ),
    );
  }
}

class _BaseCard extends StatelessWidget {
  final String tag; final Color tagColor; final Color bgColor; final Color iconBg; final IconData icon; final String valor; final String label; final String sublabel; final Color sublabelColor;
  const _BaseCard({required this.tag, required this.tagColor, required this.bgColor, required this.iconBg, required this.icon, required this.valor, required this.label, required this.sublabel, required this.sublabelColor});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(16), border: Border.all(color: tagColor.withValues(alpha: 0.12), width: 1.5)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(tag, style: GoogleFonts.manrope(color: tagColor, fontSize: 9, fontWeight: FontWeight.w800, letterSpacing: 0.8)),
              Container(width: 32, height: 32, decoration: BoxDecoration(color: iconBg, shape: BoxShape.circle), child: Icon(icon, color: Colors.white, size: 16)),
            ],
          ),
          const SizedBox(height: 12),
          Text(valor, style: GoogleFonts.manrope(color: tagColor, fontSize: 38, fontWeight: FontWeight.w900, height: 1)),
          Text(label, style: GoogleFonts.manrope(color: tagColor.withValues(alpha: 0.65), fontSize: 13, fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          Text(sublabel, style: GoogleFonts.manrope(color: sublabelColor, fontSize: 11, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}
