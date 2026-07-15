import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../data/mock_data.dart';
import '../../models/program.dart';
import '../../theme/app_colors.dart';
import '../../widgets/wizard_scaffold.dart';

class NewProgramScreen extends StatefulWidget {
  const NewProgramScreen({super.key});

  @override
  State<NewProgramScreen> createState() => _NewProgramScreenState();
}

class _NewProgramScreenState extends State<NewProgramScreen> {
  final _nameCtrl = TextEditingController();
  final _descriptionCtrl = TextEditingController();
  int _weeks = 6;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _descriptionCtrl.dispose();
    super.dispose();
  }

  void _createAndOpenBuilder(BuildContext context) {
    final program = Program(
      id: 'p${DateTime.now().microsecondsSinceEpoch}',
      name: _nameCtrl.text.trim().isEmpty
          ? 'Nuovo programma'
          : _nameCtrl.text.trim(),
      description: _descriptionCtrl.text.trim(),
      durationWeeks: _weeks,
      currentWeek: 1,
      athleteCount: 0,
      blocks: const [
        ProgramBlock(label: 'Warm-up', items: []),
        ProgramBlock(label: 'Forza', items: []),
        ProgramBlock(label: 'Core', items: []),
      ],
    );
    MockData.addProgram(program);
    context.pushReplacement('/programs/${program.id}');
  }

  @override
  Widget build(BuildContext context) {
    return WizardScaffold(
      title: 'Nuovo programma',
      showClose: true,
      onBack: () => context.pop(),
      ctaLabel: 'Crea e apri builder',
      ctaEnabled: _nameCtrl.text.trim().isNotEmpty,
      onCta: () => _createAndOpenBuilder(context),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          WizardField(
            label: 'Nome programma',
            child: TextField(
              controller: _nameCtrl,
              decoration: const InputDecoration(
                hintText: 'Es. Pre-season Calcio',
              ),
              onChanged: (_) => setState(() {}),
            ),
          ),
          WizardField(
            label: 'Descrizione',
            child: TextField(
              controller: _descriptionCtrl,
              maxLines: 3,
              decoration: const InputDecoration(
                hintText: 'Es. Programma forza 6 settimane',
              ),
            ),
          ),
          WizardField(
            label: 'Durata',
            child: Row(
              children: [
                _StepperButton(
                  icon: Icons.remove,
                  onTap: () =>
                      setState(() => _weeks = (_weeks - 1).clamp(1, 52)),
                ),
                Expanded(
                  child: Text(
                    '$_weeks settimane',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                _StepperButton(
                  icon: Icons.add,
                  onTap: () =>
                      setState(() => _weeks = (_weeks + 1).clamp(1, 52)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StepperButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _StepperButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        width: 40,
        height: 40,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.borderStrong),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, size: 18),
      ),
    );
  }
}
