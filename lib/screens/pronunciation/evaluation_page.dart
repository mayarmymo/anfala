import 'package:flutter/material.dart';

const Color pinoNavy = Color(0xFF1E2A47);
const Color pinoOrange = Color(0xFFFF9F1C);

class EvaluationPage extends StatelessWidget {
  final int score;
  const EvaluationPage({super.key, required this.score});

  // دالة لتحديد الرسالة واللون بناءً على النتيجة
  Map<String, dynamic> _getEvaluationData() {
    if (score == 100) {
      return {
        "message": "عبقري مذهل! 🌟",
        "subMessage": "لقد أتقنت هذا التمرين بامتياز!",
        "color": Colors.green,
        "image": "assets/images/happy.jpg",
      };
    } else if (score > 0) {
      return {
        "message": "أداء رائع! 👍",
        "subMessage": "أنت في طريقك لتصبح بطلاً!",
        "color": pinoOrange, // برتقالي بينو
        "image": "assets/images/penguin_3d.jpg",
      };
    } else {
      return {
        "message": "محاولة جيدة! 💪",
        "subMessage": "استمر في التدريب، ستتحسن بالتأكيد!",
        "color": pinoNavy,
        "image": "assets/images/saad.jpg",
      };
    }
  }

  @override
  Widget build(BuildContext context) {
    final eval = _getEvaluationData(); // جلب البيانات بناءً على النتيجة

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
          automaticallyImplyLeading: false,
          leading: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(
                  color: pinoNavy.withOpacity(0.1), shape: BoxShape.circle),
              child: IconButton(
                icon: const Icon(Icons.arrow_forward_ios_rounded,
                    color: pinoNavy, size: 18),
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ),
          title: const Text(
            "تقييم التمرين",
            style: TextStyle(
                color: pinoNavy,
                fontWeight: FontWeight.bold,
                fontFamily: 'Vazirmatn'),
          ),
        ),
        body: Center(
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // صورة تتغير حسب النتيجة
                Image.asset(
                  eval['image'],
                  height: 120,
                  width: 120,
                  fit: BoxFit.contain,
                  errorBuilder: (c, e, s) => Icon(Icons.stars_rounded,
                      size: 100, color: eval['color']),
                ),

                const SizedBox(height: 15),

                // العنوان المتغير
                Text(
                  eval['message'],
                  style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: eval['color']),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 5),

                // الرسالة الفرعية المتغيرة
                Text(
                  eval['subMessage'],
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 16, color: pinoNavy),
                ),

                const SizedBox(height: 20),

                // بطاقة النقاط
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black.withOpacity(0.05), blurRadius: 10)
                    ],
                  ),
                  child: Column(
                    children: [
                      const Text("مجموع النقاط",
                          style: TextStyle(color: Colors.grey)),
                      Text(
                        "$score", // عرض النتيجة الفعلية
                        style: const TextStyle(
                            fontSize: 40,
                            fontWeight: FontWeight.bold,
                            color: pinoNavy),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 30),

                // زر العودة
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: pinoOrange, // تغيير اللون إلى البرتقالي
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                    ),
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.refresh, color: pinoNavy),
                    label: const Text(
                        "العودة للتمارين", // تغيير لون النص ليتناسب مع الخلفية البرتقالية
                        style: TextStyle(
                            color: pinoNavy,
                            fontSize: 18,
                            fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
