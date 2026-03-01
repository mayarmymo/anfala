import 'package:flutter/material.dart';

class EvaluationPage extends StatelessWidget {
  final int score;
  const EvaluationPage({super.key, required this.score});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.check_circle, color: Colors.green, size: 100),
            const SizedBox(height: 20),
            const Text("ممتاز! نطقك صحيح", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            Text("%$score", style: const TextStyle(fontSize: 50, color: Color(0xFFFF9F1C), fontWeight: FontWeight.bold)),
            const SizedBox(height: 40),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF1E2A47)),
              onPressed: () => Navigator.popUntil(context, (route) => route.isFirst),
              child: const Text("العودة للمستويات", style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}