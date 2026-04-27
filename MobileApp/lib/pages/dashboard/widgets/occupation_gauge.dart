import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../providers/dashboard_provider.dart';
import '../../../theme/app_colors.dart';

class QuickActionsPanel extends StatelessWidget {
  final VoidCallback onVerAgenda;
  final VoidCallback onNovoAgendamento;
  final VoidCallback onNovoPaciente;

  const QuickActionsPanel({
    super.key,
    required this.onVerAgenda,
    required this.onNovoAgendamento,
    required this.onNovoPaciente,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.navy,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: AppColors.navy.withValues(alpha: 0.3), blurRadius: 20, offset: const Offset(0, 8))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Ações Rápidas', style: GoogleFonts.manrope(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w700)),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(child: _ActionBtn(icon: Icons.calendar_month_rounded, label: 'Ver Agenda', gold: false, onTap: onVerAgenda)),
              const SizedBox(width: 10),
              Expanded(child: _ActionBtn(icon: Icons.add_circle_rounded, label: 'Novo Agendamento', gold: true, onTap: onNovoAgendamento)),
            ],
          ),
          const SizedBox(height: 10),
          SizedBox(width: 158, child: _ActionBtn(icon: Icons.person_add_alt_1_rounded, label: 'Novo Paciente', gold: false, onTap: onNovoPaciente)),
        ],
      ),
    );
  }
}

class _ActionBtn extends StatelessWidget {
  final IconData icon; final String label; final bool gold; final VoidCallback onTap;
  const _ActionBtn({required this.icon, required this.label, required this.gold, required this.onTap});
  @override
  Widget build(BuildContext context) => Material(color: gold ? AppColors.gold : AppColors.navyMedium, borderRadius: BorderRadius.circular(10), child: InkWell(onTap: onTap, borderRadius: BorderRadius.circular(10), splashColor: Colors.white.withValues(alpha: 0.1), child: Padding(padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12), child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(icon, color: gold ? Colors.white : Colors.white70, size: 15), const SizedBox(width: 7), Flexible(child: Text(label, style: GoogleFonts.manrope(color: gold ? Colors.white : Colors.white70, fontSize: 12, fontWeight: FontWeight.w600), overflow: TextOverflow.ellipsis))]))));
}

class OccupationGauge extends StatelessWidget {
  const OccupationGauge({super.key});
  @override
  Widget build(BuildContext context) {
    final p = context.watch<DashboardProvider>();
    final ocupacao = p.metrics.ocupacao;

    return Container(
      height: 280, // Altura fixa garantida para evitar hit test pass failures
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.divider)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Ocupação do Dia', style: GoogleFonts.manrope(color: AppColors.textPrimary, fontSize: 13, fontWeight: FontWeight.w700)),
          const Spacer(),
          Center(
            child: SizedBox(
              width: 140, 
              height: 140, 
              child: _DonutChart(value: ocupacao),
            ),
          ),
          const Spacer(),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: const [_LegendDot(color: AppColors.navy, label: 'Ativo'), SizedBox(width: 16), _LegendDot(color: AppColors.divider, label: 'Livre')]),
        ],
      ),
    );
  }
}

class _DonutChart extends StatefulWidget {
  final double value; const _DonutChart({required this.value});
  @override State<_DonutChart> createState() => _DonutChartState();
}
class _DonutChartState extends State<_DonutChart> with SingleTickerProviderStateMixin {
  late AnimationController _ctrl; late Animation<double> _anim;
  @override void initState() { super.initState(); _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 1200)); _anim = Tween<double>(begin: 0, end: widget.value).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOutCubic)); if (mounted) _ctrl.forward(); }
  @override void dispose() { _ctrl.dispose(); super.dispose(); }
  @override Widget build(BuildContext context) => AnimatedBuilder(animation: _anim, builder: (context, child) => RepaintBoundary(child: CustomPaint(painter: _DonutPainter(value: _anim.value), child: Center(child: Column(mainAxisSize: MainAxisSize.min, children: [Text('${(_anim.value * 100).toInt()}%', style: GoogleFonts.manrope(color: AppColors.textPrimary, fontSize: 20, fontWeight: FontWeight.w900)), Text('UTILIZAÇÃO', style: GoogleFonts.manrope(color: AppColors.textDisabled, fontSize: 8, fontWeight: FontWeight.w700, letterSpacing: 0.6))])))));
}

class _DonutPainter extends CustomPainter {
  final double value; _DonutPainter({required this.value});
  @override void paint(Canvas canvas, Size size) {
    if (size.width == 0 || size.height == 0) return;
    final cx = size.width/2; final cy = size.height/2; final r = min(cx, cy)-10; const sw = 14.0; final rect = Rect.fromCircle(center: Offset(cx, cy), radius: r);
    canvas.drawArc(rect, -pi/2, 2*pi, false, Paint()..color = AppColors.divider..style = PaintingStyle.stroke..strokeWidth = sw..strokeCap = StrokeCap.round);
    canvas.drawArc(rect, -pi/2, 2*pi*value, false, Paint()..color = AppColors.navy..style = PaintingStyle.stroke..strokeWidth = sw..strokeCap = StrokeCap.round);
  }
  @override bool shouldRepaint(covariant _DonutPainter oldDelegate) => oldDelegate.value != value;
}

class _LegendDot extends StatelessWidget {
  final Color color; final String label; const _LegendDot({required this.color, required this.label});
  @override Widget build(BuildContext context) => Row(children: [Container(width: 8, height: 8, decoration: BoxDecoration(color: color, shape: BoxShape.circle)), const SizedBox(width: 5), Text(label, style: GoogleFonts.manrope(color: AppColors.textSecondary, fontSize: 11))]);
}
