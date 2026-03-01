import 'package:flutter/material.dart';

class AchievementsPage extends StatelessWidget {
  const AchievementsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _buildBadge("بطل الحروف", "أكملت أول كلمة بنجاح!", Icons.emoji_events, Colors.amber),
          _buildBadge("المستكشف", "فتحت 5 مستويات جديدة", Icons.explore, Colors.blue),
          _buildBadge("الطباخ الماهر", "طبخت كلمة (قمر) في المطبخ", Icons.restaurant, Colors.orange),
        ],
      ),
    );
  }

  Widget _buildBadge(String title, String desc, IconData icon, Color color) {
    return Card(
      margin: const EdgeInsets.only(bottom: 15),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color.withOpacity(0.2),
          child: Icon(icon, color: color),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(desc),
        trailing: const Icon(Icons.check_circle, color: Colors.green),
      ),
    );
  }
}