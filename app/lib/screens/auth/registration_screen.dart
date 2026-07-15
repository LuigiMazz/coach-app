import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../data/mock_data.dart';
import '../../widgets/app_avatar.dart';
import '../../widgets/category_chip.dart';
import '../../widgets/wizard_scaffold.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  int _step = 0;
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  String? _role;

  final _specializationCtrl = TextEditingController();
  final _descriptionCtrl = TextEditingController();

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    _specializationCtrl.dispose();
    _descriptionCtrl.dispose();
    super.dispose();
  }

  bool get _step1Valid =>
      _nameCtrl.text.trim().isNotEmpty &&
      _emailCtrl.text.trim().isNotEmpty &&
      _passwordCtrl.text.trim().isNotEmpty &&
      _role != null;

  @override
  Widget build(BuildContext context) {
    if (_step == 0) return _buildStep1();
    return _buildStep2();
  }

  Widget _buildStep1() {
    return WizardScaffold(
      title: 'Crea il tuo account',
      stepLabel: '1/2',
      showClose: true,
      onBack: () => context.go('/login'),
      ctaLabel: 'Continua',
      ctaEnabled: _step1Valid,
      onCta: () => setState(() => _step = 1),
      footerExtra: TextButton(
        onPressed: () => context.go('/login'),
        child: const Text('Hai già un account? Accedi'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          WizardField(
            label: 'Nome',
            child: TextField(
              controller: _nameCtrl,
              decoration: const InputDecoration(hintText: 'Andrea Bianchi'),
              onChanged: (_) => setState(() {}),
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
          WizardField(
            label: 'Professione',
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final role in MockData.professionalRoles)
                  CategoryChip(
                    label: role,
                    selected: _role == role,
                    onTap: () => setState(() => _role = role),
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
      title: 'Crea il tuo profilo',
      stepLabel: '2/2',
      onBack: () => setState(() => _step = 0),
      ctaLabel: 'Vai alla dashboard',
      onCta: () => context.go('/dashboard'),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const AppAvatar(initials: '+', size: 88),
          const SizedBox(height: 8),
          TextButton(
            onPressed: () {},
            child: const Text('+ Carica foto profilo'),
          ),
          const SizedBox(height: 8),
          Align(
            alignment: Alignment.centerLeft,
            child: WizardField(
              label: 'Specializzazione',
              child: TextField(
                controller: _specializationCtrl,
                decoration: const InputDecoration(
                  hintText: 'Es. Riabilitazione ginocchio, calcio giovanile…',
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: WizardField(
              label: 'Descrizione',
              child: TextField(
                controller: _descriptionCtrl,
                maxLines: 4,
                decoration: const InputDecoration(hintText: null),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
