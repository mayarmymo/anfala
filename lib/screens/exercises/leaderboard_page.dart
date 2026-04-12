import 'package:flutter/material.dart';

const Color pinoNavy = Color(0xFF1E2A47); // تم تعريفها هنا
const Color pinoOrange = Color(0xFFFF9F1C); // تم تعريفها هنا

class LeaderboardPage extends StatefulWidget {
  const LeaderboardPage({super.key});

  @override
  State<LeaderboardPage> createState() => _LeaderboardPageState();
}

class _LeaderboardPageState extends State<LeaderboardPage> {
  final List<Map<String, dynamic>> _leaderboardData = [
    {
      'name': 'أحمد',
      'score': 1250,
      'avatar': 'assets/images/penguin_3d.jpg'
    }, // المركز الأول
    {'name': 'ليلى', 'score': 1100, 'avatar': null}, // المركز الثاني
    {'name': 'خالد', 'score': 980, 'avatar': null}, // المركز الثالث
    {'name': 'أنت', 'score': 850, 'isUser': true}, // تم التعديل لتكون الرابع
    {'name': 'يوسف', 'score': 720},
    {'name': 'ياسر', 'score': 700},
    {'name': 'لمار', 'score': 600}
  ];

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Stack(
          children: [
            Column(
              children: [
                const SizedBox(height: 60),
                // --- إعادة منصة التتويج بشكل أبيض وأنيق لحل مشكلة الصفحة البيضاء ---
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      _buildPodiumPlace(context,
                          rank: 2,
                          user: _leaderboardData[1],
                          height: 70,
                          color: const Color(0xFFC0C0C0)), // فضي
                      const SizedBox(width: 10),
                      _buildPodiumPlace(context,
                          rank: 1,
                          user: _leaderboardData[0],
                          height: 100,
                          color: const Color(0xFFFFD700)), // ذهبي
                      const SizedBox(width: 10),
                      _buildPodiumPlace(context,
                          rank: 3,
                          user: _leaderboardData[2],
                          height: 60,
                          color: const Color(0xFFCD7F32)), // برونزي
                    ],
                  ),
                ),
                // --- بقية القائمة ---
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.fromLTRB(15, 20, 15, 20),
                    itemCount: _leaderboardData.length - 3, // تخطي أول 3 فائزين
                    itemBuilder: (context, index) {
                      final entry = _leaderboardData[index + 3];
                      final bool isUser = entry['isUser'] ?? false;
                      final int rank = index + 4;

                      return Container(
                        margin: const EdgeInsets.only(bottom: 15),
                        decoration: BoxDecoration(
                          color:
                              isUser ? pinoNavy.withOpacity(0.1) : Colors.white,
                          borderRadius: BorderRadius.circular(15),
                          border: isUser
                              ? Border.all(color: pinoNavy, width: 1.5)
                              : null,
                          boxShadow: [
                            BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 10,
                                offset: const Offset(0, 4))
                          ],
                        ),
                        child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 15, vertical: 5),
                          leading: Text("#$rank",
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey.shade500)),
                          title: Text(entry['name'],
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: pinoNavy,
                                  fontFamily: 'Vazirmatn')),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text("${entry['score']}",
                                  style: TextStyle(
                                      color: pinoNavy,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16)),
                              const SizedBox(width: 5),
                              const Icon(Icons.star, color: pinoNavy, size: 20),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
            // --- زر الرجوع ---
            Positioned(
              top: 45,
              right: 20,
              child: IconButton(
                icon: const Icon(Icons.close, color: pinoNavy, size: 28),
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- ويدجت بناء منصة التتويج ---
  Widget _buildPodiumPlace(BuildContext context,
      {required int rank,
      required Map<String, dynamic> user,
      required double height,
      required Color color}) {
    final bool isFirst = rank == 1;
    return Column(
      children: [
        // --- الصورة الرمزية ---
        CircleAvatar(
          radius: isFirst ? 28 : 22,
          backgroundColor: color,
          child: CircleAvatar(
            radius: isFirst ? 25 : 19,
            backgroundImage:
                user['avatar'] != null ? AssetImage(user['avatar']) : null,
            child: user['avatar'] == null
                ? const Icon(Icons.person, size: 30, color: Colors.white)
                : null,
          ),
        ),
        const SizedBox(height: 8),
        // --- منصة التتويج ---
        Container(
          width: isFirst ? 85 : 70,
          height: height,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [color.withOpacity(0.8), color],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            boxShadow: [
              BoxShadow(
                  color: color.withOpacity(0.5),
                  blurRadius: 15,
                  offset: const Offset(0, 5))
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(user['name'],
                  style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Vazirmatn',
                      fontSize: 14)),
              const SizedBox(height: 4),
              Text("${user['score']}",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: isFirst ? 20 : 16,
                      fontWeight: FontWeight.bold)),
            ],
          ),
        ),
      ],
    );
  }
}
