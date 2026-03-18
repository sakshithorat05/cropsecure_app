import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'bottom_navbar.dart';

final navIndexProvider = NotifierProvider<NavIndexNotifier, int>(() {
  return NavIndexNotifier();
});

class NavIndexNotifier extends Notifier<int> {
  @override
  int build() => 0;
  void setIndex(int index) => state = index;
}

/// The main application shell that holds the persistent bottom navigation bar.
class AppShell extends ConsumerWidget {
  final Widget child;

  const AppShell({super.key, required this.child});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Determine the current index based on GoRouter location
    final location = GoRouterState.of(context).uri.path;
    int currentIndex = _calculateSelectedIndex(location);

    // Sync state if necessary
    WidgetsBinding.instance.addPostFrameCallback((_) {
       if (ref.read(navIndexProvider) != currentIndex) {
         ref.read(navIndexProvider.notifier).setIndex(currentIndex);
       }
    });

    return Scaffold(
      body: child, // The current nested page provided by ShellRoute
      bottomNavigationBar: BottomNavbar(
        currentIndex: currentIndex,
        onTap: (index) => _onItemTapped(index, context),
        onScanTap: () => context.go('/home/scan'),
      ),
    );
  }

  int _calculateSelectedIndex(String location) {
    if (location.startsWith('/home')) return 0;
    if (location.startsWith('/treatment')) return 1;
    if (location.startsWith('/market')) return 2;
    if (location.startsWith('/profile')) return 3;
    return 0; // Default
  }

  void _onItemTapped(int index, BuildContext context) {
    switch (index) {
      case 0:
        context.go('/home');
        break;
      case 1:
        context.go('/treatment');
        break;
      case 2:
        context.go('/market');
        break;
      case 3:
        context.go('/profile');
        break;
    }
  }
}
