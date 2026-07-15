class WorkoutHistoryEntry {
  final String date;
  final String feedback;

  const WorkoutHistoryEntry({required this.date, required this.feedback});
}

/// Whether the athlete has activated their own login yet. There is no
/// self-registration for athletes (see docs/proposal-athlete-activation.md):
/// the professional creates the `Athlete` record, which starts `invited`;
/// the athlete sets a password via "Attiva account" on first login, which
/// flips this to `active`.
enum AthleteStatus { invited, active }

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
  final AthleteStatus status;

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
    this.status = AthleteStatus.active,
  });

  String get fullName => '$name $surname'.trim();

  String get initials {
    final n = name.isNotEmpty ? name[0] : '';
    final s = surname.isNotEmpty ? surname[0] : '';
    return (n + s).toUpperCase();
  }

  Athlete copyWith({AthleteStatus? status}) {
    return Athlete(
      id: id,
      name: name,
      surname: surname,
      email: email,
      sport: sport,
      notes: notes,
      activeProgram: activeProgram,
      lastWorkout: lastWorkout,
      completionPct: completionPct,
      assignedPrograms: assignedPrograms,
      history: history,
      status: status ?? this.status,
    );
  }
}
