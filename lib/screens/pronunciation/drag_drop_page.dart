import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:audioplayers/audioplayers.dart';
import 'evaluation_page.dart'; // استيراد صفحة التقييم

const Color pinoNavy = Color(0xFF1E2A47);
const Color pinoOrange = Color(0xFFFF9F1C);

class DragDropPage extends StatefulWidget {
  final String wordTitle;
  final List<String> targetLetters;
  final String imagePath;
  final String? nextLevelKey;

  const DragDropPage({
    super.key,
    required this.wordTitle,
    required this.targetLetters,
    required this.imagePath,
    this.nextLevelKey,
  });

  @override
  State<DragDropPage> createState() => _DragDropPageState();
}

class _DragDropPageState extends State<DragDropPage> {
  late List<String> shuffledLetters;
  late List<String?> droppedLetters;
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isSuccess = false;

  // خريطة لربط الحرف العربي باسم ملف الصوت الإنجليزي
  final Map<String, String> letterSounds = {
    'أ': 'alf',
    'ب': 'baa',
    'ت': 'taa',
    'ث': 'thaa',
    'ج': 'jeem',
    'ح': 'haa',
    'خ': 'khaa',
    'د': 'dal',
    'ذ': 'dhal',
    'ر': 'raa',
    'ز': 'zay',
    'س': 'seen',
    'ش': 'sheen',
    'ص': 'sad',
    'ض': 'dad',
    'ط': 'tah',
    'ظ': 'zah',
    'ع': 'ain',
    'غ': 'ghain',
    'ف': 'faa',
    'ق': 'qaf',
    'ك': 'kaf',
    'ل': 'lam',
    'م': 'meem',
    'ن': 'noon',
    'ه': 'haa_2', // أو الاسم الذي اخترته للهاء
    'و': 'waw',
    'ي': 'yaa',
  };

  @override
  void initState() {
    super.initState();
    shuffledLetters = List.from(widget.targetLetters)..shuffle();
    droppedLetters = List.filled(widget.targetLetters.length, null);
  }

  // تشغيل صوت الحرف بناءً على الخريطة
  void _playLetterSound(String letter) async {
    try {
      String fileName = letterSounds[letter] ?? letter;
      await _audioPlayer.stop();
      await _audioPlayer.play(AssetSource('sounds/letters/$fileName.mp3'));
    } catch (e) {
      debugPrint("خطأ في تشغيل الصوت: $e");
    }
  }

  Future<void> _checkResult() async {
    if (droppedLetters.contains(null)) return;

    if (widget.nextLevelKey != null) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(widget.nextLevelKey!, true);
    }

    // بدلاً من SnackBar، ننتقل إلى صفحة التقييم
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) =>
            const EvaluationPage(score: 100), // 100 نقطة للنجاح
      ),
    );
  }

  void _showErrorFeedback() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const EvaluationPage(score: 0), // 0 نقطة للخطأ
      ),
    );
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) Navigator.pop(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Stack(
          children: [
            Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.only(top: 100),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // الصورة تظهر دائماً في الأعلى
                    Image.asset(widget.imagePath,
                        width: 200,
                        height: 200,
                        errorBuilder: (context, error, stackTrace) =>
                            const Icon(Icons.image,
                                size: 100, color: Colors.grey)),
                    const SizedBox(height: 20),

                    // النص التوضيحي
                    Text(
                      _isSuccess
                          ? "رائع! لقد كونت كلمة: ${widget.wordTitle}"
                          : "اسحب الحرف إلى مكانه الصحيح",
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: _isSuccess ? Colors.green : pinoNavy),
                    ),

                    const SizedBox(height: 40),

                    // منطقة الإفلات (الخانات)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children:
                          List.generate(widget.targetLetters.length, (index) {
                        return DragTarget<String>(
                          onAccept: (data) {
                            if (data == widget.targetLetters[index]) {
                              _playLetterSound(data);
                              setState(() {
                                droppedLetters[index] = data;
                                shuffledLetters.remove(data);
                              });
                              _checkResult(); // إذا كان صحيحاً
                            } else {
                              _showErrorFeedback(); // إذا كان خاطئاً
                            }
                          },
                          builder: (context, candidateData, rejectedData) {
                            return Container(
                              width: 70,
                              height: 70,
                              margin: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: droppedLetters[index] != null
                                    ? pinoOrange
                                    : Colors.grey[200],
                                borderRadius: BorderRadius.circular(15),
                                border: Border.all(
                                    color: pinoNavy.withOpacity(0.3), width: 2),
                              ),
                              child: Center(
                                child: Text(droppedLetters[index] ?? "",
                                    style: const TextStyle(
                                        fontSize: 28,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white)),
                              ),
                            );
                          },
                        );
                      }),
                    ),

                    const SizedBox(height: 60),

                    // منطقة الحروف (تختفي عند النجاح)
                    if (!_isSuccess)
                      Wrap(
                        spacing: 20,
                        children: shuffledLetters.map((letter) {
                          return Draggable<String>(
                            data: letter,
                            feedback: Material(
                                color: Colors.transparent,
                                child: _buildLetterBox(letter, true)),
                            childWhenDragging: Opacity(
                                opacity: 0.3,
                                child: _buildLetterBox(letter, false)),
                            child: _buildLetterBox(letter, false),
                          );
                        }).toList(),
                      ),
                  ],
                ),
              ),
            ),
            // زر الرجوع
            Positioned(
              top: 45,
              right: 20,
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
          ],
        ),
      ),
    );
  }

  Widget _buildLetterBox(String letter, bool isFeedback) {
    return Container(
      width: 65,
      height: 65,
      decoration: BoxDecoration(
        color: pinoNavy,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          if (!isFeedback)
            const BoxShadow(
                color: Colors.black26, blurRadius: 5, offset: Offset(0, 3))
        ],
      ),
      child: Center(
        child: Text(letter,
            style: const TextStyle(
                color: Colors.white,
                fontSize: 26,
                fontWeight: FontWeight.bold,
                decoration: TextDecoration.none)),
      ),
    );
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }
}
