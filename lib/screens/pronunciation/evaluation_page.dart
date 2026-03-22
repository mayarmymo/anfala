import 'package:flutter/material.dart';

class EvaluationPage extends StatelessWidget {
  final int score;
  const EvaluationPage({super.key, required this.score});

  // دالة لتحديد الرسالة واللون بناءً على النتيجة
  Map<String, dynamic> _getEvaluationData() {
    if (score >= 90) {
      return {
        "message": "عبقري مذهل! 🌟",
        "subMessage": "لقد أتقنت هذا التمرين بامتياز!",
        "color": Colors.green,
        "icon": Icons.workspace_premium,
      };
    } else if (score >= 50) {
      return {
        "message": "أداء رائع! 👍",
        "subMessage": "أنت في طريقك لتصبح بطلاً!",
        "color": const Color(0xFFFF9F1C), // برتقالي بينو
        "icon": Icons.stars_rounded,
      };
    } else {
      return {
        "message": "محاولة جيدة! 💪",
        "subMessage": "استمر في التدريب، ستتحسن بالتأكيد!",
        "color": Colors.blueGrey,
        "icon": Icons.rebase_edit,
      };
    }
  }

  @override
  Widget build(BuildContext context) {
    final eval = _getEvaluationData(); // جلب البيانات بناءً على النتيجة

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5FA),
      appBar: AppBar(
        title: const Text("تقييم التمرين", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF1E2A47),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // أيقونة تتغير حسب النتيجة مع تأثير بسيط
              Icon(eval['icon'], size: 140, color: eval['color']),
              
              const SizedBox(height: 30),
              
              // العنوان المتغير
              Text(
                eval['message'],
                style: TextStyle(fontSize: 34, fontWeight: FontWeight.bold, color: eval['color']),
                textAlign: TextAlign.center,
              ),
              
              const SizedBox(height: 10),
              
              // الرسالة الفرعية المتغيرة
              Text(
                eval['subMessage'],
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 18, color: Colors.grey),
              ),

              const SizedBox(height: 30),

              // بطاقة النقاط
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
                ),
                child: Column(
                  children: [
                    const Text("مجموع النقاط", style: TextStyle(color: Colors.grey)),
                    Text(
                      "$score",
                      style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold, color: Color(0xFF1E2A47)),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 50),

              // زر العودة
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1E2A47),
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  ),
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.refresh, color: Colors.white),
                  label: const Text("العودة للتمارين", style: TextStyle(color: Colors.white, fontSize: 18)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}