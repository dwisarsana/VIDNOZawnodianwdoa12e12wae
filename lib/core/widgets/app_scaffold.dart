import 'package:flutter/material.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_gradients.dart';

class AppScaffold extends StatelessWidget {
  final Widget child;
  final Widget? bottomNavigationBar;
  final Widget? floatingActionButton;
  final PreferredSizeWidget? appBar;
  final bool extendBodyBehindAppBar;
  final bool extendBody;

  const AppScaffold({
    super.key,
    required this.child,
    this.bottomNavigationBar,
    this.floatingActionButton,
    this.appBar,
    this.extendBodyBehindAppBar = false,
    this.extendBody = false,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: extendBodyBehindAppBar,
      extendBody: extendBody,
      appBar: appBar,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background Gradient
          Container(
            decoration: const BoxDecoration(
              gradient: AppGradients.bgGradientMain,
            ),
          ),

          // Optional Background Decoration (Orbs, Globs, etc.) can be added here

          // Main Content
          SafeArea(
            top: !extendBodyBehindAppBar,
            bottom: !extendBody,
            child: child,
          ),
        ],
      ),
      bottomNavigationBar: bottomNavigationBar,
      floatingActionButton: floatingActionButton,
    );
  }
}
