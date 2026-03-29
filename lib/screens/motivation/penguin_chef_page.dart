import 'package:flutter/material.dart';

class PinoChefPage extends StatefulWidget {
  const PinoChefPage({super.key});

  @override
  State<PinoChefPage> createState() => _PinoChefPageState();
}

class _PinoChefPageState extends State<PinoChefPage> with SingleTickerProviderStateMixin {
  // الألوان المستوحاة من الهوية التي أرفقتها
  final Color pinoNavy = const Color(0xFF1E2A47); // الكحلي الأساسي
  final Color pinoOrange = const Color(0xFFFF9F1C);   // البرتقالي
  final Color pinoBg = Colors.white;       // خلفية بيضاء

  List<String> potIngredients = [];
  final String targetWord = "مكرونة"; // الكلمة المستهدفة
  late AnimationController _steamController;

  @override
  void initState() {
    super.initState();
    _steamController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
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

  void _showSuccessResult() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // ظهور صورة بينو عند النجاح
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.asset(
                'assets/images/chef.jpg',
                height: 120,
                errorBuilder: (c, e, s) => const Icon(Icons.face_retouching_natural, size: 80, color: Colors.orange),
              ),
            ),
            const SizedBox(height: 15),
            Text("أحسنت! شيف متميز", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: pinoOrange, fontFamily: 'Vazirmatn')),
            const SizedBox(height: 10),
            const Text("😋 يم يم! طبخة (مكرونة) شهية جداً", textAlign: TextAlign.center, style: TextStyle(fontFamily: 'Vazirmatn')),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: pinoOrange,
                shape: const StadiumBorder(),
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
              ),
              onPressed: () {
                setState(() => potIngredients.clear());
                Navigator.pop(context);
              },
              child: const Text("وصفة جديدة", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontFamily: 'Vazirmatn')),
            )
          ],
        ),
      ),
    );
  }

  void _showErrorResult() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text("حاول مرة أخرى، احترقت المكرونة! 🔥", textAlign: TextAlign.center, style: TextStyle(fontFamily: 'Vazirmatn')),
        backgroundColor: pinoOrange,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(20),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
    setState(() => potIngredients.clear());
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl, // لضبط الواجهة للعربية
      child: Scaffold(
        backgroundColor: pinoBg,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          automaticallyImplyLeading: false, // لنتحكم بمكان الزر يدوياً
          actions: [
            Padding(
              padding: const EdgeInsets.only(left: 20, top: 10),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 5, offset: const Offset(0, 2))],
                ),
                child: IconButton(
                  icon: Icon(Icons.arrow_forward_ios_rounded, color: pinoOrange, size: 20),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
            ),
          ],
        ),
        body: Column(
          children: [
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
        children: [
          Text(
            "تحدي الطبخ 👨‍Chef",
            style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: pinoNavy, fontFamily: 'Vazirmatn'),
          ),
          const SizedBox(height: 8),
          Text(
            "رتب الحروف لتصنع طبق (مكرونة)",
            style: TextStyle(fontSize: 16, color: Colors.grey[600], fontFamily: 'Vazirmatn'),
          ),
        ],
      ),
    );
  }

  Widget _buildCookingArea() {
    return Stack(
      alignment: Alignment.bottomCenter,
      clipBehavior: Clip.none,
      children: [
        // تأثير البخار
        Positioned(top: -50, child: _buildSteamEffect()),
        
        // القدر
        Container(
          width: 240,
          height: 160,
          decoration: BoxDecoration(
            color: pinoNavy,
            borderRadius: const BorderRadius.vertical(bottom: Radius.circular(100), top: Radius.circular(20)),
            boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 15, offset: const Offset(0, 8))],
          ),
          child: ClipRRect(
            borderRadius: const BorderRadius.vertical(bottom: Radius.circular(100)),
            child: Stack(
              children: [
                // مستوى "الطبخ" البرتقالي يرتفع مع كل حرف
                AnimatedContainer(
                  duration: const Duration(milliseconds: 500),
                  height: (160 / targetWord.length) * potIngredients.length,
                  width: double.infinity,
                  decoration: BoxDecoration(color: pinoOrange.withOpacity(0.5)),
                ),
                Center(
                  child: Wrap(
                    spacing: 8,
                    alignment: WrapAlignment.center,
                    children: potIngredients.map((letter) => _buildFloatingLetter(letter)).toList(),
                  ),
                ),
              ],
            ),
          ),
        ),
        // مقابض القدر
        Positioned(left: -20, top: 40, child: _buildHandle()),
        Positioned(right: -20, top: 40, child: _buildHandle()),
      ],
    );
  }

  Widget _buildHandle() => Container(width: 35, height: 15, decoration: BoxDecoration(color: pinoNavy, borderRadius: BorderRadius.circular(5)));

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
          const Text("اختر الحروف بالترتيب الصحيح:", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, fontFamily: 'Vazirmatn')),
          const SizedBox(height: 25),
          Wrap(
            spacing: 15,
            runSpacing: 15,
            alignment: WrapAlignment.center,
            children: shuffledLetters.map((l) => _buildLetterButton(l)).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildLetterButton(String letter) {
    return InkWell(
      onTap: () => _addToPot(letter),
      child: Container(
        width: 65, height: 65,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          border: Border.all(color: pinoNavy.withOpacity(0.1), width: 2),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 5, offset: const Offset(0, 3))],
        ),
        child: Text(letter, style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: pinoNavy, fontFamily: 'Vazirmatn')),
      ),
    );
  }

  Widget _buildFloatingLetter(String char) {
    return Container(
      width: 38, height: 38,
      alignment: Alignment.center,
      decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
      child: Text(char, style: TextStyle(fontWeight: FontWeight.bold, color: pinoNavy, fontSize: 20, fontFamily: 'Vazirmatn')),
    );
  }

  Widget _buildSteamEffect() {
    return AnimatedBuilder(
      animation: _steamController,
      builder: (context, child) {
        return Opacity(
          opacity: 1.0 - _steamController.value,
          child: Transform.translate(offset: Offset(0, -40 * _steamController.value), child: child),
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