class ProgramExerciseItem {
  final String exerciseName;
  final int sets;
  final int reps;
  final String rest;
  final String notes;

  const ProgramExerciseItem({
    required this.exerciseName,
    this.sets = 3,
    this.reps = 8,
    this.rest = '90"',
    this.notes = '',
  });

  String get label => '$sets x $reps · rec $rest';
}

class ProgramBlock {
  final String label;
  final List<ProgramExerciseItem> items;

  const ProgramBlock({required this.label, required this.items});
}

class Program {
  final String id;
  final String name;
  final String description;
  final int durationWeeks;
  final int currentWeek;
  final int athleteCount;
  final bool isTemplate;
  final List<ProgramBlock> blocks;

  const Program({
    required this.id,
    required this.name,
    this.description = '',
    this.durationWeeks = 6,
    this.currentWeek = 1,
    this.athleteCount = 0,
    this.isTemplate = false,
    this.blocks = const [],
  });
}
