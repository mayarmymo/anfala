import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart';

class SpeechPracticePage extends StatefulWidget {
  final String targetWord;

  const SpeechPracticePage({super.key, required this.targetWord});

  @override
  State<SpeechPracticePage> createState() => _SpeechPracticePageState();
}

class _SpeechPracticePageState extends State<SpeechPracticePage> {

  final SpeechToText _speech = SpeechToText();

  bool _isListening = false;
  final Color pinoNavy = const Color(0xFF1E2A47);
  final Color pinoOrange = const Color(0xFFFF9F1C);
  String _recognizedText = "";
  String _feedbackMessage = "اضغط على الميكروفون وتحدث";
  Color _feedbackColor = const Color(0xFF1E2A47);

  // إزالة الحركات للمقارنة الذكية
  String normalize(String text) {
    return text.replaceAll(RegExp(r'[ًٌٍَُِْ]'), '');
  }

  void _startListening() async {

    bool available = await _speech.initialize();

    if (!available) {
      setState(() {
        _feedbackMessage = "الميكروفون غير متاح";
        _feedbackColor = Colors.red;
      });
      return;
    }

    setState(() {
      _isListening = true;
      _feedbackMessage = "تحدث الآن...";
      _feedbackColor = Colors.blue;
      _recognizedText = "";
    });

    _speech.listen(
      localeId: "ar_SA",
      onResult: (result) {
        setState(() {
          _recognizedText = result.recognizedWords;
        });
      },
    );

    await Future.delayed(const Duration(seconds: 4));

    _speech.stop();

    setState(() {
      _isListening = false;
      _checkAnswer();
    });
  }

  void _checkAnswer() {

    String spoken = normalize(_recognizedText);
    String target = normalize(widget.targetWord);

    if (spoken.contains(target)) {
      _feedbackMessage = "أحسنت! نطق صحيح 🎉";
      _feedbackColor = pinoOrange;
    } else {
      _feedbackMessage = "حاول مرة أخرى ❌";
      _feedbackColor = pinoOrange;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
      backgroundColor: Colors.white,

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
              "انطق: ${widget.targetWord}",
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1E2A47),
              ),
            ),

            const SizedBox(height: 20),

            Image.asset(
              "assets/images/apple.jpg",
              height: 120,
              errorBuilder: (c, e, s) =>
                  const Icon(Icons.image, size: 80, color: Colors.grey),
            ),

            const SizedBox(height: 20),

            // عرض ما قاله الطفل
            Text(
              "قلت: $_recognizedText",
              style: const TextStyle(color: Colors.black54),
            ),

            const SizedBox(height: 30),

            GestureDetector(
              onTap: _isListening ? null : _startListening,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                padding: const EdgeInsets.all(30),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _isListening ? Colors.red : const Color(0xFF1E2A47),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 15,
                    )
                  ],
                ),
                child: Icon(
                  _isListening ? Icons.graphic_eq : Icons.mic,
                  size: 60,
                  color: Colors.white,
                ),
              ),
            ),

            const SizedBox(height: 30),Text(
              _feedbackMessage,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: _feedbackColor,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    ),
    );
  }
}