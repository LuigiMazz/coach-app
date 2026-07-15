import 'package:flutter/material.dart';

import '../models/athlete.dart';
import '../theme/app_colors.dart';

class AthleteStatusBadge extends StatelessWidget {
  final AthleteStatus status;

  const AthleteStatusBadge({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    final isActive = status == AthleteStatus.active;
    final color = isActive ? AppColors.success : AppColors.textSecondary;
    final bg = isActive
        ? AppColors.success.withValues(alpha: 0.12)
        : AppColors.surfaceMuted;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        isActive ? 'Attivo' : 'Invitato',
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }
}
