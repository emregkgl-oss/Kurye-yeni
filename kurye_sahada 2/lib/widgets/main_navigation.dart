import 'package:flutter/material.dart';

import '../screens/achievements_screen.dart';
import '../screens/case_list_screen.dart';
import '../screens/home_screen.dart';
import '../screens/profile_screen.dart';
import '../screens/progress_screen.dart';

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _index = 0;

  final _screens = const [
    HomeScreen(),
    CaseListScreen(),
    ProgressScreen(),
    AchievementsScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _index, children: _screens),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _index,
        onTap: (i) => setState(() => _index = i),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: 'Ana Sayfa'),
          BottomNavigationBarItem(icon: Icon(Icons.menu_book_outlined), label: 'Vakalar'),
          BottomNavigationBarItem(icon: Icon(Icons.bar_chart_outlined), label: 'Gelişimim'),
          BottomNavigationBarItem(icon: Icon(Icons.emoji_events_outlined), label: 'Başarılar'),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'Profil'),
        ],
      ),
    );
  }
}
