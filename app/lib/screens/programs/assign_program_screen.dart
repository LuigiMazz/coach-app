import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../data/mock_data.dart';
import '../../models/athlete.dart';
import '../../models/program.dart';
import '../../theme/app_colors.dart';
import '../../widgets/app_avatar.dart';
import '../../widgets/search_field.dart';
import '../../widgets/wizard_scaffold.dart';

class AssignProgramScreen extends StatefulWidget {
  final String? initialAthleteId;
  final String? initialProgramId;

  const AssignProgramScreen({super.key, this.initialAthleteId, this.initialProgramId});

  @override
  State<AssignProgramScreen> createState() => _AssignProgramScreenState();
}

class _AssignProgramScreenState extends State<AssignProgramScreen> {
  late int _step;
  Program? _selectedProgram;
  final Set<String> _selectedAthleteIds = {};
  String _query = '';

  @override
  void initState() {
    super.initState();
    if (widget.initialProgramId != null) {
      _selectedProgram = MockData.programs
          .where((p) => p.id == widget.initialProgramId)
          .cast<Program?>()
          .firstWhere((_) => true, orElse: () => null);
    }
    if (widget.initialAthleteId != null) {
      _selectedAthleteIds.add(widget.initialAthleteId!);
    }
    _step = _selectedProgram != null ? 1 : 0;
  }

  @override
  Widget build(BuildContext context) {
    return _step == 0 ? _buildStep1() : _buildStep2();
  }

  Widget _buildStep1() {
    return WizardScaffold(
      title: 'Assegna programma',
      showClose: true,
      onBack: () => context.pop(),
      ctaLabel: 'Continua',
      ctaEnabled: _selectedProgram != null,
      onCta: () => setState(() => _step = 1),
      body: Column(
        children: [
          for (final p in MockData.programs)
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: InkWell(
                onTap: () => setState(() => _selectedProgram = p),
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: _selectedProgram?.id == p.id ? AppColors.accent : AppColors.borderStrong,
                      width: _selectedProgram?.id == p.id ? 1.5 : 1,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        _selectedProgram?.id == p.id
                            ? Icons.radio_button_checked
                            : Icons.radio_button_off,
                        size: 20,
                        color: _selectedProgram?.id == p.id ? AppColors.accent : AppColors.textTertiary,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(p.name, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                            Text('${p.athleteCount} atleti assegnati',
                                style: const TextStyle(fontSize: 11, color: AppColors.textSecondary)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildStep2() {
    final results = MockData.athletes
        .where((a) => a.fullName.toLowerCase().contains(_query.toLowerCase()))
        .toList();

    return WizardScaffold(
      title: _selectedProgram?.name ?? '',
      onBack: () => setState(() => _step = 0),
      ctaLabel: 'Assegna a ${_selectedAthleteIds.length} atlet${_selectedAthleteIds.length == 1 ? 'a' : 'i'}',
      ctaEnabled: _selectedAthleteIds.isNotEmpty,
      onCta: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${_selectedProgram!.name} assegnato a ${_selectedAthleteIds.length} atleti')),
        );
        context.go('/dashboard');
      },
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppSearchField(
            hint: 'Cerca atleta…',
            onChanged: (v) => setState(() => _query = v),
          ),
          const SizedBox(height: 12),
          for (final Athlete a in results)
            InkWell(
              onTap: () => setState(() {
                if (_selectedAthleteIds.contains(a.id)) {
                  _selectedAthleteIds.remove(a.id);
                } else {
                  _selectedAthleteIds.add(a.id);
                }
              }),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: const BoxDecoration(
                  border: Border(bottom: BorderSide(color: AppColors.border)),
                ),
                child: Row(
                  children: [
                    AppAvatar(initials: a.initials, size: 30),
                    const SizedBox(width: 10),
                    Expanded(child: Text(a.fullName, style: const TextStyle(fontSize: 13))),
                    Icon(
                      _selectedAthleteIds.contains(a.id)
                          ? Icons.check_circle
                          : Icons.radio_button_off,
                      size: 20,
                      color: _selectedAthleteIds.contains(a.id)
                          ? AppColors.accent
                          : AppColors.textTertiary,
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
