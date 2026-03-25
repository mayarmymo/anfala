import 'package:flutter/material.dart';

class LeaderboardPage extends StatefulWidget {
  const LeaderboardPage({super.key});

  @override
  State<LeaderboardPage> createState() => _LeaderboardPageState();
}

class _LeaderboardPageState extends State<LeaderboardPage> {
  final List<Map<String, dynamic>> _leaderboardData = [
    {'name': 'أحمد', 'score': 1250, 'avatar': 'assets/images/penguin_3d.jpg'}, // المركز الأول
    {'name': 'ليلى', 'score': 1100, 'avatar': null}, // المركز الثاني
    {'name': 'خالد', 'score': 980, 'avatar': null}, // المركز الثالث
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
        backgroundColor: const Color(0xFFF0F4F8),
        body: Stack(
          children: [
            Column(
              children: [
                // --- رأس الصفحة ومنصة التتويج ---
                Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFF1E2A47), Color(0xFF2E406E)],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                    borderRadius: BorderRadius.vertical(bottom: Radius.circular(40)),
                  ),
                  child: SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 20, bottom: 40),
                      child: Column(
                        children: [
                          const Text("قاعة الأبطال", style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold, fontFamily: 'Vazirmatn')),
                          const SizedBox(height: 25),
                          // --- منصة التتويج ثلاثية الأبعاد ---
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              _buildPodiumPlace(context, rank: 2, user: _leaderboardData[1], height: 110, color: const Color(0xFFC0C0C0)), // فضي
                              _buildPodiumPlace(context, rank: 1, user: _leaderboardData[0], height: 150, color: const Color(0xFFFFD700)), // ذهبي
                              _buildPodiumPlace(context, rank: 3, user: _leaderboardData[2], height: 90, color: const Color(0xFFCD7F32)), // برونزي
                            ],
                          ),
                        ],
                      ),
                    ),
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
                          color: isUser ? pinoOrange.withOpacity(0.1) : Colors.white,
                          borderRadius: BorderRadius.circular(15),
                          border: isUser ? Border.all(color: pinoOrange, width: 1.5) : null,
                          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))],
                        ),
                        child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                          leading: Text("#$rank", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.grey.shade500)),
                          title: Text(entry['name'], style: TextStyle(fontWeight: FontWeight.bold, color: isUser ? pinoOrange : pinoNavy, fontFamily: 'Vazirmatn')),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text("${entry['score']}", style: TextStyle(color: pinoOrange, fontWeight: FontWeight.bold, fontSize: 16)),
                              const SizedBox(width: 5),
                              Icon(Icons.star, color: pinoOrange, size: 20),
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
              left: 20,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 20),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- ويدجت بناء منصة التتويج ---
  Widget _buildPodiumPlace(BuildContext context, {required int rank, required Map<String, dynamic> user, required double height, required Color color}) {
    final bool isFirst = rank == 1;
    return Column(
      children: [
        // --- التاج للمركز الأول ---
        if (isFirst) const Text("👑", style: TextStyle(fontSize: 30)),
        if (!isFirst) const SizedBox(height: 35),
        // --- الصورة الرمزية ---
        CircleAvatar(
          radius: isFirst ? 35 : 28,
          backgroundColor: color,
          child: CircleAvatar(
            radius: isFirst ? 32 : 25,
            backgroundImage: user['avatar'] != null ? AssetImage(user['avatar']) : null,
            child: user['avatar'] == null ? const Icon(Icons.person, size: 30, color: Colors.white) : null,
          ),
        ),
        const SizedBox(height: 8),
        // --- منصة التتويج ---
        Container(
          width: isFirst ? 100 : 80,
          height: height,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [color.withOpacity(0.8), color],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            boxShadow: [BoxShadow(color: color.withOpacity(0.5), blurRadius: 15, offset: const Offset(0, 5))],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(user['name'], style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontFamily: 'Vazirmatn', fontSize: 14)),
              const SizedBox(height: 4),
              Text("${user['score']}", style:  TextStyle(color: Colors.white, fontSize: isFirst ? 20 : 16, fontWeight: FontWeight.bold)),
            ],
          ),
        ),
      ],
    );
  }
}