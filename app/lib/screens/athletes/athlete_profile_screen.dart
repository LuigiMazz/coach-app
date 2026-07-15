import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../data/mock_data.dart';
import '../../models/athlete.dart';
import '../../theme/app_colors.dart';
import '../../theme/breakpoints.dart';
import '../../widgets/app_avatar.dart';
import '../../widgets/section_card.dart';
import '../../widgets/status_badge.dart';

class AthleteProfileScreen extends StatelessWidget {
  final String athleteId;

  const AthleteProfileScreen({super.key, required this.athleteId});

  @override
  Widget build(BuildContext context) {
    final Athlete athlete = MockData.athletes.firstWhere(
      (a) => a.id == athleteId,
      orElse: () => MockData.athletes.first,
    );

    return LayoutBuilder(
      builder: (context, constraints) {
        final isDesktop = constraints.maxWidth >= AppBreakpoints.desktop;
        return Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => context.pop(),
            ),
            title: Text(athlete.fullName),
          ),
          body: SafeArea(
            top: false,
            child: SingleChildScrollView(
              padding: EdgeInsets.all(isDesktop ? 32 : 18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      AppAvatar(initials: athlete.initials, size: 64),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  athlete.fullName,
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                AthleteStatusBadge(status: athlete.status),
                              ],
                            ),
                            Text(
                              '${athlete.sport} · Preparazione atletica',
                              style: const TextStyle(
                                fontSize: 13,
                                color: AppColors.textSecondary,
                              ),
                            ),
                            if (athlete.status == AthleteStatus.invited)
                              Padding(
                                padding: const EdgeInsets.only(top: 4),
                                child: TextButton(
                                  style: TextButton.styleFrom(
                                    padding: EdgeInsets.zero,
                                    minimumSize: Size.zero,
                                  ),
                                  onPressed: () {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          'Invito reinviato a ${athlete.email}',
                                        ),
                                      ),
                                    );
                                  },
                                  child: const Text(
                                    'Reinvia invito',
                                    style: TextStyle(fontSize: 12),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                      if (isDesktop)
                        ElevatedButton(
                          onPressed: () => context.push(
                            '/programs/assign?athleteId=${athlete.id}',
                          ),
                          child: const Text('Assegna programma'),
                        ),
                    ],
                  ),
                  if (!isDesktop) ...[
                    const SizedBox(height: 14),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () => context.push(
                          '/programs/assign?athleteId=${athlete.id}',
                        ),
                        child: const Text('Assegna programma'),
                      ),
                    ),
                  ],
                  const SizedBox(height: 24),
                  isDesktop
                      ? IntrinsicHeight(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Expanded(child: _ProgramsCard(athlete: athlete)),
                              const SizedBox(width: 20),
                              Expanded(child: _HistoryCard(athlete: athlete)),
                            ],
                          ),
                        )
                      : Column(
                          children: [
                            _ProgramsCard(athlete: athlete),
                            const SizedBox(height: 16),
                            _HistoryCard(athlete: athlete),
                          ],
                        ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _ProgramsCard extends StatelessWidget {
  final Athlete athlete;

  const _ProgramsCard({required this.athlete});

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      title: 'Programmi assegnati',
      child: Column(
        children: [
          for (final p in athlete.assignedPrograms)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 10),
              decoration: const BoxDecoration(
                border: Border(bottom: BorderSide(color: AppColors.border)),
              ),
              child: Text(p, style: const TextStyle(fontSize: 13)),
            ),
          if (athlete.assignedPrograms.isEmpty)
            const Text(
              'Nessun programma assegnato',
              style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
            ),
        ],
      ),
    );
  }
}

class _HistoryCard extends StatelessWidget {
  final Athlete athlete;

  const _HistoryCard({required this.athlete});

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      title: 'Storico allenamenti',
      child: Column(
        children: [
          for (final h in athlete.history)
            Container(
              padding: const EdgeInsets.symmetric(vertical: 10),
              decoration: const BoxDecoration(
                border: Border(bottom: BorderSide(color: AppColors.border)),
              ),
              child: Row(
                children: [
                  Text(h.date, style: const TextStyle(fontSize: 13)),
                  const Spacer(),
                  Text(
                    h.feedback,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
