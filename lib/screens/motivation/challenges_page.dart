import 'package:flutter/material.dart';

class ChallengesPage extends StatelessWidget {
  const ChallengesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> eduChallenges = [
      {"title": "نطق 5 كلمات بالفتحة", "icon": Icons.mic, "progress": 0.6, "color": Colors.orange},
      {"title": "ترتيب كلمة (قمر)", "icon": Icons.extension, "progress": 1.0, "color": Color(0xFF1E2A47)},
      {"title": "قراءة قصة الحروف", "icon": Icons.auto_stories, "progress": 0.4, "color": Colors.green},
      {"title": "تمرين الحركات اليومي", "icon": Icons.spellcheck, "progress": 0.2, "color": Colors.blue},
    ];

    return Scaffold(
      appBar: AppBar(title: const Text("تحدياتي الدراسية"), centerTitle: true),
      body: ListView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: eduChallenges.length,
        itemBuilder: (context, index) {
          final item = eduChallenges[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 15),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            child: ListTile(
              leading: Icon(item['icon'], color: item['color']),
              title: Text(item['title'], style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: LinearProgressIndicator(value: item['progress'], color: item['color']),
              trailing: Text("${(item['progress'] * 100).toInt()}%"),
            ),
          );
        },
      ),
    );
  }
}