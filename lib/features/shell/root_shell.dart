import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_gradients.dart';
import '../../data/local/shared_prefs_service.dart';
import '../create/create_screen.dart';
import '../projects/projects_screen.dart';
import '../templates/templates_screen.dart';
import '../profile/profile_screen.dart';
import 'root_shell_controller.dart';

class RootShell extends StatefulWidget {
  const RootShell({super.key});

  @override
  State<RootShell> createState() => _RootShellState();
}

class _RootShellState extends State<RootShell> {
  RootShellController? _controller;

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    final prefs = await SharedPrefsService.getInstance();
    if (!mounted) return;
    setState(() {
      _controller = RootShellController(prefs);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_controller == null) {
      // Return a temporary scaffold or loading while controller inits
      // Since it's fast (local prefs), this flash is minimal.
      return const Scaffold(body: SizedBox.shrink());
    }

    return AnimatedBuilder(
      animation: _controller!,
      builder: (context, _) {
        return Scaffold(
          extendBody: true, // Necessary for glass effect behind nav bar
          body: IndexedStack(
            index: _controller!.currentIndex,
            children: const [
              CreateScreen(),
              ProjectsScreen(),
              TemplatesScreen(),
              ProfileScreen(),
            ],
          ),
          bottomNavigationBar: _GlassNavBar(
            currentIndex: _controller!.currentIndex,
            onTap: _controller!.setIndex,
          ),
        );
      },
    );
  }
}

class _GlassNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const _GlassNavBar({
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // Glass container
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          height: 84 + MediaQuery.of(context).padding.bottom / 2, // Taller for aesthetics
          padding: EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom / 2),
          decoration: BoxDecoration(
            color: AppColors.glassTintMed, // Semi-transparent
            border: Border(
              top: BorderSide(color: AppColors.glassBorder, width: 0.5),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _NavBarItem(
                icon: CupertinoIcons.add_circled,
                activeIcon: CupertinoIcons.add_circled_solid,
                label: 'Create',
                isActive: currentIndex == 0,
                onTap: () => onTap(0),
              ),
              _NavBarItem(
                icon: CupertinoIcons.folder,
                activeIcon: CupertinoIcons.folder_solid,
                label: 'Projects',
                isActive: currentIndex == 1,
                onTap: () => onTap(1),
              ),
              _NavBarItem(
                icon: CupertinoIcons.square_grid_2x2,
                activeIcon: CupertinoIcons.square_grid_2x2_fill,
                label: 'Templates',
                isActive: currentIndex == 2,
                onTap: () => onTap(2),
              ),
              _NavBarItem(
                icon: CupertinoIcons.person,
                activeIcon: CupertinoIcons.person_solid,
                label: 'Profile',
                isActive: currentIndex == 3,
                onTap: () => onTap(3),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavBarItem extends StatelessWidget {
  final IconData icon;
  final IconData activeIcon;
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _NavBarItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isActive ? activeIcon : icon,
              color: isActive ? AppColors.primary : AppColors.textSecondary,
              size: 24,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
                color: isActive ? AppColors.primary : AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
