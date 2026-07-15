import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../data/mock_data.dart';
import '../../theme/app_colors.dart';
import '../../widgets/exercise_thumbnail.dart';

class TodayWorkoutScreen extends StatelessWidget {
  const TodayWorkoutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final workout = MockData.todayWorkout;
    final firstIncomplete = workout.exercises.firstWhere(
      (e) => !e.done,
      orElse: () => workout.exercises.first,
    );

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(18, 20, 18, 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          workout.dayLabel,
                          style: const TextStyle(
                            fontSize: 13,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          workout.programName,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    tooltip: 'Vista professionista (demo)',
                    icon: const Icon(
                      Icons.switch_account_outlined,
                      color: AppColors.textTertiary,
                    ),
                    onPressed: () => context.go('/dashboard'),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.fromLTRB(18, 8, 18, 8),
                itemCount: workout.exercises.length,
                separatorBuilder: (_, __) => const SizedBox(height: 10),
                itemBuilder: (context, i) {
                  final w = workout.exercises[i];
                  return Opacity(
                    opacity: w.done ? 0.5 : 1,
                    child: InkWell(
                      onTap: () => context.push('/workout/${w.exerciseId}'),
                      borderRadius: BorderRadius.circular(10),
                      child: Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          border: Border.all(color: AppColors.border),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          children: [
                            ExerciseThumbnail(
                              category: w.category,
                              width: 48,
                              height: 48,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    w.name,
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                      decoration: w.done
                                          ? TextDecoration.lineThrough
                                          : null,
                                    ),
                                  ),
                                  Text(
                                    w.setsLabel,
                                    style: const TextStyle(
                                      fontSize: 11,
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              width: 22,
                              height: 22,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: w.done
                                    ? AppColors.accent
                                    : Colors.transparent,
                                border: Border.all(
                                  color: w.done
                                      ? AppColors.accent
                                      : AppColors.placeholderStrong,
                                  width: 2,
                                ),
                              ),
                              child: w.done
                                  ? const Icon(
                                      Icons.check,
                                      size: 14,
                                      color: Colors.white,
                                    )
                                  : null,
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(18),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () =>
                      context.push('/workout/${firstIncomplete.exerciseId}'),
                  child: const Text('Inizia allenamento'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
