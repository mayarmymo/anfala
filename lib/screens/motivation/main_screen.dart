import 'package:flutter/material.dart';
import 'package:anfalahmad/pages/store_page.dart';
import 'package:anfalahmad/screens/motivation/achievements_page.dart';
import 'package:anfalahmad/screens/motivation/streak_page.dart';
import 'package:anfalahmad/screens/support/profile_page.dart';
import 'package:anfalahmad/screens/exercises/exercises_hub_page.dart';
import 'package:anfalahmad/screens/motivation/levels_page.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  // تم التعديل ليكون 0 (حسابي) هو الصفحة الأولى التي تظهر
  int _selectedIndex = 0; 

  final List<Widget> _pages = <Widget>[
    const ProfilePage(), 
    const StorePage(), 
    const AchievementsPage(), 
    const StreakPage(), 
    const ExercisesHubPage(), 
    const LevelsPage(), 
  ];
  
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    const Color pinoOrange = Color(0xFFFF9F1C);
    const String appFont = 'Vazirmatn';

    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: pinoOrange,
        unselectedItemColor: Colors.grey, 
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedLabelStyle: const TextStyle(fontFamily: appFont, fontSize: 12, fontWeight: FontWeight.bold),
        unselectedLabelStyle: const TextStyle(fontFamily: appFont, fontSize: 12),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), activeIcon: Icon(Icons.person), label: 'حسابي'),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_bag_outlined), activeIcon: Icon(Icons.shopping_bag), label: 'المتجر'),
          BottomNavigationBarItem(icon: Icon(Icons.star_border_outlined), activeIcon: Icon(Icons.star), label: 'الانجازات'),
          BottomNavigationBarItem(icon: Icon(Icons.local_fire_department_outlined), activeIcon: Icon(Icons.local_fire_department), label: 'السلسلة'),
          BottomNavigationBarItem(icon: Icon(Icons.model_training_outlined), activeIcon: Icon(Icons.model_training), label: 'التمارين'),
          BottomNavigationBarItem(icon: Icon(Icons.map_outlined), activeIcon: Icon(Icons.map), label: 'المراحل'),
        ],
      ),
    );
  }
}