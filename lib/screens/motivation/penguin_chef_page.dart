import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

const Color pinoNavy = Color(0xFF1E2A47); // الكحلي الأساسي
const Color pinoOrange = Color(0xFFFF9F1C); // البرتقالي
const Color pinoBg = Colors.white; // خلفية بيضاء

class PinoChefPage extends StatefulWidget {
  const PinoChefPage({super.key});

  @override
  State<PinoChefPage> createState() => _PinoChefPageState();
}

class _PinoChefPageState extends State<PinoChefPage>
    with SingleTickerProviderStateMixin {
  List<String> potIngredients = [];
  final String targetWord = "مكرونة"; // الكلمة المستهدفة
  late AnimationController _steamController;
  double _progress = 0.0;
  int _userHearts = 0;

  @override
  void initState() {
    super.initState();
    _loadProgress();
    _steamController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
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

  @override
  void dispose() {
    _steamController.dispose();
    super.dispose();
  }

  void _addToPot(String letter) {
    if (potIngredients.length < targetWord.length) {
      setState(() {
        potIngredients.add(letter);
      });

      if (potIngredients.length == targetWord.length) {
        Future.delayed(const Duration(milliseconds: 600), () {
          if (potIngredients.join() == targetWord) {
            _showSuccessResult();
          } else {
            _showErrorResult();
          }
        });
      }
    }
  }

  Future<void> _showSuccessResult() async {
    // حفظ الإنجاز وزيادة القلوب
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('ex_chef', true);
    int hearts = prefs.getInt('user_hearts') ?? 60;
    await prefs.setInt('user_hearts', hearts + 10);
    _loadProgress(); // تحديث شريط التقدم

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white, // تغيير الخلفية إلى اللون الأبيض
        surfaceTintColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // ظهور صورة بينو عند النجاح
            ClipRRect(
              borderRadius: BorderRadius.circular(25), // زيادة استدارة الحواف
              child: Image.asset(
                'assets/images/chef.jpg',
                height: 140, // تكبير الصورة قليلاً
                width: 140, // لجعلها مربعة
                fit: BoxFit.cover,
                alignment: Alignment.center,
                errorBuilder: (c, e, s) => Icon(Icons.food_bank_outlined,
                    size: 80, color: pinoNavy.withOpacity(0.5)),
              ),
            ),
            const SizedBox(height: 15),
            Text("أحسنت! شيف متميز",
                style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: pinoNavy,
                    fontFamily: 'Vazirmatn')),
            const SizedBox(height: 10),
            const Text("😋 يم يم! طبخة (مكرونة) شهية جداً",
                textAlign: TextAlign.center,
                style: TextStyle(fontFamily: 'Vazirmatn', color: pinoNavy)),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: pinoNavy,
                shape: const StadiumBorder(),
                padding:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
              ),
              onPressed: () {
                setState(() => potIngredients.clear());
                Navigator.pop(context);
              },
              child: const Text("وصفة جديدة",
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Vazirmatn')),
            )
          ],
        ),
      ),
    );
  }

  void _showErrorResult() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text("حاول مرة أخرى، احترقت المكرونة! 🔥",
            textAlign: TextAlign.center,
            style: TextStyle(fontFamily: 'Vazirmatn')),
        backgroundColor: pinoNavy,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(20),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
    setState(() => potIngredients.clear()); // مسح المكونات بعد الخطأ
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl, // لضبط الواجهة للعربية
      child: Scaffold(
        backgroundColor: pinoBg,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          automaticallyImplyLeading: false, // لنتحكم بمكان الزر يدوياً
          centerTitle: true,
          title: const Text(
            "تحدي الطبخ",
            style: TextStyle(
                color: pinoNavy,
                fontWeight: FontWeight.bold,
                fontFamily: 'Vazirmatn'),
          ),
          leading: Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconButton(
              icon: const Icon(Icons.close, color: pinoNavy, size: 28),
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ),
        body: Column(
          children: [
            // إضافة شريط التقدم العلوي
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
            _buildHeader(),
            const Spacer(),
            _buildCookingArea(),
            const Spacer(),
            _buildIngredientsShelf(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start, // محاذاة لليمين (في RTL)
        children: [
          const SizedBox(height: 20),
          Text(
            "رتب الحروف لتصنع طبق (مكرونة)",
            style: TextStyle(
                fontSize: 14, color: pinoNavy, fontFamily: 'Vazirmatn'),
          ),
        ],
      ),
    );
  }

  Widget _buildCookingArea() {
    double screenWidth = MediaQuery.of(context).size.width;
    return Stack(
      alignment: Alignment.bottomCenter,
      clipBehavior: Clip.none,
      children: [
        // تأثير البخار
        Positioned(top: -screenWidth * 0.12, child: _buildSteamEffect()),

        // القدر
        Container(
          width: screenWidth * 0.5,
          height: screenWidth * 0.35,
          decoration: BoxDecoration(
            color: pinoNavy,
            borderRadius: const BorderRadius.vertical(
                bottom: Radius.circular(80), top: Radius.circular(20)),
            boxShadow: [
              BoxShadow(
                  color: Colors.black26,
                  blurRadius: 15,
                  offset: const Offset(0, 8))
            ],
          ),
          child: ClipRRect(
            borderRadius:
                const BorderRadius.vertical(bottom: Radius.circular(80)),
            child: Stack(
              children: [
                // مستوى "الطبخ" البرتقالي يرتفع مع كل حرف
                AnimatedContainer(
                  duration: const Duration(milliseconds: 500),
                  height: (screenWidth * 0.35 / targetWord.length) *
                      potIngredients.length,
                  width: double.infinity,
                  decoration:
                      BoxDecoration(color: Colors.white.withOpacity(0.3)),
                ),
                Center(
                  child: Wrap(
                    spacing: 8,
                    alignment: WrapAlignment.center,
                    children: potIngredients
                        .map((letter) => _buildFloatingLetter(letter))
                        .toList(),
                  ),
                ),
              ],
            ),
          ),
        ),
        // مقابض القدر
        Positioned(left: -15, top: screenWidth * 0.08, child: _buildHandle()),
        Positioned(right: -15, top: screenWidth * 0.08, child: _buildHandle()),
      ],
    );
  }

  Widget _buildHandle() => Container(
      width: 30,
      height: 12,
      decoration: BoxDecoration(
          color: pinoNavy, borderRadius: BorderRadius.circular(5)));

  Widget _buildIngredientsShelf() {
    // الحروف مبعثرة للطفل
    List<String> shuffledLetters = ['ن', 'م', 'ر', 'و', 'ك', 'ة'];

    return Container(
      padding: const EdgeInsets.fromLTRB(20, 30, 20, 50),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(40)),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10)],
      ),
      child: Column(
        children: [
          const Text("اختر الحروف بالترتيب الصحيح:",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  fontFamily: 'Vazirmatn',
                  color: pinoNavy)),
          const SizedBox(height: 15),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            alignment: WrapAlignment.center,
            children:
                shuffledLetters.map((l) => _buildLetterButton(l)).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildLetterButton(String letter) {
    return InkWell(
      onTap: () => _addToPot(letter),
      child: Container(
        width: 55,
        height: 55,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          border: Border.all(color: pinoNavy.withOpacity(0.1), width: 2),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 5,
                offset: const Offset(0, 3))
          ],
        ),
        child: Text(letter,
            style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: pinoNavy,
                fontFamily: 'Vazirmatn')),
      ),
    );
  }

  Widget _buildFloatingLetter(String char) {
    return Container(
      width: 38,
      height: 38,
      alignment: Alignment.center,
      decoration:
          const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
      child: Text(char,
          style: TextStyle(
              fontWeight: FontWeight.bold,
              color: pinoNavy,
              fontSize: 20,
              fontFamily: 'Vazirmatn')),
    );
  }

  Widget _buildSteamEffect() {
    return AnimatedBuilder(
      animation: _steamController,
      builder: (context, child) {
        return Opacity(
          opacity: 1.0 - _steamController.value,
          child: Transform.translate(
              offset: Offset(0, -40 * _steamController.value), child: child),
        );
      },
      child: const Row(
        children: [
          Icon(Icons.cloud_queue_rounded, color: Colors.white, size: 25),
          SizedBox(width: 15),
          Icon(Icons.cloud_queue_rounded, color: Colors.white, size: 35),
        ],
      ),
    );
  }
}
