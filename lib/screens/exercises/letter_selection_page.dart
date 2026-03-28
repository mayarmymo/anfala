import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
///import 'dart:math';

class LetterSelectionPage extends StatefulWidget {
  const LetterSelectionPage({super.key});

  @override
  State<LetterSelectionPage> createState() => _LetterSelectionPageState();
}

class _LetterSelectionPageState extends State<LetterSelectionPage> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  final String _targetLetter = 'س';
  late List<String> _boxLetters;
  String? _selectedLetter; 
  bool _showPino = false; 

  final Color pinoNavy = const Color(0xFF1E2A47);
  final Color pinoOrange = const Color(0xFFFF9F1C);

  @override
  void initState() {
    super.initState();
    _generateNewLevel();
    // تشغيل الصوت تلقائياً عند فتح الصفحة
    _playPinoSound(); 
  }

  void _generateNewLevel() {
    setState(() {
      _showPino = false;
      _selectedLetter = null;
      // قائمة حروف عشوائية ليختار منها التطبيق مع حرف السين
      List<String> others = ['أ', 'ب', 'ت', 'ث', 'ج', 'ح', 'خ', 'د', 'ر', 'ز', 'ش'];
      others.shuffle();
      _boxLetters = [_targetLetter, others[0], others[1]];
      _boxLetters.shuffle(); // تغيير أماكن الصناديق في كل مرة
    });
  }

  // دالة تشغيل الصوت الموحدة
  Future<void> _playPinoSound() async {
    try {
      await _audioPlayer.stop();
      await _audioPlayer.play(AssetSource('sounds/peno.mp3'));
    } catch (e) { 
      debugPrint("خطأ في تشغيل الصوت: $e"); 
    }
  }

  void _checkAnswer(String letter) {
    if (_showPino) return; // منع الضغط المتكرر بعد الفوز

    setState(() {
      _selectedLetter = letter;
    });

    if (letter == _targetLetter) {
      setState(() {
        _showPino = true; 
      });
      
      // تشغيل الصوت عند العثور على بينو
      _playPinoSound();
      
      // إظهار نافذة النجاح بعد ثانيتين من ظهور البطريق
      Future.delayed(const Duration(seconds: 2), () {
        _showSuccessDialog();
      });
    } else {
      // رسالة خطأ سريعة
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("أوه! لا يوجد أحد هنا.. حاول مرة أخرى! ❌", 
            textAlign: TextAlign.center, 
            style: TextStyle(fontFamily: 'Vazirmatn')
          ),
          backgroundColor: Colors.redAccent,
          duration: Duration(seconds: 1),
        ),
      );
    }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text("وجدته! 🎉", textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Vazirmatn')),
        content: const Text("أنت بطل رائع، لقد عثرت على بينو خلف حرف السين!", textAlign: TextAlign.center, style: TextStyle(fontFamily: 'Vazirmatn')),
        actions: [
          Center(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: pinoOrange,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))
              ),
              onPressed: () {
                Navigator.pop(context);
                _generateNewLevel();
              },
              child: const Text("لعبة جديدة", style: TextStyle(color: Colors.white, fontFamily: 'Vazirmatn')),
            ),
          )
        ],
      ),
    );
  }

  @override
  void dispose() {
    _audioPlayer.dispose(); // إغلاق مشغل الصوت عند الخروج لحفظ موارد الجهاز
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F4F8),
      appBar: AppBar(
        backgroundColor: pinoNavy,
        title: const Text("أين يختبئ بينو؟", style: TextStyle(color: Colors.white, fontFamily: 'Vazirmatn', fontWeight: FontWeight.bold)),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
        ],
        centerTitle: true,
        elevation: 0,
      ),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("بينو يحب الاختباء..", style: TextStyle(fontSize: 22, color: Colors.grey, fontFamily: 'Vazirmatn')),
            const SizedBox(height: 5),
            const Text("اضغط على الصندوق الذي يخبئ حرف (س)", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87, fontFamily: 'Vazirmatn')),
            
            const SizedBox(height: 100), // مساحة لظهور البطريق من الخلف
            
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: _boxLetters.map((letter) => _buildAnimatedBox(letter)).toList(),
            ),
            
            const SizedBox(height: 60),
            
            // زر إعادة تشغيل الصوت بشكل يدوي
            Column(
              children: [
                IconButton(
                  onPressed: _playPinoSound,
                  icon: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: pinoNavy.withOpacity(0.1),
                      shape: BoxShape.circle
                    ),
                    child: Icon(Icons.volume_up, color: pinoNavy, size: 45)
                  ),
                ),
                const Text("إعادة سماع الصوت", style: TextStyle(color: Colors.blueGrey, fontSize: 12, fontFamily: 'Vazirmatn')),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAnimatedBox(String letter) {
    bool isCorrect = (letter == _targetLetter && _showPino);

    return GestureDetector(
      onTap: () => _checkAnswer(letter),
      child: Stack(
        alignment: Alignment.bottomCenter,
        clipBehavior: Clip.none,
        children: [
          // البطريق يظهر خلف الصندوق (أنيميشن القفز المرن)
          AnimatedPositioned(
            duration: const Duration(milliseconds: 700),
            curve: Curves.elasticOut, 
            bottom: isCorrect ? 90 : 0, 
            child: AnimatedOpacity(
              duration: const Duration(milliseconds: 300),
              opacity: isCorrect ? 1.0 : 0.0,
              child: SizedBox(
                height: 100,
                width: 80,
                child: Image.asset("assets/images/penguin_3d.jpg", fit: BoxFit.contain),
              ),
            ),
          ),
          // الصندوق الملون (الحرف)
          Container(
            width: 95,
            height: 95,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: pinoOrange,
              borderRadius: BorderRadius.circular(20),
              boxShadow: const [
                BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, 5))
              ],
              border: Border.all(
                color: _selectedLetter == letter 
                    ? (letter == _targetLetter ? Colors.green : Colors.red) 
                    : Colors.white,
                width: 4,
              ),
            ),
            child: Text(
              letter,
              style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold, color: Colors.white, fontFamily: 'Vazirmatn'),
            ),
          ),
        ],
      ),
    );
  }
}