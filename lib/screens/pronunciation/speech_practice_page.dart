import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:shared_preferences/shared_preferences.dart';

const Color pinoNavy = Color(0xFF1E2A47);
const Color pinoOrange = Color(0xFFFF9F1C);

class SpeechPracticePage extends StatefulWidget {
  final String targetWord;

  const SpeechPracticePage({super.key, required this.targetWord});

  @override
  State<SpeechPracticePage> createState() => _SpeechPracticePageState();
}

class _SpeechPracticePageState extends State<SpeechPracticePage> {
  final SpeechToText _speech = SpeechToText();

  bool _isListening = false;
  String _recognizedText = "";
  String _feedbackMessage = "اضغط على الميكروفون وتحدث";
  Color _feedbackColor = pinoNavy;
  double _progress = 0.0;
  int _userHearts = 0;

  @override
  void initState() {
    super.initState();
    _loadProgress();
  }

  Future<void> _loadProgress() async {
    final prefs = await SharedPreferences.getInstance();
    int count = 0;
    List<String> keys = [
      'ex_speech',
      'ex_movements',
      'ex_advanced',
      'ex_chef',
      'ex_pino',
      'ex_levels'
    ];
    for (String key in keys) {
      if (prefs.getBool(key) ?? false) count++;
    }
    setState(() {
      _progress = count / 6;
      _userHearts = prefs.getInt('user_hearts') ?? 60;
    });
  }

  // إزالة الحركات للمقارنة الذكية
  String normalize(String text) {
    return text
        .replaceAll(RegExp(r'[ًٌٍَُِْ]'), '') // إزالة الحركات
        .replaceAll('ة', 'ه') // توحيد التاء المربوطة والهاء
        .replaceAll('أ', 'ا') // توحيد الألفات
        .replaceAll('إ', 'ا')
        .replaceAll('آ', 'ا')
        .trim();
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
      _saveSuccess();
      _feedbackMessage = "أحسنت! نطق صحيح 🎉";
      _feedbackColor = Colors.green;
    } else {
      _feedbackMessage = "حاول مرة أخرى ❌";
      _feedbackColor = Colors.red;
    }
  }

  Future<void> _saveSuccess() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('ex_speech', true);
    int hearts = prefs.getInt('user_hearts') ?? 60;
    await prefs.setInt('user_hearts', hearts + 10);
    _loadProgress();
  }

  @override
  Widget build(BuildContext context) {
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
            child: IconButton(
              icon: const Icon(Icons.close, color: pinoNavy, size: 28),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          title: const Text(
            "تمرين النطق",
            style: TextStyle(
                color: pinoNavy,
                fontWeight: FontWeight.bold,
                fontFamily: 'Vazirmatn'),
          ),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // إضافة شريط التقدم مع القلب
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Row(
                  children: [
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: LinearProgressIndicator(
                          value: _progress,
                          minHeight: 8,
                          backgroundColor: pinoNavy.withOpacity(0.1),
                          valueColor:
                              const AlwaysStoppedAnimation<Color>(pinoNavy),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    const Icon(Icons.favorite, color: Colors.red, size: 22),
                    const SizedBox(width: 5),
                    Text("$_userHearts",
                        style: const TextStyle(
                            color: pinoNavy, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
              Text(
                "انطق: ${widget.targetWord}",
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: pinoNavy,
                  fontFamily: 'Vazirmatn',
                ),
              ),

              const SizedBox(height: 20),

              ShaderMask(
                shaderCallback: (rect) => const RadialGradient(
                  colors: [Colors.black, Colors.transparent],
                  stops: [0.8, 1.0],
                ).createShader(rect),
                blendMode: BlendMode.dstIn,
                child: Image.asset(
                  "assets/images/happle.jpg",
                  height: 120,
                  errorBuilder: (c, e, s) =>
                      const Icon(Icons.image, size: 80, color: Colors.grey),
                ),
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
                    color: _isListening ? Colors.red : pinoNavy,
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

              const SizedBox(height: 30),
              Text(
                _feedbackMessage,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: _feedbackColor,
                  fontFamily: 'Vazirmatn',
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
