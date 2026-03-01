import 'package:flutter/material.dart';
import 'penguin_mood.dart';
import '../screens/support/profile_page.dart'; 
class PenguinScaffold extends StatelessWidget {
  final String title;
  final Widget child;
  final PenguinMood mood;
  final String message;
  final double progress; // إضافة المتغير هنا ضرورية جداً
  const PenguinScaffold({
    super.key,
    required this.title,
    required this.child,
    this.mood = PenguinMood.normal,
    this.message = "",
    this.progress = 0.0, // القيمة الافتراضية
  });
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: Colors.blueAccent,
        actions: [
          IconButton(
            icon: const CircleAvatar(
              backgroundColor: Colors.white,
              radius: 15,
              child: Icon(Icons.person, size: 20, color: Colors.blueAccent),
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ProfilePage()),
              );
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Column(
        children: [
          // شريط التقدم يظهر فقط إذا كانت القيمة أكبر من صفر
          if (progress > 0)
            LinearProgressIndicator(
              value: progress,
              backgroundColor: Colors.grey[200],
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.orange),
            ),
          Expanded(child: child),
        ],
      ),
    );
  }
}
