import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../theme/app_theme.dart';

class _TabSpec {
  final String label;
  final IconData icon;
  final IconData selectedIcon;
  final int? branchIndex;
  const _TabSpec({
    required this.label,
    required this.icon,
    required this.selectedIcon,
    this.branchIndex,
  });
}

class AppNavigation extends StatefulWidget {
  final StatefulNavigationShell navigationShell;
  const AppNavigation({required this.navigationShell, super.key});

  @override
  State<AppNavigation> createState() => _AppNavigationState();
}

class _AppNavigationState extends State<AppNavigation> {
  int _selectedVisualIndex = 0;

  static const List<_TabSpec> _tabs = [
    _TabSpec(
      label: 'Leads',
      icon: Icons.people_outline_rounded,
      selectedIcon: Icons.people_rounded,
      branchIndex: 0,
    ),
    _TabSpec(
      label: 'Add Lead',
      icon: Icons.add_circle_outline_rounded,
      selectedIcon: Icons.add_circle_rounded,
      branchIndex: 1,
    ),
    _TabSpec(
      label: 'Analytics',
      icon: Icons.bar_chart_outlined,
      selectedIcon: Icons.bar_chart_rounded,
      branchIndex: null,
    ),
    _TabSpec(
      label: 'Profile',
      icon: Icons.person_outline_rounded,
      selectedIcon: Icons.person_rounded,
      branchIndex: null,
    ),
  ];

  void _onTabTap(int visualIndex) {
    final tab = _tabs[visualIndex];
    if (tab.branchIndex == null) return; // stub tab — silent ignore
    setState(() => _selectedVisualIndex = visualIndex);
    widget.navigationShell.goBranch(
      tab.branchIndex!,
      initialLocation: tab.branchIndex == widget.navigationShell.currentIndex,
    );
  }

  @override
  void didUpdateWidget(AppNavigation oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Sync visual index with shell index
    final currentBranch = widget.navigationShell.currentIndex;
    for (int i = 0; i < _tabs.length; i++) {
      if (_tabs[i].branchIndex == currentBranch) {
        if (_selectedVisualIndex != i) {
          setState(() => _selectedVisualIndex = i);
        }
        break;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return NavigationBar(
      selectedIndex: _selectedVisualIndex,
      onDestinationSelected: _onTabTap,
      backgroundColor: theme.colorScheme.surface,
      indicatorColor: AppTheme.primaryContainer,
      elevation: 0,
      shadowColor: Colors.transparent,
      surfaceTintColor: Colors.transparent,
      destinations: List.generate(_tabs.length, (i) {
        final tab = _tabs[i];
        final isStub = tab.branchIndex == null;
        return NavigationDestination(
          icon: Opacity(opacity: isStub ? 0.4 : 1.0, child: Icon(tab.icon)),
          selectedIcon: Opacity(
            opacity: isStub ? 0.4 : 1.0,
            child: Icon(tab.selectedIcon),
          ),
          label: tab.label,
        );
      }),
    );
  }
}
