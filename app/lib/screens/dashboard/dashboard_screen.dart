import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../data/mock_data.dart';
import '../../theme/app_colors.dart';
import '../../theme/breakpoints.dart';
import '../../widgets/app_avatar.dart';
import '../../widgets/stat_card.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isDesktop = constraints.maxWidth >= AppBreakpoints.desktop;
        return isDesktop ? _DesktopDashboard() : const _MobileDashboard();
      },
    );
  }
}

class _DesktopDashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(32, 28, 32, 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Dashboard',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
                    SizedBox(height: 2),
                    Text('Bentornato, ${MockData.proFirstName}',
                        style: TextStyle(fontSize: 13, color: AppColors.textSecondary)),
                  ],
                ),
              ),
              ElevatedButton(
                onPressed: () => context.push('/exercises/new'),
                child: const Text('+ Nuovo esercizio'),
              ),
              const SizedBox(width: 10),
              OutlinedButton(
                onPressed: () => context.push('/programs/new'),
                child: const Text('+ Nuovo programma'),
              ),
              const SizedBox(width: 10),
              OutlinedButton(
                onPressed: () => context.push('/athletes/new'),
                child: const Text('+ Nuovo atleta'),
              ),
            ],
          ),
          const SizedBox(height: 24),
          GridView.count(
            crossAxisCount: 4,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 2.1,
            children: [
              for (final s in MockData.dashboardStats) StatCard(label: s.$1, value: s.$2),
            ],
          ),
          const SizedBox(height: 24),
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(flex: 13, child: _RecentAthletesCard(onTapAthlete: (id) => context.push('/athletes/$id'))),
                const SizedBox(width: 20),
                Expanded(flex: 10, child: _ActiveProgramsCard(onTapProgram: (id) => context.push('/programs/$id'))),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MobileDashboard extends StatelessWidget {
  const _MobileDashboard();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 14, 18, 6),
            child: Row(
              children: [
                Expanded(
                  child: Text('Ciao, ${MockData.proFirstName}',
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
                ),
                const AppAvatar(initials: 'AN', size: 32),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(18, 8, 18, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    childAspectRatio: 1.6,
                    children: [
                      for (final s in MockData.dashboardStats)
                        StatCard(label: s.$1, value: s.$2, compact: true),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () => context.push('/exercises/new'),
                          child: const Text('+ Esercizio', style: TextStyle(fontSize: 12)),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => context.push('/programs/new'),
                          child: const Text('+ Programma', style: TextStyle(fontSize: 12)),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => context.push('/athletes/new'),
                          child: const Text('+ Atleta', style: TextStyle(fontSize: 12)),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  _RecentAthletesCard(onTapAthlete: (id) => context.push('/athletes/$id')),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _RecentAthletesCard extends StatelessWidget {
  final ValueChanged<String> onTapAthlete;

  const _RecentAthletesCard({required this.onTapAthlete});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Atleti recenti', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          for (final a in MockData.athletes)
            InkWell(
              onTap: () => onTapAthlete(a.id),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 8),
                decoration: const BoxDecoration(
                  border: Border(bottom: BorderSide(color: AppColors.border)),
                ),
                child: Row(
                  children: [
                    AppAvatar(initials: a.initials, size: 32),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(a.fullName, style: const TextStyle(fontSize: 13)),
                          Text(a.activeProgram,
                              style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                        ],
                      ),
                    ),
                    Text(a.lastWorkout,
                        style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _ActiveProgramsCard extends StatelessWidget {
  final ValueChanged<String> onTapProgram;

  const _ActiveProgramsCard({required this.onTapProgram});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Programmi attivi', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          for (final p in MockData.programs)
            InkWell(
              onTap: () => onTapProgram(p.id),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: const BoxDecoration(
                  border: Border(bottom: BorderSide(color: AppColors.border)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(p.name, style: const TextStyle(fontSize: 13)),
                    const SizedBox(height: 2),
                    Text('${p.athleteCount} atleti assegnati',
                        style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
