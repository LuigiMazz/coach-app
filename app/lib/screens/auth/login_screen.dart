import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../data/mock_data.dart';
import '../../models/athlete.dart';
import '../../theme/app_colors.dart';
import '../../widgets/wizard_scaffold.dart';

/// Single login entry point for both personas. There is no athlete
/// self-registration in this MVP (per docs/PRD.md Flow E): the professional
/// creates the athlete record (name + email) from "Nuovo atleta", and the
/// athlete logs in here with that same email. Matching it against
/// MockData.athletes is what decides which app (professional vs athlete)
/// they land on, standing in for real role-based auth.
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  bool get _canSubmit =>
      _emailCtrl.text.trim().isNotEmpty && _passwordCtrl.text.trim().isNotEmpty;

  void _login(BuildContext context) {
    final athlete = MockData.findAthleteByEmail(_emailCtrl.text);
    if (athlete == null) {
      context.go('/dashboard');
    } else if (athlete.status == AthleteStatus.invited) {
      context.go('/activate?athleteId=${athlete.id}');
    } else {
      context.go('/workout');
    }
  }

  @override
  Widget build(BuildContext context) {
    return WizardScaffold(
      title: 'Accedi',
      ctaLabel: 'Accedi',
      ctaEnabled: _canSubmit,
      onCta: () => _login(context),
      onBack: () => context.go('/register'),
      footerExtra: TextButton(
        onPressed: () => context.go('/register'),
        child: const Text('Non hai un account? Registrati'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 56,
            height: 56,
            margin: const EdgeInsets.only(bottom: 20),
            decoration: BoxDecoration(
              color: AppColors.accent,
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(
              Icons.bolt_rounded,
              color: Colors.white,
              size: 30,
            ),
          ),
          WizardField(
            label: 'Email',
            child: TextField(
              controller: _emailCtrl,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(hintText: 'andrea@studio.it'),
              onChanged: (_) => setState(() {}),
            ),
          ),
          WizardField(
            label: 'Password',
            child: TextField(
              controller: _passwordCtrl,
              obscureText: true,
              decoration: const InputDecoration(hintText: '••••••••'),
              onChanged: (_) => setState(() {}),
            ),
          ),
          const SizedBox(height: 4),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.surfaceMuted,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Text(
              'Sei un atleta? Accedi con l\'email che ti ha fornito il tuo coach — '
              'non serve registrarsi: è il tuo professionista ad aggiungerti come atleta.',
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
