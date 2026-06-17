import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../../core/localization/app_localizations.dart';
import '../../../../../core/theme/app_theme.dart';
import '../../../../../core/widgets/global_zoom_fab.dart';
import '../../../home/presentation/pages/home_screen.dart';
import '../../../home/presentation/pages/map_screen.dart';
import '../../profile/pages/citizen_profile_screen.dart';
import '../../../search/presentation/pages/search_screen.dart';

class CitizenShellScreen extends StatefulWidget {
  const CitizenShellScreen({super.key, this.initialIndex = 0});

  final int initialIndex;

  @override
  State<CitizenShellScreen> createState() => _CitizenShellScreenState();
}

class _CitizenShellScreenState extends State<CitizenShellScreen> {
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
      const HomeScreen(showBottomNavigation: false),
      const SearchScreen(showBottomNavigation: false),
      const MapScreen(showBottomNavigation: false),
      const CitizenProfileScreen(
        showBottomNavigation: false,
        showBackButton: false,
      ),
    ];

    return Scaffold(
      floatingActionButton: _currentIndex != 2 ? const GlobalZoomFAB() : null,
      body: IndexedStack(
        index: _currentIndex,
        children: pages,
      ),
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
              BottomNavigationBarItem(
                icon: Semantics(
                  label: 'Ícone de casa',
                  child: const Icon(Icons.home),
                ),
                label: strings.text('home_nav'),
              ),
              BottomNavigationBarItem(
                icon: Semantics(
                  label: 'Ícone de lupa',
                  child: const Icon(Icons.search),
                ),
                label: strings.text('search_nav'),
              ),
              BottomNavigationBarItem(
                icon: Semantics(
                  label: 'Ícone de mapa',
                  child: const Icon(Icons.map_outlined),
                ),
                label: 'Mapa',
              ),
              BottomNavigationBarItem(
                icon: Semantics(
                  label: 'Ícone de pessoa',
                  child: const Icon(Icons.person),
                ),
                label: strings.text('profile_nav'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
