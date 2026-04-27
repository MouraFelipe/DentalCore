import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../providers/dashboard_provider.dart';
import '../../../theme/app_colors.dart';

class FilaAtendimentoCard extends StatelessWidget {
  const FilaAtendimentoCard({super.key});

  @override
  Widget build(BuildContext context) {
    final p = context.watch<DashboardProvider>();
    final fila = p.fila;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.divider)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Fila de Atendimento', style: GoogleFonts.manrope(color: AppColors.textPrimary, fontSize: 13, fontWeight: FontWeight.w700)),
              _LiveBadge(),
            ],
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Row(
              children: const [
                Expanded(flex: 4, child: _ColHeader('Paciente')),
                Expanded(flex: 4, child: _ColHeader('Procedimento')),
                Expanded(flex: 3, child: _ColHeader('Status')),
              ],
            ),
          ),
          const SizedBox(height: 6),
          const Divider(height: 1, color: AppColors.divider),
          const SizedBox(height: 4),
          ...fila.map((p) => _FilaRow(paciente: p)),
        ],
      ),
    );
  }
}

class _LiveBadge extends StatefulWidget {
  @override State<_LiveBadge> createState() => _LiveBadgeState();
}
class _LiveBadgeState extends State<_LiveBadge> with SingleTickerProviderStateMixin {
  late AnimationController _ctrl; late Animation<double> _pulse;
  @override void initState() { super.initState(); _ctrl = AnimationController(vsync: this, duration: const Duration(seconds: 1))..repeat(reverse: true); _pulse = Tween<double>(begin: 0.4, end: 1.0).animate(_ctrl); }
  @override void dispose() { _ctrl.dispose(); super.dispose(); }
  @override Widget build(BuildContext context) => Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4), decoration: BoxDecoration(color: AppColors.dangerSurface, borderRadius: BorderRadius.circular(6)), child: Row(children: [FadeTransition(opacity: _pulse, child: Container(width: 6, height: 6, decoration: const BoxDecoration(color: AppColors.danger, shape: BoxShape.circle))), const SizedBox(width: 5), Text('AO VIVO', style: GoogleFonts.manrope(color: AppColors.danger, fontSize: 9, fontWeight: FontWeight.w800, letterSpacing: 0.5))]));
}

class _ColHeader extends StatelessWidget {
  final String text; const _ColHeader(this.text);
  @override Widget build(BuildContext context) => Text(text, style: GoogleFonts.manrope(color: AppColors.textDisabled, fontSize: 11, fontWeight: FontWeight.w700, letterSpacing: 0.3));
}

class _FilaRow extends StatelessWidget {
  final FilaPaciente paciente; const _FilaRow({required this.paciente});
  @override Widget build(BuildContext context) {
    final cor = Color(paciente.cor);
    return Padding(padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 4), child: Row(children: [Expanded(flex: 4, child: Row(children: [CircleAvatar(radius: 16, backgroundColor: cor.withOpacity(0.15), child: Text(paciente.iniciais, style: GoogleFonts.manrope(color: cor, fontSize: 10, fontWeight: FontWeight.w800))), const SizedBox(width: 10), Flexible(child: Text(paciente.nome, style: GoogleFonts.manrope(color: AppColors.textPrimary, fontSize: 12, fontWeight: FontWeight.w600), overflow: TextOverflow.ellipsis))])), Expanded(flex: 4, child: Text(paciente.procedimento, style: GoogleFonts.manrope(color: AppColors.textSecondary, fontSize: 12), overflow: TextOverflow.ellipsis)), Expanded(flex: 3, child: _StatusLabel(status: paciente.status))]));
  }
}

class _StatusLabel extends StatelessWidget {
  final FilaStatus status; const _StatusLabel({required this.status});
  @override Widget build(BuildContext context) {
    final (label, bg, fg) = switch (status) {
      FilaStatus.naCadeira  => ('NA CADEIRA', AppColors.warningSurface, AppColors.warning),
      FilaStatus.aguardando => ('AGUARDANDO', AppColors.infoSurface, AppColors.info),
      FilaStatus.finalizado => ('FINALIZADO', AppColors.successSurface, AppColors.success),
    };
    return Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4), decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(6)), child: Text(label, style: GoogleFonts.manrope(color: fg, fontSize: 9, fontWeight: FontWeight.w800, letterSpacing: 0.4)));
  }
}

class MetasMensaisCard extends StatelessWidget {
  const MetasMensaisCard({super.key});
  @override Widget build(BuildContext context) {
    final p = context.watch<DashboardProvider>();
    final metas = p.metas;
    return Container(padding: const EdgeInsets.all(20), decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.divider)), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('Metas Mensais (BI)', style: GoogleFonts.manrope(color: AppColors.textPrimary, fontSize: 13, fontWeight: FontWeight.w700)), const SizedBox(height: 20), ...metas.map((m) => Padding(padding: const EdgeInsets.only(bottom: 18), child: _ProgressBar(meta: m))), const SizedBox(height: 4), _DicaEstrategica()]));
  }
}

class _ProgressBar extends StatefulWidget {
  final MetaMensal meta; const _ProgressBar({required this.meta});
  @override State<_ProgressBar> createState() => _ProgressBarState();
}
class _ProgressBarState extends State<_ProgressBar> with SingleTickerProviderStateMixin {
  late AnimationController _ctrl; late Animation<double> _anim;
  @override void initState() { super.initState(); _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 1000)); _anim = Tween<double>(begin: 0, end: widget.meta.valor).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOutCubic)); Future.delayed(const Duration(milliseconds: 300), () { if (mounted) _ctrl.forward(); }); }
  @override void dispose() { _ctrl.dispose(); super.dispose(); }
  @override Widget build(BuildContext context) {
    final cor = Color(widget.meta.cor);
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text(widget.meta.label, style: GoogleFonts.manrope(color: AppColors.textPrimary, fontSize: 12, fontWeight: FontWeight.w500)), AnimatedBuilder(animation: _anim, builder: (_, __) => Text('${(_anim.value * 100).toInt()}%', style: GoogleFonts.manrope(color: cor, fontSize: 12, fontWeight: FontWeight.w800)))]), const SizedBox(height: 6), ClipRRect(borderRadius: BorderRadius.circular(6), child: AnimatedBuilder(animation: _anim, builder: (_, __) => LinearProgressIndicator(value: _anim.value, minHeight: 7, backgroundColor: AppColors.divider, valueColor: AlwaysStoppedAnimation<Color>(cor))))]);
  }
}

class _DicaEstrategica extends StatelessWidget {
  @override Widget build(BuildContext context) => Container(padding: const EdgeInsets.all(14), decoration: BoxDecoration(color: AppColors.background, borderRadius: BorderRadius.circular(10), border: Border.all(color: AppColors.divider)), child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [Container(padding: const EdgeInsets.all(6), decoration: BoxDecoration(color: AppColors.goldSurface, borderRadius: BorderRadius.circular(6)), child: const Icon(Icons.trending_up_rounded, color: AppColors.gold, size: 14)), const SizedBox(width: 10), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('DICA ESTRATÉGICA', style: GoogleFonts.manrope(color: AppColors.gold, fontSize: 9, fontWeight: FontWeight.w800, letterSpacing: 0.5)), const SizedBox(height: 4), Text('Sua conversão de avaliações aumentou 12% este mês.', style: GoogleFonts.manrope(color: AppColors.textPrimary, fontSize: 11, height: 1.5))]))]));
}
