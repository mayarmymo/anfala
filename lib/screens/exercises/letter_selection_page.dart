import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:shared_preferences/shared_preferences.dart';

const Color pinoNavy = Color(0xFF1E2A47);

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
  double _progress = 0.0;
  int _userHearts = 0;

  @override
  void initState() {
    super.initState();
    _loadProgress();
    _generateNewLevel();
    // تشغيل الصوت تلقائياً عند فتح الصفحة
    _playPinoSound();
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

  void _generateNewLevel() {
    setState(() {
      _showPino = false;
      _selectedLetter = null;
      // قائمة حروف عشوائية ليختار منها التطبيق مع حرف السين
      List<String> others = [
        'أ',
        'ب',
        'ت',
        'ث',
        'ج',
        'ح',
        'خ',
        'د',
        'ر',
        'ز',
        'ش'
      ];
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

      // إظهار نافذة النجاح بعد ثانيتين من ظهور البطريق
      Future.delayed(const Duration(seconds: 2), () => _showSuccessDialog());
    }
  }

  Future<void> _showSuccessDialog() async {
    // حفظ الإنجاز وزيادة القلوب فعلياً
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('ex_pino', true);
    int hearts = prefs.getInt('user_hearts') ?? 60;
    await prefs.setInt('user_hearts', hearts + 10);
    _loadProgress(); // تحديث شريط التقدم

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text("وجدته", // The text itself
            textAlign: TextAlign.center,
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontFamily: 'Vazirmatn',
                color: pinoNavy)), // Ensures the color is pinoNavy
        content: const Text("أنت بطل رائع، لقد عثرت على بينو خلف حرف السين!",
            textAlign: TextAlign.center,
            style: TextStyle(fontFamily: 'Vazirmatn', color: pinoNavy)),
        actions: [
          Center(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: pinoNavy,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10))),
              onPressed: () {
                Navigator.pop(context);
                _generateNewLevel();
              },
              child: const Text("لعبة جديدة",
                  style:
                      TextStyle(color: Colors.white, fontFamily: 'Vazirmatn')),
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
    double screenWidth = MediaQuery.of(context).size.width;
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: const Color(0xFFF0F4F8),
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: const Text("أين يختبئ بينو؟",
              style: TextStyle(
                  color: pinoNavy,
                  fontFamily: 'Vazirmatn',
                  fontWeight: FontWeight.bold)),
          automaticallyImplyLeading: false,
          leading: Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconButton(
              icon: const Icon(Icons.close, color: pinoNavy, size: 28),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          centerTitle: true,
          elevation: 0,
        ),
        body: Column(
          children: [
            // شريط التقدم العلوي
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
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
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: screenWidth * 0.2),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: _boxLetters
                        .map((letter) => _buildAnimatedBox(letter))
                        .toList(),
                  ),
                  const SizedBox(height: 60),
                  _buildAudioButton(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAudioButton() {
    return Column(
      children: [
        IconButton(
          onPressed: _playPinoSound,
          icon: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                  color: pinoNavy.withOpacity(0.1), shape: BoxShape.circle),
              child: Icon(Icons.volume_up, color: pinoNavy, size: 45)),
        ),
        const Text("إعادة سماع الصوت",
            style: TextStyle(
                color: Color(0xFF1E2A47),
                fontSize: 12,
                fontFamily: 'Vazirmatn')),
      ],
    );
  }

  Widget _buildAnimatedBox(String letter) {
    bool isCorrect = (letter == _targetLetter && _showPino);
    double screenWidth = MediaQuery.of(context).size.width;
    double boxSize = (screenWidth - 60) / 3;

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
            bottom: isCorrect ? boxSize * 0.9 : 0,
            child: AnimatedOpacity(
              duration: const Duration(milliseconds: 300),
              opacity: isCorrect ? 1.0 : 0.0,
              child: SizedBox(
                height: boxSize,
                width: boxSize * 0.8,
                child:
                    Image.asset("assets/images/peno.jpg", fit: BoxFit.contain),
              ),
            ),
          ),
          // الصندوق الملون (الحرف)
          Container(
            width: boxSize,
            height: boxSize,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: pinoNavy,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                    color: pinoNavy.withAlpha(150), offset: const Offset(0, 5))
              ],
              border: Border.all(
                color: _selectedLetter == letter
                    ? (letter == _targetLetter
                        ? const Color(0xFF58CC02)
                        : Colors.red)
                    : Colors.white,
                width: 4,
              ),
            ),
            child: Text(
              letter,
              style: TextStyle(
                  // Removed const
                  fontSize: boxSize * 0.5,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontFamily: 'Vazirmatn'),
            ),
          ),
        ],
      ),
    );
  }
}
