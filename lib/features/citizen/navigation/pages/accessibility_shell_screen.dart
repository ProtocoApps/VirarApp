import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../../core/localization/app_localizations.dart';
import '../../../../../core/theme/app_theme.dart';
import '../../../../../core/widgets/global_zoom_fab.dart';
import '../../home/pages/accessibility_home_screen.dart';
import '../../../home/presentation/pages/map_screen.dart';
import '../../profile/pages/citizen_profile_screen.dart';

class AccessibilityShellScreen extends StatefulWidget {
  const AccessibilityShellScreen({super.key, this.initialIndex = 0});

  final int initialIndex;

  @override
  State<AccessibilityShellScreen> createState() => _AccessibilityShellScreenState();
}

class _AccessibilityShellScreenState extends State<AccessibilityShellScreen> {
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
  }

  @override
  Widget build(BuildContext context) {
    final strings = context.t;

    final pages = [
      const AccessibilityHomeScreen(showBottomNavigation: false),
      const MapScreen(showBottomNavigation: false),
      const CitizenProfileScreen(
        showBottomNavigation: false,
        showBackButton: false,
      ),
    ];

    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: pages,
      ),
      floatingActionButton: _currentIndex != 1 ? const GlobalZoomFAB() : null,
      bottomNavigationBar: Semantics(
        label: 'Barra de navegação inferior',
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.deepBlack,
            border: Border(
              top: BorderSide(color: AppColors.gold.withOpacity(0.3)),
            ),
          ),
          child: BottomNavigationBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            type: BottomNavigationBarType.fixed,
            currentIndex: _currentIndex,
            selectedItemColor: AppColors.gold,
            unselectedItemColor: AppColors.lightGray,
            onTap: (index) {
              HapticFeedback.lightImpact();
              setState(() {
                _currentIndex = index;
              });
            },
            items: [
              const BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Início',
              ),
              const BottomNavigationBarItem(
                icon: Icon(Icons.map_outlined),
                label: 'Mapa',
              ),
              BottomNavigationBarItem(
                icon: const Icon(Icons.person),
                label: strings.text('profile_nav'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
