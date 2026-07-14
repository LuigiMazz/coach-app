enum VideoSource { upload, youtube, internalLibrary }

class Exercise {
  final String id;
  final String name;
  final String category;
  final String description;
  final String personalNotes;
  final VideoSource videoSource;
  final int sets;
  final int reps;
  final String duration;
  final String rest;
  final String load;
  final List<String> tags;
  final bool isFavorite;

  const Exercise({
    required this.id,
    required this.name,
    required this.category,
    this.description = '',
    this.personalNotes = '',
    this.videoSource = VideoSource.upload,
    this.sets = 0,
    this.reps = 0,
    this.duration = '',
    this.rest = '',
    this.load = '',
    this.tags = const [],
    this.isFavorite = false,
  });

  String get setsRepsLabel {
    if (sets > 0 && reps > 0) return '$sets x $reps';
    if (duration.isNotEmpty) return duration;
    return '—';
  }
}

const List<String> exerciseCategories = [
  'Forza',
  'Mobilità',
  'Prevenzione',
  'Recupero',
  'Core',
  'Performance',
];
