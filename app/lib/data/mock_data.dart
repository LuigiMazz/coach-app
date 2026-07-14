import '../models/athlete.dart';
import '../models/exercise.dart';
import '../models/program.dart';
import '../models/workout.dart';

/// Hardcoded sample data, mirroring the values used in the low-fi wireframe
/// (`project/Wireframes.dc.html`) so the high-fidelity build stays faithful.
class MockData {
  MockData._();

  static const proFirstName = 'Andrea';

  static const dashboardStats = [
    ('Esercizi in libreria', '86'),
    ('Programmi attivi', '12'),
    ('Atleti', '24'),
    ('Allenamenti completati', '341'),
  ];

  static final List<Exercise> exercises = [
    Exercise(
      id: 'ex1',
      name: 'Nordic Hamstring',
      category: 'Forza',
      description:
          'Controllare la fase eccentrica, ginocchia bloccate a terra da un partner o da un supporto.',
      personalNotes: 'Utile in fase preventiva per infortuni al bicipite femorale.',
      sets: 3,
      reps: 8,
      rest: '90"',
      load: 'Corpo libero',
      tags: ['Hamstring', 'LCA'],
    ),
    Exercise(
      id: 'ex2',
      name: 'Squat Bulgaro',
      category: 'Forza',
      description: 'Piede posteriore rialzato, busto leggermente inclinato in avanti.',
      sets: 4,
      reps: 10,
      rest: '75"',
      load: '2 x 16kg',
      tags: ['Quadricipite'],
    ),
    Exercise(
      id: 'ex3',
      name: 'Plank Anti-Rotazione',
      category: 'Core',
      description: 'Mantenere il bacino stabile contrastando la resistenza laterale.',
      sets: 3,
      reps: 0,
      duration: '45"',
      rest: '30"',
      tags: ['Core'],
    ),
    Exercise(
      id: 'ex4',
      name: 'Mobilità Anca 90/90',
      category: 'Mobilità',
      description: 'Transizione controllata tra le due posizioni, schiena neutra.',
      sets: 2,
      reps: 10,
      rest: '30"',
      tags: ['Anca'],
    ),
    Exercise(
      id: 'ex5',
      name: 'Monopodalico Bosu',
      category: 'Prevenzione',
      description: 'Occhi aperti poi chiusi per progressione propriocettiva.',
      sets: 3,
      reps: 0,
      duration: '30"',
      rest: '30"',
      tags: ['Caviglia'],
    ),
    Exercise(
      id: 'ex6',
      name: 'Sprint Progressivi',
      category: 'Performance',
      description: 'Progressione di velocità dal 60% al 95% su 30 metri.',
      sets: 4,
      reps: 0,
      duration: '30m',
      rest: '120"',
      tags: ['Calcio'],
    ),
    Exercise(
      id: 'ex7',
      name: 'Rotazione Esterna Spalla',
      category: 'Prevenzione',
      description: 'Gomito a 90°, elastico leggero, movimento lento e controllato.',
      sets: 3,
      reps: 15,
      rest: '45"',
      tags: ['Spalla'],
    ),
    Exercise(
      id: 'ex8',
      name: 'Stabilizzazione Scapolare',
      category: 'Recupero',
      description: 'Attivazione del trapezio inferiore in scarico.',
      sets: 3,
      reps: 12,
      rest: '45"',
      tags: ['Spalla'],
    ),
  ];

  static final List<Athlete> athletes = [
    Athlete(
      id: 'a1',
      name: 'Marco',
      surname: 'Rossi',
      email: 'marco.rossi@email.it',
      sport: 'Calcio',
      activeProgram: 'Pre-season Calcio',
      lastWorkout: 'Ieri',
      completionPct: 82,
      assignedPrograms: ['Pre-season Calcio'],
      history: [
        WorkoutHistoryEntry(date: '11 Lug', feedback: 'Facile'),
        WorkoutHistoryEntry(date: '9 Lug', feedback: 'Corretto'),
        WorkoutHistoryEntry(date: '7 Lug', feedback: 'Difficile · dolore 4/10'),
        WorkoutHistoryEntry(date: '4 Lug', feedback: 'Corretto'),
      ],
    ),
    Athlete(
      id: 'a2',
      name: 'Giulia',
      surname: 'Bianchi',
      email: 'giulia.bianchi@email.it',
      sport: 'Basket',
      activeProgram: 'Recupero LCA',
      lastWorkout: '3 giorni fa',
      completionPct: 45,
      assignedPrograms: ['Recupero LCA'],
      history: [
        WorkoutHistoryEntry(date: '10 Lug', feedback: 'Difficile · dolore 3/10'),
        WorkoutHistoryEntry(date: '6 Lug', feedback: 'Corretto'),
      ],
    ),
    Athlete(
      id: 'a3',
      name: 'Luca',
      surname: 'Ferrari',
      email: 'luca.ferrari@email.it',
      sport: 'Tennis',
      activeProgram: 'Forza Base',
      lastWorkout: 'Oggi',
      completionPct: 96,
      assignedPrograms: ['Forza Base'],
      history: [
        WorkoutHistoryEntry(date: '14 Lug', feedback: 'Facile'),
        WorkoutHistoryEntry(date: '12 Lug', feedback: 'Corretto'),
      ],
    ),
    Athlete(
      id: 'a4',
      name: 'Elena',
      surname: 'Conti',
      email: 'elena.conti@email.it',
      sport: 'Corsa',
      activeProgram: 'Mobilità Generale',
      lastWorkout: '5 giorni fa',
      completionPct: 20,
      assignedPrograms: ['Mobilità Generale'],
      history: [
        WorkoutHistoryEntry(date: '9 Lug', feedback: 'Corretto'),
      ],
    ),
  ];

  static final List<Program> programs = [
    Program(
      id: 'p1',
      name: 'Pre-season Calcio',
      description: 'Programma forza e prevenzione, 6 settimane',
      durationWeeks: 6,
      currentWeek: 1,
      athleteCount: 6,
      blocks: [
        ProgramBlock(label: 'Warm-up', items: [
          ProgramExerciseItem(exerciseName: 'Mobilità Anca 90/90', sets: 2, reps: 10, rest: '30"'),
          ProgramExerciseItem(exerciseName: 'Attivazione Glutei', sets: 2, reps: 12, rest: '30"'),
        ]),
        ProgramBlock(label: 'Forza', items: [
          ProgramExerciseItem(exerciseName: 'Nordic Hamstring', sets: 3, reps: 8, rest: '90"'),
          ProgramExerciseItem(exerciseName: 'Squat Bulgaro', sets: 4, reps: 10, rest: '75"'),
        ]),
        ProgramBlock(label: 'Core', items: [
          ProgramExerciseItem(exerciseName: 'Plank Anti-Rotazione', sets: 3, reps: 0, rest: '30"'),
        ]),
      ],
    ),
    Program(
      id: 'p2',
      name: 'Recupero LCA',
      description: 'Programma di recupero post-infortunio, 8 settimane',
      durationWeeks: 8,
      currentWeek: 3,
      athleteCount: 2,
      blocks: [
        ProgramBlock(label: 'Mobilità', items: [
          ProgramExerciseItem(exerciseName: 'Mobilità Anca 90/90', sets: 2, reps: 10, rest: '30"'),
        ]),
        ProgramBlock(label: 'Prevenzione', items: [
          ProgramExerciseItem(exerciseName: 'Monopodalico Bosu', sets: 3, reps: 0, rest: '30"'),
        ]),
      ],
    ),
    Program(
      id: 'p3',
      name: 'Forza Base',
      description: 'Programma di forza generale, 4 settimane',
      durationWeeks: 4,
      currentWeek: 2,
      athleteCount: 9,
      blocks: [
        ProgramBlock(label: 'Forza', items: [
          ProgramExerciseItem(exerciseName: 'Squat Bulgaro', sets: 4, reps: 10, rest: '75"'),
          ProgramExerciseItem(exerciseName: 'Nordic Hamstring', sets: 3, reps: 8, rest: '90"'),
        ]),
      ],
    ),
  ];

  static final todayWorkout = TodayWorkout(
    programName: 'Pre-season Calcio — Sett. 1',
    week: 1,
    dayLabel: 'Oggi, Giovedì',
    exercises: [
      const WorkoutExercise(
        exerciseId: 'ex4',
        name: 'Mobilità Anca 90/90',
        category: 'Mobilità',
        setsLabel: '2 x 10',
        done: true,
      ),
      const WorkoutExercise(
        exerciseId: 'ex1',
        name: 'Nordic Hamstring',
        category: 'Forza',
        setsLabel: '3 x 8',
        rest: '90"',
        instructions:
            'Controlla la fase eccentrica, blocca le caviglie e scendi lentamente in avanti.',
      ),
      const WorkoutExercise(
        exerciseId: 'ex3',
        name: 'Plank Anti-Rotazione',
        category: 'Core',
        setsLabel: '3 x 45"',
        rest: '30"',
      ),
      const WorkoutExercise(
        exerciseId: 'ex6',
        name: 'Sprint Progressivi',
        category: 'Performance',
        setsLabel: '4 x 30m',
        rest: '120"',
      ),
    ],
  );

  static void markWorkoutExerciseDone(String exerciseId) {
    final i = todayWorkout.exercises.indexWhere((e) => e.exerciseId == exerciseId);
    if (i != -1) {
      todayWorkout.exercises[i] = todayWorkout.exercises[i].copyWith(done: true);
    }
  }

  static const List<String> sports = [
    'Calcio',
    'Basket',
    'Tennis',
    'Corsa',
    'Nuoto',
    'Altro',
  ];

  static const List<String> professionalRoles = [
    'Personal Trainer',
    'Preparatore atletico',
    'Fisioterapista',
    'Chinesiologo',
    'Altro',
  ];
}
