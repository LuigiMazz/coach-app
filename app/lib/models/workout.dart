class WorkoutExercise {
  final String exerciseId;
  final String name;
  final String category;
  final String setsLabel;
  final String rest;
  final String instructions;
  final bool done;

  const WorkoutExercise({
    required this.exerciseId,
    required this.name,
    required this.category,
    required this.setsLabel,
    this.rest = '',
    this.instructions = '',
    this.done = false,
  });

  WorkoutExercise copyWith({bool? done}) {
    return WorkoutExercise(
      exerciseId: exerciseId,
      name: name,
      category: category,
      setsLabel: setsLabel,
      rest: rest,
      instructions: instructions,
      done: done ?? this.done,
    );
  }
}

class TodayWorkout {
  final String programName;
  final int week;
  final String dayLabel;
  final List<WorkoutExercise> exercises;

  const TodayWorkout({
    required this.programName,
    required this.week,
    required this.dayLabel,
    required this.exercises,
  });
}

enum Difficulty { facile, corretto, difficile }

extension DifficultyLabel on Difficulty {
  String get label {
    switch (this) {
      case Difficulty.facile:
        return 'Facile';
      case Difficulty.corretto:
        return 'Corretto';
      case Difficulty.difficile:
        return 'Difficile';
    }
  }
}
