import 'package:flutter/material.dart';

class DailyStreakPage extends StatelessWidget {
  const DailyStreakPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1E2A47), // خلفية داكنة Pino
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.local_fire_department, size: 120, color: Color(0xFFFF9F1C)),
            const Text("12", style: TextStyle(fontSize: 80, fontWeight: FontWeight.bold, color: Colors.white)),
            const Text("يوم من الاستمرار!", style: TextStyle(fontSize: 24, color: Colors.white70)),
            const SizedBox(height: 40),
            Container(
              padding: const EdgeInsets.all(20),
              margin: const EdgeInsets.symmetric(horizontal: 40),
              decoration: BoxDecoration(color: Colors.white.withOpacity(0.1), borderRadius: BorderRadius.circular(20)),
              child: const Text(
                "أنت بطل يا يزن! حافظ على مستواك لتفتح جوائز Pino ",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}