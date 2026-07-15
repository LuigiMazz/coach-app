import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../data/mock_data.dart';
import '../../theme/app_colors.dart';
import '../../widgets/wizard_scaffold.dart';

/// First-touch screen for an athlete invited by their professional
/// (see docs/proposal-athlete-activation.md). Name and email come from the
/// `Athlete` record the coach already created and are read-only here — the
/// athlete only sets a password, then the record flips to `active` and logs
/// straight into "Allenamento di oggi".
class ActivateAccountScreen extends StatefulWidget {
  final String athleteId;

  const ActivateAccountScreen({super.key, required this.athleteId});

  @override
  State<ActivateAccountScreen> createState() => _ActivateAccountScreenState();
}

class _ActivateAccountScreenState extends State<ActivateAccountScreen> {
  final _passwordCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();

  @override
  void dispose() {
    _passwordCtrl.dispose();
    _confirmCtrl.dispose();
    super.dispose();
  }

  bool get _canSubmit =>
      _passwordCtrl.text.trim().length >= 6 &&
      _passwordCtrl.text == _confirmCtrl.text;

  @override
  Widget build(BuildContext context) {
    final athlete = MockData.findAthleteById(widget.athleteId);
    if (athlete == null) {
      return WizardScaffold(
        title: 'Attiva account',
        ctaLabel: 'Torna al login',
        onCta: () => context.go('/login'),
        onBack: () => context.go('/login'),
        body: const Text(
          'Invito non valido o scaduto. Chiedi al tuo coach di reinviarlo.',
          style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
        ),
      );
    }

    return WizardScaffold(
      title: 'Attiva il tuo account',
      onBack: () => context.go('/login'),
      ctaLabel: 'Attiva e accedi',
      ctaEnabled: _canSubmit,
      onCta: () {
        MockData.activateAthlete(athlete.id);
        context.go('/workout');
      },
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.surfaceMuted,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              'Il tuo coach ti ha invitato su Coach Exercise Manager. '
              'Imposta una password per accedere al tuo programma.',
              style: const TextStyle(
                fontSize: 11,
                color: AppColors.textSecondary,
                height: 1.4,
              ),
            ),
          ),
          const SizedBox(height: 16),
          WizardField(
            label: 'Nome',
            child: _ReadOnlyField(value: athlete.fullName),
          ),
          WizardField(
            label: 'Email',
            child: _ReadOnlyField(value: athlete.email),
          ),
          WizardField(
            label: 'Crea una password',
            child: TextField(
              controller: _passwordCtrl,
              obscureText: true,
              decoration: const InputDecoration(hintText: 'Almeno 6 caratteri'),
              onChanged: (_) => setState(() {}),
            ),
          ),
          WizardField(
            label: 'Conferma password',
            child: TextField(
              controller: _confirmCtrl,
              obscureText: true,
              decoration: const InputDecoration(hintText: '••••••••'),
              onChanged: (_) => setState(() {}),
            ),
          ),
        ],
      ),
    );
  }
}

class _ReadOnlyField extends StatelessWidget {
  final String value;

  const _ReadOnlyField({required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
      decoration: BoxDecoration(
        color: AppColors.surfaceMuted,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        value,
        style: const TextStyle(fontSize: 13, color: AppColors.textSecondary),
      ),
    );
  }
}
