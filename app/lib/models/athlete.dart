class WorkoutHistoryEntry {
  final String date;
  final String feedback;

  const WorkoutHistoryEntry({required this.date, required this.feedback});
}

class Athlete {
  final String id;
  final String name;
  final String surname;
  final String email;
  final String sport;
  final String notes;
  final String activeProgram;
  final String lastWorkout;
  final int completionPct;
  final List<String> assignedPrograms;
  final List<WorkoutHistoryEntry> history;

  const Athlete({
    required this.id,
    required this.name,
    required this.surname,
    this.email = '',
    this.sport = '',
    this.notes = '',
    this.activeProgram = '',
    this.lastWorkout = '',
    this.completionPct = 0,
    this.assignedPrograms = const [],
    this.history = const [],
  });

  String get fullName => '$name $surname'.trim();

  String get initials {
    final n = name.isNotEmpty ? name[0] : '';
    final s = surname.isNotEmpty ? surname[0] : '';
    return (n + s).toUpperCase();
  }
}
