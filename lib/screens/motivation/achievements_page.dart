import 'package:flutter/material.dart';

class AchievementsPage extends StatelessWidget {
  const AchievementsPage({super.key});

  @override
  Widget build(BuildContext context) {
    // الألوان والخطوط الخاصة بـ بينو
    const Color pinoNavy = Color(0xFF1E2A47);
    const String appFont = 'Vazirmatn';

    final List<Map<String, dynamic>> eduChallenges = [
      {"title": "نطق 5 كلمات بالفتحة", "icon": Icons.mic_none_outlined, "progress": 0.6, "color": Colors.orange},
      {"title": "ترتيب الكلمات)", "icon": Icons.extension_outlined, "progress": 1.0, "color": pinoNavy},
      {"title": "ترتيب جمل  ", "icon": Icons.menu_book_outlined, "progress": 0.4, "color": Colors.green},
      {"title": "تمرين الحركات ", "icon": Icons.spellcheck_outlined, "progress": 0.2, "color": Colors.blue},
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        // إضافة زر الرجوع في اليسار (لون كحلي ليظهر على الخلفية البيضاء)
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: pinoNavy),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: const Text(
          "الانجازات",
          style: TextStyle(
            fontFamily: appFont,
            color: pinoNavy,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
      ),
      body: Directionality(
        textDirection: TextDirection.rtl, // لضمان ظهور العناصر من اليمين لليسار
        child: ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          itemCount: eduChallenges.length,
          itemBuilder: (context, index) {
            final item = eduChallenges[index];
            return Container(
              margin: const EdgeInsets.only(bottom: 15),
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: const Color(0xFFF5F7F9), // الخلفية الرمادية الفاتحة 
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  Icon(item['icon'], color: item['color'], size: 30),
                  const SizedBox(width: 15),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item['title'],
                          style: const TextStyle(
                            fontFamily: appFont,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: pinoNavy,
                          ),
                        ),
                        const SizedBox(height: 10),
                        // شريط التقدم المخصص
                        Stack(
                          children: [
                            Container(
                              height: 8,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: Colors.grey.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            FractionallySizedBox(
                              widthFactor: item['progress'],
                              child: Container(
                                height: 8,
                                decoration: BoxDecoration(
                                  color: item['color'],
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 15),
                  Text(
                    "${(item['progress'] * 100).toInt()}%",
                    style: const TextStyle(
                      fontFamily: appFont,
                      fontSize: 14,
                      color: Colors.grey,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}