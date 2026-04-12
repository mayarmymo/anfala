import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:audioplayers/audioplayers.dart';

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

  double _progress = 0.0;
  int _userHearts = 0;

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
    _loadProgress();
    shuffledLetters = List.from(widget.targetLetters)..shuffle();
    droppedLetters = List.filled(widget.targetLetters.length, null);
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

    final prefs = await SharedPreferences.getInstance();
    if (widget.nextLevelKey != null) {
      await prefs.setBool(widget.nextLevelKey!, true);
    }

    // عند إكمال تمرين ترتيب الكلمات، نزيد القلوب ونحدث الحالة
    await prefs.setBool('ex_levels', true);
    int hearts = prefs.getInt('user_hearts') ?? 60;
    await prefs.setInt('user_hearts', hearts + 10);
    _loadProgress();

    setState(() => _isSuccess = true);
    _showFeedback();
  }

  void _showFeedback() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("أحسنت! إجابة رائعة 🎉", textAlign: TextAlign.center),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _showErrorFeedback() {
    // This function was added for EvaluationPage, but now it's not needed.
    // We can just show a SnackBar or do nothing.
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("حاول وضع الحرف في مكان آخر!"),
        duration: Duration(milliseconds: 500)));
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double boxSize = (screenWidth - 80) / widget.targetLetters.length;
    boxSize = boxSize.clamp(50.0, 75.0); // ضمان حجم مناسب للخانات

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Stack(
          children: [
            Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // إضافة شريط التقدم العلوي
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Row(
                        children: [
                          Expanded(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: LinearProgressIndicator(
                                value: _progress,
                                minHeight: 8,
                                backgroundColor: pinoNavy.withOpacity(0.1),
                                valueColor: const AlwaysStoppedAnimation<Color>(
                                    pinoNavy),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          const Icon(Icons.favorite,
                              color: Colors.red, size: 22),
                          const SizedBox(width: 5),
                          Text("$_userHearts",
                              style: const TextStyle(
                                  color: pinoNavy,
                                  fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                    // الصورة تظهر دائماً في الأعلى
                    Image.asset(widget.imagePath,
                        width: 160,
                        height: 160,
                        errorBuilder: (context, error, stackTrace) =>
                            const Icon(Icons.image,
                                size: 100, color: Colors.grey)),
                    const SizedBox(height: 10),

                    // النص التوضيحي
                    Text(
                      _isSuccess
                          ? "رائع! لقد كونت كلمة: ${widget.wordTitle}"
                          : "اسحب الحرف إلى مكانه الصحيح",
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: pinoNavy), // تم تغيير اللون إلى pinoNavy
                    ),
                    const SizedBox(height: 20),

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
                              _checkResult();
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content:
                                          Text("حاول وضع الحرف في مكان آخر!"),
                                      duration: Duration(milliseconds: 500)));
                            }
                          },
                          builder: (context, candidateData, rejectedData) {
                            return Container(
                              width: boxSize,
                              height: boxSize,
                              margin: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                color: droppedLetters[index] != null
                                    ? pinoNavy
                                    : Colors.grey[200],
                                borderRadius: BorderRadius.circular(15),
                                border: Border.all(
                                    color: pinoNavy.withOpacity(0.3), width: 2),
                              ),
                              child: Center(
                                child: Text(droppedLetters[index] ?? "",
                                    style: TextStyle(
                                        // Removed const
                                        fontSize: boxSize * 0.4,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white)),
                              ),
                            );
                          },
                        );
                      }),
                    ),

                    const SizedBox(height: 30),

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
