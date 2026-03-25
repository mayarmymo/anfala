import 'package:flutter/material.dart';

class SpeechPracticePage extends StatefulWidget {
  final String targetWord;
  // القيمة الافتراضية "قمر" لضمان عمل الصفحة حتى لو تم استدعاؤها بدون معامل
  const SpeechPracticePage({super.key, this.targetWord = "قمر"});

  @override
  State<SpeechPracticePage> createState() => _SpeechPracticePageState();
}

class _SpeechPracticePageState extends State<SpeechPracticePage> {
  bool _isListening = false;
  String _feedbackMessage = "اضغط على الميكروفون وتحدث";
  Color _feedbackColor = Colors.grey;
  bool _isSuccess = false;

  void _startListening() async {
    setState(() {
      _isListening = true;
      _feedbackMessage = "جاري الاستماع...";
      _feedbackColor = Colors.blue;
      _isSuccess = false;
    });

    // محاكاة وقت الاستماع (لأننا لا نملك مكتبة تعرف صوت حقيقي هنا)
    await Future.delayed(const Duration(seconds: 3));

    if (!mounted) return;

    setState(() {
      _isListening = false;
      // محاكاة أن النطق صحيح (دائماً صحيح للتشجيع في هذه المرحلة)
      _isSuccess = true;
      _feedbackMessage = "أحسنت! نطقك صحيح ممتاز 🎉";
      _feedbackColor = Colors.green;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("تمرين النطق"),
        backgroundColor: const Color(0xFF1E2A47),
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "انطق كلمة: ${widget.targetWord}",
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            // عرض صورة الكلمة
            Image.asset(
              "assets/images/${widget.targetWord}.png", 
              height: 120,
              errorBuilder: (c, e, s) => const Icon(Icons.image, size: 80, color: Colors.grey),
            ),
            const SizedBox(height: 40),
            GestureDetector(
              onTap: _isListening ? null : _startListening,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                padding: const EdgeInsets.all(30),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _isListening ? Colors.redAccent : Colors.orange,
                  boxShadow: [
                    BoxShadow(color: (_isListening ? Colors.red : Colors.orange).withOpacity(0.4), blurRadius: 15, spreadRadius: 5)
                  ],
                ),
                child: Icon(_isListening ? Icons.graphic_eq : Icons.mic, size: 60, color: Colors.white),
              ),
            ),
            const SizedBox(height: 30),
            Text(_feedbackMessage, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: _feedbackColor), textAlign: TextAlign.center),
            if (_isSuccess)
              Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: ElevatedButton.icon(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.check),
                  label: const Text("إنهاء التمرين"),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.green, foregroundColor: Colors.white),
                ),
              )
          ],
        ),
      ),
    );
  }
}