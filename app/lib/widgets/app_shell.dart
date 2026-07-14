import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../data/mock_data.dart';
import '../theme/app_colors.dart';
import '../theme/breakpoints.dart';
import 'app_avatar.dart';

class _NavEntry {
  final String label;
  final IconData icon;
  final bool mobileVisible;

  const _NavEntry(this.label, this.icon, {this.mobileVisible = true});
}

const _navEntries = [
  _NavEntry('Dashboard', Icons.space_dashboard_rounded),
  _NavEntry('Libreria Esercizi', Icons.video_collection_rounded),
  _NavEntry('Programmi', Icons.assignment_rounded),
  _NavEntry('Atleti', Icons.groups_rounded),
  _NavEntry('Impostazioni', Icons.settings_rounded, mobileVisible: false),
];

/// Responsive shell wrapping the four/five main sections: sidebar on
/// desktop/tablet, bottom navigation bar on phone — same codebase, same
/// branch state, per the wireframe's "Desktop" and "Mobile Pro" groups.
class AppShell extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const AppShell({super.key, required this.navigationShell});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isDesktop = constraints.maxWidth >= AppBreakpoints.desktop;
        return isDesktop ? _buildDesktop(context) : _buildMobile(context);
      },
    );
  }

  Widget _buildDesktop(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          Container(
            width: 232,
            decoration: const BoxDecoration(
              color: AppColors.surface,
              border: Border(right: BorderSide(color: AppColors.border)),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                  child: Row(
                    children: [
                      Container(
                        width: 28,
                        height: 28,
                        decoration: BoxDecoration(
                          color: AppColors.accent,
                          borderRadius: BorderRadius.circular(7),
                        ),
                        child: const Icon(Icons.bolt_rounded, color: Colors.white, size: 18),
                      ),
                      const SizedBox(width: 10),
                      const Expanded(
                        child: Text(
                          'Coach Exercise\nManager',
                          style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, height: 1.15),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 18),
                for (var i = 0; i < _navEntries.length; i++)
                  _SidebarItem(
                    entry: _navEntries[i],
                    selected: navigationShell.currentIndex == i,
                    onTap: () => navigationShell.goBranch(
                      i,
                      initialLocation: i == navigationShell.currentIndex,
                    ),
                  ),
                const Spacer(),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                  child: Row(
                    children: [
                      const AppAvatar(initials: 'AN', size: 30),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          MockData.proFirstName,
                          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(child: navigationShell),
        ],
      ),
    );
  }

  Widget _buildMobile(BuildContext context) {
    final mobileEntries =
        _navEntries.where((e) => e.mobileVisible).toList(growable: false);
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: DecoratedBox(
        decoration: const BoxDecoration(
          color: AppColors.surface,
          border: Border(top: BorderSide(color: AppColors.border)),
        ),
        child: SafeArea(
          child: SizedBox(
            height: 60,
            child: Row(
              children: [
                for (var i = 0; i < mobileEntries.length; i++)
                  Expanded(
                    child: _BottomNavItem(
                      entry: mobileEntries[i],
                      selected: navigationShell.currentIndex == i,
                      onTap: () => navigationShell.goBranch(
                        i,
                        initialLocation: i == navigationShell.currentIndex,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SidebarItem extends StatelessWidget {
  final _NavEntry entry;
  final bool selected;
  final VoidCallback onTap;

  const _SidebarItem({required this.entry, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 2),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            decoration: BoxDecoration(
              color: selected ? AppColors.accentSoft : Colors.transparent,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(
                  entry.icon,
                  size: 18,
                  color: selected ? AppColors.accent : AppColors.textSecondary,
                ),
                const SizedBox(width: 10),
                Text(
                  entry.label,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: selected ? AppColors.accent : AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _BottomNavItem extends StatelessWidget {
  final _NavEntry entry;
  final bool selected;
  final VoidCallback onTap;

  const _BottomNavItem({required this.entry, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final color = selected ? AppColors.accent : AppColors.textSecondary;
    return InkWell(
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(entry.icon, size: 20, color: color),
          const SizedBox(height: 3),
          Text(entry.label.replaceFirst(' Esercizi', ''),
              style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: color)),
        ],
      ),
    );
  }
}
