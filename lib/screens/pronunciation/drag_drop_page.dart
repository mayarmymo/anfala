import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:audioplayers/audioplayers.dart';
import 'speech_practice_page.dart';

class DragDropPage extends StatefulWidget {
  final String wordTitle; // الكلمة المطلوب ترتيبها (مثلاً: قمر)
  final List<String> targetLetters; // حروف الكلمة بالترتيب الصحيح
  final String? nextLevelKey; // مفتاح تخزين لفتح المرحلة التالية

  const DragDropPage({
    super.key,
    required this.wordTitle,
    required this.targetLetters,
    this.nextLevelKey,
  });

  @override
  State<DragDropPage> createState() => _DragDropPageState();
}

class _DragDropPageState extends State<DragDropPage> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  late List<String> _shuffledLetters;
  final Map<int, String> _placedLetters = {}; // لتخزين الحروف التي تم وضعها في الخانات
  bool _isSuccess = false;

  @override
  void initState() {
    super.initState();
    // خلط الحروف عند البدء لزيادة التحدي
    _shuffledLetters = List<String>.from(widget.targetLetters)..shuffle();
  }

  // تشغيل صوت الحرف (اختياري)
  Future<void> _playLetterSound(String letter) async {
    // مصفوفة بسيطة لربط الحروف بملفات الصوت إذا كانت الأسماء تختلف
    final Map<String, String> letterSoundMap = {
      'ق': 'qaf', 'م': 'meem', 'ر': 'raa', 'أ': 'alif', 'س': 'seen', 'د': 'dal', 'ج': 'jeem', 'ل': 'lam'
    };
    
    final soundName = letterSoundMap[letter] ?? 'pop'; // pop صوت افتراضي
    try {
      await _audioPlayer.play(AssetSource('sounds/letters/$soundName.mp3'));
    } catch (e) {
      // تجاهل الخطأ إذا لم يوجد ملف صوت
    }
  }

  // دالة للتحقق من صحة الترتيب
  void _checkSuccess() async {
    if (_placedLetters.length == widget.targetLetters.length) {
      bool allCorrect = true;
      for (int i = 0; i < widget.targetLetters.length; i++) {
        if (_placedLetters[i] != widget.targetLetters[i]) {
          allCorrect = false;
          break;
        }
      }

      if (allCorrect) {
        setState(() {
          _isSuccess = true;
        });

        // حفظ تقدم اللاعب لفتح المرحلة التالية
        if (widget.nextLevelKey != null) {
          final prefs = await SharedPreferences.getInstance();
          await prefs.setBool(widget.nextLevelKey!, true);
        }

        // إظهار نافذة الفوز
        if (mounted) _showWinDialog();
      }
    }
  }

  void _showWinDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
        title: const Text("أحسنت! 🎉", textAlign: TextAlign.center, style: TextStyle(fontFamily: 'Vazirmatn')),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // صورة الكلمة التي تم إنجازها (قمر، أسد، جمل)
            Image.asset(
              "assets/images/${widget.wordTitle}.jpg",
              height: 100,
              width: 100,
              fit: BoxFit.contain,
              errorBuilder: (ctx, err, stack) => const Icon(Icons.star, size: 80, color: Colors.amber),
            ),
            const SizedBox(height: 15),
            const Text("لقد رتبت الكلمة بشكل صحيح", style: TextStyle(fontFamily: 'Vazirmatn')),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFF9F1C),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              ),
              onPressed: () {
                Navigator.pop(context); // إغلاق النافذة
                // الانتقال لصفحة النطق
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => SpeechPracticePage(targetWord: widget.wordTitle)),
                );
              },
              child: const Text("التالي: تمرين النطق 🎤", style: TextStyle(color: Colors.white, fontFamily: 'Vazirmatn')),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // الألوان والهوية
    const Color pinoNavy = Color(0xFF1E2A47);
    const Color pinoOrange = Color(0xFFFF9F1C);
    
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("رتب حروف: ${widget.wordTitle}", 
          style: const TextStyle(fontFamily: 'Vazirmatn', fontWeight: FontWeight.bold, color: Colors.white)
        ),
        backgroundColor: pinoNavy,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
      ),
      body: Directionality(
        textDirection: TextDirection.rtl, // لضمان الترتيب من اليمين لليسار
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // --- صورة الكلمة (القمر أو غيره) ---
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                shape: BoxShape.circle,
              ),
              child: Image.asset(
                "assets/images/${widget.wordTitle}.jpg", 
                height: 150,
                width: 150,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(Icons.image_not_supported, size: 80, color: Colors.grey);
                },
              ),
            ),
            
            const SizedBox(height: 50),

            // --- خانات الهدف (حيث يتم إفلات الحروف) ---
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(widget.targetLetters.length, (index) {
                return DragTarget<String>(
                  onAccept: (data) {
                    // التحقق مما إذا كان الحرف المسحوب هو الحرف الصحيح لهذا المكان
                    if (data == widget.targetLetters[index]) {
                      setState(() {
                        _placedLetters[index] = data;
                      });
                      _playLetterSound(data);
                      _checkSuccess();
                    } else {
                      // إذا كان الحرف خاطئاً، نظهر رسالة ولا نقبله
                      ScaffoldMessenger.of(context).hideCurrentSnackBar(); // إخفاء أي رسالة سابقة
                      ScaffoldMessenger.of(context).showSnackBar( // عرض الرسالة لمدة أقصر
                        const SnackBar(content: Text("حاول مرة أخرى! ❌", style: TextStyle(fontFamily: 'Vazirmatn')), backgroundColor: Colors.redAccent, duration: Duration(milliseconds: 800)),
                      );
                    }
                  },
                  builder: (context, candidateData, rejectedData) {
                    bool isFilled = _placedLetters.containsKey(index);
                    return Container(
                      width: 60,
                      height: 60,
                      margin: const EdgeInsets.symmetric(horizontal: 5),
                      decoration: BoxDecoration(
                        color: isFilled ? pinoOrange : Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isFilled ? pinoOrange : Colors.grey,
                          width: 2,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          _placedLetters[index] ?? "",
                          style: const TextStyle(
                            fontFamily: 'Vazirmatn',
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    );
                  },
                );
              }),
            ),

            const SizedBox(height: 50),

            // --- الحروف المبعثرة (للسحب) ---
            if (!_isSuccess)
              Wrap(
                spacing: 15,
                runSpacing: 15,
                alignment: WrapAlignment.center,
                children: _shuffledLetters.map((letter) {
                  // إذا كان الحرف مستخدماً في أحد الخانات، نقوم بإخفائه أو تعطيله
                  // (لتبسيط اللعبة: نسمح بسحب نسخ متعددة أو يمكن تحسينها لإخفاء المستخدم)
                  return Draggable<String>(
                    data: letter,
                    feedback: Material(
                      color: Colors.transparent,
                      child: Container(
                        width: 60,
                        height: 60,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: pinoNavy.withOpacity(0.9),
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: const [BoxShadow(blurRadius: 10, color: Colors.black26)],
                        ),
                        child: Text(letter, style: const TextStyle(color: Colors.white, fontSize: 28, fontFamily: 'Vazirmatn')),
                      ),
                    ),
                    childWhenDragging: Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(12)),
                    ),
                    child: Container(
                      width: 60,
                      height: 60,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(color: pinoNavy, borderRadius: BorderRadius.circular(12)),
                      child: Text(letter, style: const TextStyle(color: Colors.white, fontSize: 28, fontFamily: 'Vazirmatn')),
                    ),
                  );
                }).toList(),
              )
            
              // رسالة صغيرة أسفل الشاشة في حالة النجاح (النافذة ستظهر أيضاً)
                        else
              Column(
                children: const [
                  SizedBox(height: 20),
                  Text(
                    "ممتاز! 🎉",
                    style: TextStyle(
                      fontFamily: 'Vazirmatn',
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    "تم ترتيب الكلمة بنجاح",
                    style: TextStyle(
                      fontFamily: 'Vazirmatn',
                      fontSize: 16,
                      color: Colors.black54,
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}  