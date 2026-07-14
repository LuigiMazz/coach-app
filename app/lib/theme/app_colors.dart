import 'package:flutter/material.dart';

/// Warm, professional palette — derived from the Claude Design wireframe
/// (`project/Wireframes.dc.html`): warm neutrals with a single decisive
/// terracotta accent, in the spirit of Linear/Notion/Apple Fitness.
class AppColors {
  AppColors._();

  static const Color accent = Color(0xFFC1633A);
  static const Color accentSoft = Color(0xFFF0DDD1);
  static const Color accentSoftHover = Color(0xFFEBD0C0);

  static const Color background = Color(0xFFF8F6F2);
  static const Color canvas = Color(0xFFF3EFE9);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceMuted = Color(0xFFF0EEE9);

  static const Color textPrimary = Color(0xFF2B2723);
  static const Color textSecondary = Color(0x992B2723); // ~60%
  static const Color textTertiary = Color(0x732B2723); // ~45%

  static const Color border = Color(0x1F2B2723); // ~12%
  static const Color borderStrong = Color(0x332B2723); // ~20%

  static const Color placeholder = Color(0xFFE4DFD7);
  static const Color placeholderStrong = Color(0xFFD8D2C7);

  static const Color success = Color(0xFF4C7A5E);
  static const Color warning = Color(0xFFC1633A);
  static const Color danger = Color(0xFFB84C3E);

  /// Category → accent tint, used on exercise thumbnails / chips.
  static const Map<String, Color> categoryTints = {
    'Forza': Color(0xFFC1633A),
    'Mobilità': Color(0xFF6E8B7A),
    'Prevenzione': Color(0xFF7A8CA6),
    'Recupero': Color(0xFF9E7BB0),
    'Core': Color(0xFFC79B3D),
    'Performance': Color(0xFF4C7A5E),
  };

  static Color tintFor(String category) =>
      categoryTints[category] ?? accent;
}
