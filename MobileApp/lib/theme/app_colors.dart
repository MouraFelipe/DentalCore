import 'package:flutter/material.dart';

/// Paleta oficial do DentalCore.
/// NUNCA use cores hardcoded fora deste arquivo.
abstract final class AppColors {
  // ── Primárias ──────────────────────────────────────────────
  static const navy        = Color(0xFF0D1B3E);
  static const navyMedium  = Color(0xFF162444);
  static const navyLight   = Color(0xFF1E2E52);
  static const gold        = Color(0xFFE8A020);
  static const goldLight   = Color(0xFFF5B942);
  static const goldSurface = Color(0xFFFFF8EC);

  // ── Superfície / Fundo ──────────────────────────────────────
  static const background  = Color(0xFFF4F6FA);
  static const surface     = Color(0xFFFFFFFF);
  static const divider     = Color(0xFFE8ECF4);

  // ── Texto ───────────────────────────────────────────────────
  static const textPrimary   = Color(0xFF0D1B3E);
  static const textSecondary = Color(0xFF6B7A99);
  static const textDisabled  = Color(0xFF9AA5BE);

  // ── Semânticas ──────────────────────────────────────────────
  static const success        = Color(0xFF1B8A4E);
  static const successSurface = Color(0xFFE8F7EF);
  static const danger         = Color(0xFFD32F2F);
  static const dangerSurface  = Color(0xFFFDECEC);
  static const warning        = Color(0xFFE65100);
  static const warningSurface = Color(0xFFFFF3E0);
  static const info           = Color(0xFF1565C0);
  static const infoSurface    = Color(0xFFE8F0FE);
}
