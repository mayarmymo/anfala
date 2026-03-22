import 'package:flutter/material.dart';

class LeaderboardPage extends StatefulWidget {
  const LeaderboardPage({super.key});

  @override
  State<LeaderboardPage> createState() => _LeaderboardPageState();
}

class _LeaderboardPageState extends State<LeaderboardPage> {
  final List<Map<String, dynamic>> _leaderboardData = [
    {'name': 'أحمد', 'score': 1250},
    {'name': 'ليلى', 'score': 1100},
    {'name': 'خالد', 'score': 980},
    {'name': 'أنت', 'score': 850, 'isUser': true}, // تم التعديل لتكون الرابع
    {'name': 'يوسف', 'score': 720},
    {'name': 'ياسر', 'score': 700},
    {'name': 'لمار', 'score': 600}
  ];

  final Color pinoNavy = const Color(0xFF1E2A47);
  final Color pinoOrange = const Color(0xFFFF9F1C);

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        body: Stack(
          children: [
            Column(
              children: [
                Container(
                  height: 220, width: double.infinity,
                  decoration: BoxDecoration(color: pinoNavy, borderRadius: const BorderRadius.vertical(bottom: Radius.circular(40))),
                  child: const SafeArea(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.emoji_events, color: Colors.amber, size: 70),
                        Text("الأبطال المتصدرين", style: TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(20),
                    itemCount: _leaderboardData.length,
                    itemBuilder: (context, index) {
                      final entry = _leaderboardData[index];
                      final bool isUser = entry['isUser'] ?? false;
                      return Container(
                        margin: const EdgeInsets.only(bottom: 15),
                        decoration: BoxDecoration(
                          color: Colors.white, borderRadius: BorderRadius.circular(20),
                          border: isUser ? Border.all(color: pinoOrange, width: 2) : null,
                          boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 8)],
                        ),
                        child: ListTile(
                          leading: CircleAvatar(backgroundColor: pinoNavy.withOpacity(0.1), child: Text("${index + 1}")),
                          title: Text(entry['name'], style: TextStyle(fontWeight: FontWeight.bold, color: isUser ? pinoOrange : pinoNavy)),
                          trailing: Text("💎 ${entry['score']}", style: TextStyle(color: pinoOrange, fontWeight: FontWeight.bold)),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
            Positioned(
              top: 45, left: 20,
              child: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ],
        ),
      ),
    );
  }
}