import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme/app_colors.dart';

class TopBar extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback onNovoAgendamento;
  final VoidCallback onNovoPaciente;

  const TopBar({
    super.key,
    required this.onNovoAgendamento,
    required this.onNovoPaciente,
  });

  @override
  Size get preferredSize => const Size.fromHeight(64);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 64,
      padding: const EdgeInsets.symmetric(horizontal: 28),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(
          bottom: BorderSide(color: AppColors.divider, width: 1),
        ),
      ),
      child: Row(
        children: [
          Text('DentalCockpit',
              style: GoogleFonts.manrope(
                color:      AppColors.textPrimary,
                fontSize:   17,
                fontWeight: FontWeight.w800,
                letterSpacing: -0.5,
              )),
          const SizedBox(width: 24),
          Expanded(
            child: _SearchField(),
          ),
          const SizedBox(width: 16),
          _PrimaryBtn(
            label: 'Novo Agendamento',
            icon:  Icons.add_rounded,
            onTap: onNovoAgendamento,
          ),
          const SizedBox(width: 8),
          _OutlineBtn(
            label: 'Novo Paciente',
            onTap: onNovoPaciente,
          ),
          const SizedBox(width: 16),
          _IconBtn(Icons.notifications_none_rounded),
          const SizedBox(width: 2),
          _IconBtn(Icons.settings_outlined),
          const SizedBox(width: 12),
          CircleAvatar(
            radius:          17,
            backgroundColor: AppColors.gold,
            child: Text('R',
                style: GoogleFonts.manrope(
                  color:      Colors.white,
                  fontWeight: FontWeight.w800,
                  fontSize:   13,
                )),
          ),
        ],
      ),
    );
  }
}

class _SearchField extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 38,
      decoration: BoxDecoration(
        color:        AppColors.background,
        borderRadius: BorderRadius.circular(10),
        border:       Border.all(color: AppColors.divider),
      ),
      child: Row(
        children: [
          const SizedBox(width: 12),
          const Icon(Icons.search_rounded, size: 16,
              color: AppColors.textDisabled),
          const SizedBox(width: 8),
          Text('Pesquisar no sistema...',
              style: GoogleFonts.manrope(
                color:    AppColors.textDisabled,
                fontSize: 13,
              )),
        ],
      ),
    );
  }
}

class _PrimaryBtn extends StatelessWidget {
  final String       label;
  final IconData     icon;
  final VoidCallback onTap;

  const _PrimaryBtn({
    required this.label,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color:        AppColors.navy,
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        onTap:        onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
          child: Row(
            children: [
              Icon(icon, color: Colors.white, size: 15),
              const SizedBox(width: 6),
              Text(label,
                  style: GoogleFonts.manrope(
                    color:      Colors.white,
                    fontSize:   12,
                    fontWeight: FontWeight.w600,
                  )),
            ],
          ),
        ),
      ),
    );
  }
}

class _OutlineBtn extends StatelessWidget {
  final String       label;
  final VoidCallback onTap;

  const _OutlineBtn({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color:        Colors.transparent,
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        onTap:        onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
          decoration: BoxDecoration(
            border:       Border.all(color: AppColors.divider, width: 1.5),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(label,
              style: GoogleFonts.manrope(
                color:      AppColors.textPrimary,
                fontSize:   12,
                fontWeight: FontWeight.w600,
              )),
        ),
      ),
    );
  }
}

class _IconBtn extends StatelessWidget {
  final IconData icon;
  const _IconBtn(this.icon);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon:        Icon(icon, size: 20, color: AppColors.textSecondary),
      onPressed:   () {},
      splashRadius: 18,
      padding:     EdgeInsets.zero,
      constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
    );
  }
}
