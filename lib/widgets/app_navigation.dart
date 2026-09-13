import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../theme/app_theme.dart';

class _TabSpec {
  final String label;
  final IconData icon;
  final IconData selectedIcon;
  final int branchIndex;
  const _TabSpec({
    required this.label,
    required this.icon,
    required this.selectedIcon,
    required this.branchIndex,
  });
}

class AppNavigation extends StatefulWidget {
  final StatefulNavigationShell navigationShell;
  const AppNavigation({required this.navigationShell, super.key});

  @override
  State<AppNavigation> createState() => _AppNavigationState();
}

class _AppNavigationState extends State<AppNavigation> {
  static const List<_TabSpec> _tabs = [
    _TabSpec(
      label: 'Dashboard',
      icon: Icons.dashboard_outlined,
      selectedIcon: Icons.dashboard_rounded,
      branchIndex: 0,
    ),
    _TabSpec(
      label: 'Leads',
      icon: Icons.people_outline_rounded,
      selectedIcon: Icons.people_rounded,
      branchIndex: 1,
    ),
    _TabSpec(
      label: 'Interests',
      icon: Icons.star_outline_rounded,
      selectedIcon: Icons.star_rounded,
      branchIndex: 2,
    ),
    _TabSpec(
      label: 'Logs',
      icon: Icons.bar_chart_outlined,
      selectedIcon: Icons.bar_chart_rounded,
      branchIndex: 3,
    ),
  ];

  void _onTabTap(int visualIndex) {
    final tab = _tabs[visualIndex];
    widget.navigationShell.goBranch(
      tab.branchIndex,
      initialLocation: tab.branchIndex == widget.navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final currentIndex = widget.navigationShell.currentIndex;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Divider(height: 1, color: AppTheme.surface200),
        NavigationBar(
          selectedIndex: currentIndex,
          onDestinationSelected: _onTabTap,
          backgroundColor: theme.colorScheme.surface,
          indicatorColor: AppTheme.primaryContainer,
          elevation: 0,
          shadowColor: Colors.transparent,
          surfaceTintColor: Colors.transparent,
          labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
          destinations: _tabs.map((tab) {
            return NavigationDestination(
              icon: Icon(tab.icon),
              selectedIcon: Icon(tab.selectedIcon, color: AppTheme.primary),
              label: tab.label,
            );
          }).toList(),
        ),
      ],
    );
  }
}
