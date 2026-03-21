import 'package:flutter/material.dart';

class BackgroundScaffold extends StatelessWidget {
  final Widget child;
  const BackgroundScaffold({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Background Image
        Positioned.fill(
          child: Image.asset(
            'assets/images/app_bg.png',
            fit: BoxFit.cover,
          ),
        ),
        // The Screen Content
        // We use a Scaffold here (if needed) or just the child.
        // If the child is already a Scaffold, we rely on its background being transparent.
        child,
      ],
    );
  }
}
