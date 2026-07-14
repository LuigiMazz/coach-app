import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../data/mock_data.dart';
import '../../theme/app_colors.dart';
import '../../theme/breakpoints.dart';
import '../../widgets/progress_bar.dart';

class ProgramsScreen extends StatelessWidget {
  const ProgramsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isDesktop = constraints.maxWidth >= AppBreakpoints.desktop;
        return SafeArea(
          top: !isDesktop,
          child: Padding(
            padding: EdgeInsets.fromLTRB(
              isDesktop ? 32 : 18,
              isDesktop ? 28 : 14,
              isDesktop ? 32 : 18,
              isDesktop ? 32 : 12,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text('Programmi',
                          style: TextStyle(
                              fontSize: isDesktop ? 20 : 18, fontWeight: FontWeight.w700)),
                    ),
                    ElevatedButton(
                      onPressed: () => context.push('/programs/new'),
                      child: Text(isDesktop ? '+ Nuovo programma' : '+ Nuovo',
                          style: TextStyle(fontSize: isDesktop ? 13 : 12)),
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                Expanded(
                  child: ListView.separated(
                    itemCount: MockData.programs.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (context, i) {
                      final p = MockData.programs[i];
                      return InkWell(
                        onTap: () => context.push('/programs/${p.id}'),
                        borderRadius: BorderRadius.circular(10),
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            border: Border.all(color: AppColors.border),
                            borderRadius: BorderRadius.circular(10),
                            color: AppColors.surface,
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: AppColors.accentSoft,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Icon(Icons.assignment_rounded,
                                    color: AppColors.accent, size: 20),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(p.name,
                                        style: const TextStyle(
                                            fontSize: 14, fontWeight: FontWeight.w600)),
                                    const SizedBox(height: 3),
                                    Text(
                                      '${p.description} · Settimana ${p.currentWeek} di ${p.durationWeeks}',
                                      style: const TextStyle(
                                          fontSize: 12, color: AppColors.textSecondary),
                                    ),
                                  ],
                                ),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text('${p.athleteCount} atleti',
                                      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                                  const SizedBox(height: 6),
                                  SizedBox(
                                    width: 70,
                                    child: AppProgressBar(
                                        percent: (p.currentWeek / p.durationWeeks * 100).round()),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
