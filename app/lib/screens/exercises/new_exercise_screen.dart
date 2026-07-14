import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../data/mock_data.dart';
import '../../models/exercise.dart';
import '../../theme/app_colors.dart';
import '../../widgets/category_chip.dart';
import '../../widgets/wizard_scaffold.dart';

class NewExerciseScreen extends StatefulWidget {
  const NewExerciseScreen({super.key});

  @override
  State<NewExerciseScreen> createState() => _NewExerciseScreenState();
}

class _NewExerciseScreenState extends State<NewExerciseScreen> {
  int _step = 0;

  final _nameCtrl = TextEditingController();
  String? _category;

  VideoSource _videoSource = VideoSource.upload;

  final _descriptionCtrl = TextEditingController();
  final _notesCtrl = TextEditingController();
  final _setsCtrl = TextEditingController();
  final _repsCtrl = TextEditingController();
  final _restCtrl = TextEditingController();
  final _loadCtrl = TextEditingController();
  final _tagCtrl = TextEditingController();
  final List<String> _tags = [];

  @override
  void dispose() {
    _nameCtrl.dispose();
    _descriptionCtrl.dispose();
    _notesCtrl.dispose();
    _setsCtrl.dispose();
    _repsCtrl.dispose();
    _restCtrl.dispose();
    _loadCtrl.dispose();
    _tagCtrl.dispose();
    super.dispose();
  }

  void _save() {
    final exercise = Exercise(
      id: 'ex${DateTime.now().microsecondsSinceEpoch}',
      name: _nameCtrl.text.trim().isEmpty ? 'Nuovo esercizio' : _nameCtrl.text.trim(),
      category: _category ?? exerciseCategories.first,
      description: _descriptionCtrl.text.trim(),
      personalNotes: _notesCtrl.text.trim(),
      videoSource: _videoSource,
      sets: int.tryParse(_setsCtrl.text) ?? 0,
      reps: int.tryParse(_repsCtrl.text) ?? 0,
      rest: _restCtrl.text.trim(),
      load: _loadCtrl.text.trim(),
      tags: _tags,
    );
    MockData.exercises.insert(0, exercise);
    setState(() => _step = 3);
  }

  @override
  Widget build(BuildContext context) {
    switch (_step) {
      case 0:
        return _buildStep1();
      case 1:
        return _buildStep2();
      case 2:
        return _buildStep3();
      default:
        return _buildStep4();
    }
  }

  Widget _buildStep1() {
    return WizardScaffold(
      title: 'Nome esercizio',
      stepLabel: '1/4',
      showClose: true,
      onBack: () => context.pop(),
      ctaLabel: 'Continua',
      ctaEnabled: _nameCtrl.text.trim().isNotEmpty && _category != null,
      onCta: () => setState(() => _step = 1),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          WizardField(
            label: 'Nome esercizio',
            child: TextField(
              controller: _nameCtrl,
              decoration: const InputDecoration(hintText: 'Nordic Hamstring'),
              onChanged: (_) => setState(() {}),
            ),
          ),
          WizardField(
            label: 'Categoria',
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final c in exerciseCategories)
                  CategoryChip(
                    label: c,
                    selected: _category == c,
                    onTap: () => setState(() => _category = c),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStep2() {
    return WizardScaffold(
      title: 'Aggiungi video',
      stepLabel: '2/4',
      onBack: () => setState(() => _step = 0),
      ctaLabel: 'Continua',
      onCta: () => setState(() => _step = 2),
      body: Column(
        children: [
          _VideoSourceOption(
            icon: Icons.upload_rounded,
            label: 'Upload video personale',
            selected: _videoSource == VideoSource.upload,
            onTap: () => setState(() => _videoSource = VideoSource.upload),
          ),
          const SizedBox(height: 10),
          _VideoSourceOption(
            icon: Icons.smart_display_outlined,
            label: 'Link YouTube',
            selected: _videoSource == VideoSource.youtube,
            onTap: () => setState(() => _videoSource = VideoSource.youtube),
          ),
          const SizedBox(height: 10),
          _VideoSourceOption(
            icon: Icons.video_library_outlined,
            label: 'Libreria interna',
            selected: _videoSource == VideoSource.internalLibrary,
            onTap: () => setState(() => _videoSource = VideoSource.internalLibrary),
          ),
        ],
      ),
    );
  }

  Widget _buildStep3() {
    return WizardScaffold(
      title: 'Dettagli e parametri',
      stepLabel: '3/4',
      onBack: () => setState(() => _step = 1),
      ctaLabel: 'Continua',
      onCta: _save,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          WizardField(
            label: 'Descrizione tecnica',
            child: TextField(
              controller: _descriptionCtrl,
              maxLines: 3,
              decoration: const InputDecoration(hintText: 'Esecuzione, errori comuni, indicazioni…'),
            ),
          ),
          WizardField(
            label: 'Note personali',
            child: TextField(
              controller: _notesCtrl,
              maxLines: 2,
              decoration: const InputDecoration(hintText: 'Note private, non visibili all\'atleta'),
            ),
          ),
          Row(
            children: [
              Expanded(
                child: WizardField(
                  label: 'Serie',
                  child: TextField(
                    controller: _setsCtrl,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(hintText: '3'),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: WizardField(
                  label: 'Ripetizioni',
                  child: TextField(
                    controller: _repsCtrl,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(hintText: '8'),
                  ),
                ),
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: WizardField(
                  label: 'Recupero',
                  child: TextField(
                    controller: _restCtrl,
                    decoration: const InputDecoration(hintText: '90"'),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: WizardField(
                  label: 'Carico',
                  child: TextField(
                    controller: _loadCtrl,
                    decoration: const InputDecoration(hintText: 'Corpo libero'),
                  ),
                ),
              ),
            ],
          ),
          WizardField(
            label: 'Tag',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (_tags.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children: [
                        for (final t in _tags)
                          Chip(
                            label: Text(t, style: const TextStyle(fontSize: 11)),
                            onDeleted: () => setState(() => _tags.remove(t)),
                          ),
                      ],
                    ),
                  ),
                TextField(
                  controller: _tagCtrl,
                  decoration: const InputDecoration(hintText: '+ aggiungi tag (invio per confermare)'),
                  onSubmitted: (value) {
                    final v = value.trim();
                    if (v.isEmpty) return;
                    setState(() {
                      _tags.add(v);
                      _tagCtrl.clear();
                    });
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStep4() {
    return WizardScaffold(
      title: 'Salva',
      stepLabel: '4/4',
      showClose: true,
      onBack: () => context.go('/library'),
      ctaLabel: 'Vai alla libreria',
      onCta: () => context.go('/library'),
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 12),
          Container(
            width: 56,
            height: 56,
            decoration: const BoxDecoration(color: AppColors.accentSoft, shape: BoxShape.circle),
            child: const Icon(Icons.check_rounded, color: AppColors.accent, size: 28),
          ),
          const SizedBox(height: 14),
          const Text('Esercizio salvato',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
          const SizedBox(height: 6),
          const Text('Aggiunto alla tua libreria privata',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
          const SizedBox(height: 12),
        ],
      ),
    );
  }
}

class _VideoSourceOption extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _VideoSourceOption({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(color: selected ? AppColors.accent : AppColors.borderStrong, width: selected ? 1.5 : 1),
          borderRadius: BorderRadius.circular(8),
          color: selected ? AppColors.accentSoft : Colors.transparent,
        ),
        child: Row(
          children: [
            Icon(icon, size: 20, color: selected ? AppColors.accent : AppColors.textSecondary),
            const SizedBox(width: 12),
            Text(label, style: const TextStyle(fontSize: 13)),
          ],
        ),
      ),
    );
  }
}
