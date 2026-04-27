import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme/app_colors.dart';

class Sidebar extends StatelessWidget {
  final int           selectedIndex;
  final ValueChanged<int> onSelected;

  const Sidebar({
    super.key,
    required this.selectedIndex,
    required this.onSelected,
  });

  static const _items = [
    (Icons.grid_view_rounded,              'Dashboard'),
    (Icons.calendar_month_rounded,         'Agenda'),
    (Icons.people_alt_rounded,             'Pacientes'),
    (Icons.account_balance_wallet_rounded, 'Financeiro'),
    (Icons.bar_chart_rounded,              'Relatórios'),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      width:  220,
      color:  AppColors.navy,
      child:  Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _Logo(),
          Expanded(
            child: ListView.separated(
              padding:          const EdgeInsets.symmetric(horizontal: 12),
              itemCount:        _items.length,
              separatorBuilder: (_, __) => const SizedBox(height: 2),
              itemBuilder: (_, i) => _NavItem(
                icon:     _items[i].$1,
                label:    _items[i].$2,
                selected: selectedIndex == i,
                onTap:    () => onSelected(i),
              ),
            ),
          ),
          const Divider(color: AppColors.navyLight, thickness: 1, height: 1),
          const SizedBox(height: 8),
          _NavItem(
            icon: Icons.help_outline_rounded, label: 'Suporte',
            selected: false, onTap: () {},
            padding: const EdgeInsets.symmetric(horizontal: 12),
          ),
          _NavItem(
            icon: Icons.logout_rounded, label: 'Sair',
            selected: false, onTap: () {},
            padding: const EdgeInsets.fromLTRB(12, 0, 12, 28),
          ),
        ],
      ),
    );
  }
}

class _Logo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 28, 20, 32),
      child: Row(
        children: [
          Container(
            width: 38, height: 38,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [AppColors.gold, AppColors.goldLight],
                begin:  Alignment.topLeft,
                end:    Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color:       AppColors.gold.withOpacity(0.4),
                  blurRadius:  8,
                  offset:      const Offset(0, 4),
                ),
              ],
            ),
            child: const Icon(Icons.local_hospital_rounded,
                color: Colors.white, size: 20),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Dental Clinical',
                  style: GoogleFonts.manrope(
                    color:      Colors.white,
                    fontSize:   13,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.2,
                  )),
              Text('GESTÃO EXECUTIVA',
                  style: GoogleFonts.manrope(
                    color:      AppColors.gold,
                    fontSize:   8,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.4,
                  )),
            ],
          ),
        ],
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData     icon;
  final String       label;
  final bool         selected;
  final VoidCallback onTap;
  final EdgeInsets   padding;

  const _NavItem({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
    this.padding = EdgeInsets.zero,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: Material(
        color:        Colors.transparent,
        borderRadius: BorderRadius.circular(10),
        child: InkWell(
          onTap:        onTap,
          borderRadius: BorderRadius.circular(10),
          splashColor:  AppColors.gold.withOpacity(0.1),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
            decoration: BoxDecoration(
              color: selected
                  ? AppColors.gold.withOpacity(0.12)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(10),
              border: selected
                  ? const Border(
                      left: BorderSide(color: AppColors.gold, width: 3))
                  : null,
            ),
            child: Row(
              children: [
                Icon(icon,
                    size:  18,
                    color: selected
                        ? AppColors.gold
                        : const Color(0xFF8A9BBE)),
                const SizedBox(width: 12),
                Text(label,
                    style: GoogleFonts.manrope(
                      color: selected
                          ? AppColors.gold
                          : const Color(0xFF8A9BBE),
                      fontSize:   13,
                      fontWeight: selected
                          ? FontWeight.w700
                          : FontWeight.w500,
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
