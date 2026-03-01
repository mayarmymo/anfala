import 'package:flutter/material.dart';
import 'levels_page.dart';
import 'daily_streak_page.dart';
import 'challenges_page.dart';
import '../../pages/store_page.dart';
import '../support/profile_page.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});
  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _index = 0;
  final List<Widget> _pages = [
    const LevelsPage(),
    const DailyStreakPage(), // صفحة السلسلة
    const ChallengesPage(),  // صفحة التحديات
    const StorePage(),       // صفحة المتجر الجديدة
    const ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_index],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _index,
        onTap: (i) => setState(() => _index = i),
        type: BottomNavigationBarType.fixed, // لظهار 5 أيقونات بشكل صحيح
        selectedItemColor: Colors.orange,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.map), label: 'المراحل'),
          BottomNavigationBarItem(icon: Icon(Icons.local_fire_department), label: 'السلسلة'),
          BottomNavigationBarItem(icon: Icon(Icons.star), label: 'التحديات'),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_bag), label: 'المتجر'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'حسابي'),
        ],
      ),
    );
  }
}