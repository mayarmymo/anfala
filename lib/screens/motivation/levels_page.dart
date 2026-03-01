import 'package:flutter/material.dart';
import '../pronunciation/drag_drop_page.dart';

class LevelsPage extends StatelessWidget {
  const LevelsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _buildLevelItem(context, "المستوى 1: كلمة قمر", Icons.star, isLocked: false),
          _buildLevelItem(context, "المستوى 2: كلمة أسد", Icons.lock, isLocked: true),
          _buildLevelItem(context, "المستوى 3: كلمة جمل", Icons.lock, isLocked: true),
        ],
      ),
    );
  }

  Widget _buildLevelItem(BuildContext context, String title, IconData icon, {required bool isLocked}) {
    return GestureDetector(
      onTap: () {
        if (!isLocked) {
          Navigator.push(context, MaterialPageRoute(builder: (context) => const DragDropPage()));
        }
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 10),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isLocked ? Colors.grey[300] : const Color(0xFF1E2A47),
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: isLocked ? Colors.grey : const Color(0xFFFF9F1C), width: 2),
        ),
        child: Row(
          children: [
            Icon(icon, color: isLocked ? Colors.grey : const Color(0xFFFF9F1C), size: 30),
            const SizedBox(width: 20),
            Text(title, style: TextStyle(color: isLocked ? Colors.grey : Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}