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
      backgroundColor: const Color(0xFFF0F4F8), // خلفية رمادية فاتحة
      appBar: AppBar(
        title: Text("رتب حروف: ${widget.wordTitle}", 
          style: const TextStyle(fontFamily: 'Vazirmatn', fontWeight: FontWeight.bold, color: Colors.white)
        ),
        backgroundColor: pinoNavy,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(25),
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
      ),
      body: Directionality(
        textDirection: TextDirection.rtl, // لضمان الترتيب من اليمين لليسار
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            // --- صورة الكلمة (القمر أو غيره) ---
            Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 15, offset: const Offset(0, 5))],
              ),
              child: Image.asset(
                "assets/images/${widget.wordTitle}.jpg", 
                height: 150,
                width: 150,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(Icons.image_not_supported, size: 120, color: Colors.grey);
                },
              ),
            ),
            
            const SizedBox(height: 30),

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
                      width: 65,
                      height: 65,
                      margin: const EdgeInsets.symmetric(horizontal: 5),
                      decoration: BoxDecoration(
                        color: isFilled ? Colors.green.shade300 : Colors.white,
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(
                          color: isFilled ? Colors.green : Colors.grey.shade300,
                          width: 2,
                        ),
                        boxShadow: [
                          BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 5, offset: const Offset(0, 2))
                        ],
                      ),
                      child: Center(
                        child: Text(
                          _placedLetters[index] ?? "",
                          style: const TextStyle(
                            fontFamily: 'Vazirmatn', // استخدم خطًا سميكًا وممتعًا
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

            const SizedBox(height: 30),

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
                      child: _buildLetterBlock(letter, isDragging: true),
                    ),
                    childWhenDragging: Container(
                      width: 65,
                      height: 65,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300, 
                        borderRadius: BorderRadius.circular(15)
                      ),
                    ),
                    child: _buildLetterBlock(letter),
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
      ),
    );
  }

  // --- ويدجت بناء قطعة الحرف الخشبية ---
  Widget _buildLetterBlock(String letter, {bool isDragging = false}) {
    return Container(
      width: 65,
      height: 65,
      decoration: BoxDecoration(
        color: const Color(0xFF1E2A47),
        borderRadius: BorderRadius.circular(15),
        boxShadow: isDragging
            ? [const BoxShadow(color: Colors.black38, blurRadius: 15, spreadRadius: 2)]
            : [
                // ظل سفلي لإعطاء عمق
                BoxShadow(
                  color: const Color(0xFF10182B).withOpacity(0.8),
                  offset: const Offset(0, 5),
                  blurRadius: 0,
                ),
              ],
      ),
      alignment: Alignment.center,
      child: Text(
        letter,
        style: const TextStyle(
            color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold, fontFamily: 'Vazirmatn'),
      ),
    );
  }
}  