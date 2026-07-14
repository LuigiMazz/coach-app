import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

class AppProgressBar extends StatelessWidget {
  final int percent;
  final double height;

  const AppProgressBar({super.key, required this.percent, this.height = 6});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(height),
      child: LinearProgressIndicator(
        value: (percent.clamp(0, 100)) / 100,
        minHeight: height,
        backgroundColor: AppColors.surfaceMuted,
        valueColor: const AlwaysStoppedAnimation(AppColors.accent),
      ),
    );
  }
}
