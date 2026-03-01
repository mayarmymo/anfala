import 'package:flutter/material.dart';
import 'evaluation_page.dart';

class SpeechPracticePage extends StatefulWidget {
  const SpeechPracticePage({super.key});

  @override
  State<SpeechPracticePage> createState() => _SpeechPracticePageState();
}

class _SpeechPracticePageState extends State<SpeechPracticePage> {
  bool _isListening = false;
  final Color pinoNavy = const Color(0xFF1E2A47);
  final Color pinoOrange = const Color(0xFFFF9F1C);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("تمرين النطق"),
        backgroundColor: pinoNavy,
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // زر سماع الكلمة (اختياري لكنه مفيد للطفل)
            IconButton(
              icon: Icon(Icons.volume_up, size: 40, color: pinoOrange),
              onPressed: () {
                // هنا يمكن إضافة منطق نطق الكلمة للطفل (TTS)
              },
            ),
            const SizedBox(height: 10),
            const Text(
              "قَمَر",
              style: TextStyle(fontSize: 80, fontWeight: FontWeight.bold, color: Color(0xFF1E2A47)),
            ),
            const SizedBox(height: 60),

            // زر الميكروفون مع تأثير النبض
            Stack(
              alignment: Alignment.center,
              children: [
                if (_isListening)
                  _buildPulseEffect(), // تأثير الدوائر المتحركة
                GestureDetector(
                  onLongPressStart: (_) => setState(() => _isListening = true),
                  onLongPressEnd: (_) {
                    setState(() => _isListening = false);
                    // ننتقل للتقييم بدرجة عشوائية أو محسوبة
                    Navigator.pushReplacement(
                      context, 
                      MaterialPageRoute(builder: (context) => const EvaluationPage(score: 95))
                    );
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      color: _isListening ? Colors.red : pinoOrange,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: (_isListening ? Colors.red : pinoOrange).withOpacity(0.4),
                          blurRadius: 20,
                          spreadRadius: 5,
                        )
                      ],
                    ),
                    child: Icon(
                      _isListening ? Icons.stop : Icons.mic,
                      size: 60,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),
            Text(
              _isListening ? "اسحب إصبعك عند الانتهاء" : "اضغط مطولاً وانطق الكلمة",
              style: TextStyle(fontSize: 18, color: pinoNavy.withOpacity(0.7), fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  // تأثير نبض خلف الميكروفون لإعطاء حياة للكود
  Widget _buildPulseEffect() {
    return TweenAnimationBuilder(
      tween: Tween(begin: 1.0, end: 1.5),
      duration: const Duration(milliseconds: 500),
      builder: (context, double value, child) {
        return Container(
          width: 120 * value,
          height: 120 * value,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.red.withOpacity(0.2),
          ),
        );
      },
      onEnd: () => setState(() {}), // تكرار الأنميشن
    );
  }
}