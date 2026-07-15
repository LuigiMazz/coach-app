import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../data/mock_data.dart';
import '../../models/athlete.dart';
import '../../theme/app_colors.dart';
import '../../widgets/wizard_scaffold.dart';

class NewAthleteScreen extends StatefulWidget {
  const NewAthleteScreen({super.key});

  @override
  State<NewAthleteScreen> createState() => _NewAthleteScreenState();
}

class _NewAthleteScreenState extends State<NewAthleteScreen> {
  final _nameCtrl = TextEditingController();
  final _surnameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _notesCtrl = TextEditingController();
  String? _sport;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _surnameCtrl.dispose();
    _emailCtrl.dispose();
    _notesCtrl.dispose();
    super.dispose();
  }

  void _save(BuildContext context) {
    final athlete = Athlete(
      id: 'a${DateTime.now().microsecondsSinceEpoch}',
      name: _nameCtrl.text.trim().isEmpty ? 'Nuovo' : _nameCtrl.text.trim(),
      surname: _surnameCtrl.text.trim(),
      email: _emailCtrl.text.trim(),
      sport: _sport ?? '',
      notes: _notesCtrl.text.trim(),
      lastWorkout: 'Mai',
      completionPct: 0,
      status: AthleteStatus.invited,
    );
    MockData.addAthlete(athlete);
    context.go('/athletes');
  }

  @override
  Widget build(BuildContext context) {
    return WizardScaffold(
      title: 'Nuovo atleta',
      showClose: true,
      onBack: () => context.pop(),
      ctaLabel: 'Aggiungi atleta',
      onCta: () => _save(context),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: WizardField(
                  label: 'Nome',
                  child: TextField(
                    controller: _nameCtrl,
                    decoration: const InputDecoration(hintText: 'Marco'),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: WizardField(
                  label: 'Cognome',
                  child: TextField(
                    controller: _surnameCtrl,
                    decoration: const InputDecoration(hintText: 'Rossi'),
                  ),
                ),
              ),
            ],
          ),
          WizardField(
            label: 'Email',
            child: TextField(
              controller: _emailCtrl,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                hintText: 'marco.rossi@email.it',
              ),
            ),
          ),
          WizardField(
            label: 'Sport',
            child: DropdownButtonFormField<String>(
              initialValue: _sport,
              decoration: const InputDecoration(hintText: 'Seleziona sport'),
              items: [
                for (final s in MockData.sports)
                  DropdownMenuItem(value: s, child: Text(s)),
              ],
              onChanged: (v) => setState(() => _sport = v),
            ),
          ),
          WizardField(
            label: 'Note',
            child: TextField(
              controller: _notesCtrl,
              maxLines: 3,
              decoration: const InputDecoration(hintText: null),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.surfaceMuted,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Text(
              'Il tuo atleta non deve registrarsi: riceverà un invito a questa email '
              'e accederà direttamente dalla schermata di login.',
              style: TextStyle(
                fontSize: 11,
                color: AppColors.textSecondary,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
