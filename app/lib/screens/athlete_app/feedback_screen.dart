import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../data/mock_data.dart';
import '../../models/workout.dart';
import '../../theme/app_colors.dart';

class FeedbackScreen extends StatefulWidget {
  final String exerciseId;

  const FeedbackScreen({super.key, required this.exerciseId});

  @override
  State<FeedbackScreen> createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  Difficulty _difficulty = Difficulty.corretto;
  int _pain = 2;
  final _noteCtrl = TextEditingController();

  @override
  void dispose() {
    _noteCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final WorkoutExercise w = MockData.todayWorkout.exercises.firstWhere(
      (e) => e.exerciseId == widget.exerciseId,
      orElse: () => MockData.todayWorkout.exercises.first,
    );

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(18, 20, 18, 8),
              child: Column(
                children: [
                  const Text(
                    'Come è andato?',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    w.name,
                    style: const TextStyle(
                      fontSize: 13,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(18, 12, 18, 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Difficoltà percepita',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        for (final d in Difficulty.values)
                          Expanded(
                            child: Padding(
                              padding: EdgeInsets.only(
                                right: d == Difficulty.values.last ? 0 : 8,
                              ),
                              child: InkWell(
                                onTap: () => setState(() => _difficulty = d),
                                borderRadius: BorderRadius.circular(8),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 12,
                                  ),
                                  decoration: BoxDecoration(
                                    color: _difficulty == d
                                        ? AppColors.accentSoft
                                        : Colors.transparent,
                                    border: Border.all(
                                      color: _difficulty == d
                                          ? AppColors.accent
                                          : AppColors.borderStrong,
                                      width: _difficulty == d ? 1.5 : 1,
                                    ),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    d.label,
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(fontSize: 12),
                                  ),
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      'Dolore (0–10)',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        for (var n = 0; n <= 10; n++)
                          Expanded(
                            child: Padding(
                              padding: EdgeInsets.only(right: n == 10 ? 0 : 4),
                              child: AspectRatio(
                                aspectRatio: 1,
                                child: InkWell(
                                  onTap: () => setState(() => _pain = n),
                                  borderRadius: BorderRadius.circular(5),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: _pain == n
                                          ? AppColors.accent
                                          : AppColors.surfaceMuted,
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    child: Center(
                                      child: Text(
                                        '$n',
                                        style: TextStyle(
                                          fontSize: 11,
                                          color: _pain == n
                                              ? Colors.white
                                              : AppColors.textSecondary,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      'Nota (facoltativa)',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: _noteCtrl,
                      maxLines: 3,
                      decoration: const InputDecoration(
                        hintText: 'Aggiungi una nota per il tuo coach…',
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(18),
              decoration: const BoxDecoration(
                color: AppColors.surface,
                border: Border(top: BorderSide(color: AppColors.border)),
              ),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    MockData.markWorkoutExerciseDone(widget.exerciseId);
                    context.go('/workout');
                  },
                  child: const Text('Invia feedback'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
