import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// Colored placeholder standing in for a video thumbnail, tinted by
/// exercise category and marked with a play glyph.
class ExerciseThumbnail extends StatelessWidget {
  final String category;
  final double? height;
  final double? width;
  final BorderRadius? borderRadius;

  const ExerciseThumbnail({
    super.key,
    required this.category,
    this.height,
    this.width,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    final tint = AppColors.tintFor(category);
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        color: tint.withValues(alpha: 0.14),
        borderRadius: borderRadius ?? BorderRadius.circular(8),
      ),
      child: Center(
        child: Container(
          width: 28,
          height: 28,
          decoration: BoxDecoration(color: tint, shape: BoxShape.circle),
          child: const Icon(
            Icons.play_arrow_rounded,
            color: Colors.white,
            size: 18,
          ),
        ),
      ),
    );
  }
}
