import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../data/mock_data.dart';
import '../../theme/app_colors.dart';
import '../../theme/breakpoints.dart';
import '../../widgets/app_avatar.dart';
import '../../widgets/progress_bar.dart';

class AthletesScreen extends StatelessWidget {
  const AthletesScreen({super.key});

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
                      child: Text('Atleti',
                          style: TextStyle(
                              fontSize: isDesktop ? 20 : 18, fontWeight: FontWeight.w700)),
                    ),
                    ElevatedButton(
                      onPressed: () => context.push('/athletes/new'),
                      child: Text(isDesktop ? '+ Nuovo atleta' : '+ Nuovo',
                          style: TextStyle(fontSize: isDesktop ? 13 : 12)),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Expanded(child: isDesktop ? _buildTable(context) : _buildList(context)),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildTable(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: const BoxDecoration(
              border: Border(bottom: BorderSide(color: AppColors.border)),
            ),
            child: const Row(
              children: [
                Expanded(flex: 2, child: Text('Nome', style: TextStyle(fontSize: 11, color: AppColors.textSecondary))),
                Expanded(flex: 2, child: Text('Programma attivo', style: TextStyle(fontSize: 11, color: AppColors.textSecondary))),
                Expanded(flex: 1, child: Text('Ultimo allenamento', style: TextStyle(fontSize: 11, color: AppColors.textSecondary))),
                Expanded(flex: 2, child: Text('Completamento', style: TextStyle(fontSize: 11, color: AppColors.textSecondary))),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: MockData.athletes.length,
              itemBuilder: (context, i) {
                final a = MockData.athletes[i];
                return InkWell(
                  onTap: () => context.push('/athletes/${a.id}'),
                  child: Container(
                    padding: const EdgeInsets.all(14),
                    decoration: const BoxDecoration(
                      border: Border(bottom: BorderSide(color: AppColors.border)),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: Row(
                            children: [
                              AppAvatar(initials: a.initials, size: 28),
                              const SizedBox(width: 10),
                              Text(a.fullName, style: const TextStyle(fontSize: 13)),
                            ],
                          ),
                        ),
                        Expanded(flex: 2, child: Text(a.activeProgram, style: const TextStyle(fontSize: 13))),
                        Expanded(
                            flex: 1,
                            child: Text(a.lastWorkout,
                                style: const TextStyle(fontSize: 13, color: AppColors.textSecondary))),
                        Expanded(
                          flex: 2,
                          child: Row(
                            children: [
                              Expanded(child: AppProgressBar(percent: a.completionPct)),
                              const SizedBox(width: 8),
                              Text('${a.completionPct}%',
                                  style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                            ],
                          ),
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
    );
  }

  Widget _buildList(BuildContext context) {
    return ListView.separated(
      itemCount: MockData.athletes.length,
      separatorBuilder: (_, __) => const SizedBox(height: 10),
      itemBuilder: (context, i) {
        final a = MockData.athletes[i];
        return InkWell(
          onTap: () => context.push('/athletes/${a.id}'),
          borderRadius: BorderRadius.circular(10),
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.border),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                AppAvatar(initials: a.initials, size: 36),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(a.fullName, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                      Text(a.activeProgram, style: const TextStyle(fontSize: 11, color: AppColors.textSecondary)),
                      const SizedBox(height: 6),
                      AppProgressBar(percent: a.completionPct, height: 5),
                    ],
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
