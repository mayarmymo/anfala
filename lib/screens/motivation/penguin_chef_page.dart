import 'package:flutter/material.dart';

class PenguinChefPage extends StatefulWidget {
  const PenguinChefPage({super.key});
  @override
  State<PenguinChefPage> createState() => _PenguinChefPageState();
}

class _PenguinChefPageState extends State<PenguinChefPage> {
  List<String> potIngredients = [];
  // الترتيب الصحيح الذي يجب أن يتبعه الطفل
  final List<String> targetLetters = ['ق', 'م', 'ر'];

  // حساب الشفافية بناءً على عدد الحروف الصحيحة المضافة
  double get moonOpacity => (potIngredients.length / targetLetters.length).clamp(0.0, 1.0);

  void _addLetter(String letter) {
    setState(() {
      // التحقق: هل الحرف المضغط هو الحرف الصحيح في الترتيب؟
      // مثلاً: إذا كانت المصفوفة فارغة، يجب أن يضغط 'ق' فقط.
      if (potIngredients.length < targetLetters.length) {
        if (letter == targetLetters[potIngredients.length]) {
          potIngredients.add(letter);
          
          // إذا اكتملت الكلمة (قمر) بالترتيب الصحيح
          if (potIngredients.length == 3) {
            _showSuccess();
          }
        } else {
          // إذا ضغط حرفاً خاطئاً في الترتيب (مثل 'ر' قبل 'ق')
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("هذا ليس الحرف الصحيح، ابدأ بحرف 'ق'!"),
              duration: Duration(seconds: 1),
            ),
          );
          // اختيارياً: يمكنك إفراغ القدر للبدء من جديد
          potIngredients.clear();
        }
      }
    });
  }

  void _showSuccess() {
    // الانتقال لصفحة التقييم (نطقك صحيح) كما في صورتك
    Future.delayed(const Duration(milliseconds: 500), () {
      Navigator.pushNamed(context, '/evaluation'); 
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("ترتيب كلمة قَمَر"),
        backgroundColor: const Color(0xFF1E2A47),
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),
          const Text(
            "ضع الحروف في القدر بالترتيب الصحيح",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          Expanded(
            child: Stack(
              alignment: Alignment.center,
              children: [
                // القمر يظهر فقط مع الحروف الصحيحة
                AnimatedOpacity(
                  opacity: moonOpacity,
                  duration: const Duration(seconds: 1),
                  child: const Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text("🌕", style: TextStyle(fontSize: 120)),
                      Text("قَمَر", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.blueGrey)),
                    ],
                  ),
                ),
                Positioned(
                  bottom: 50, 
                  child: Icon(Icons.soup_kitchen, size: 150, color: Colors.brown[400])
                ),
              ],
            ),
          ),
          // عرض الحروف المضافة داخل القدر (اختياري للتوضيح)
          Text("الحروف في القدر: ${potIngredients.join(' ')}", style: const TextStyle(fontSize: 18)),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: ['ر', 'ق', 'م'].map((l) => Padding(
              padding: const EdgeInsets.all(10),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(70, 70),
                  backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  side: const BorderSide(color: Colors.orange, width: 2)
                ),
                onPressed: () => _addLetter(l),
                child: Text(l, style: const TextStyle(fontSize: 30, color: Colors.black, fontWeight: FontWeight.bold)),
              ),
            )).toList(),
          ),
          const SizedBox(height: 60),
        ],
      ),
    );
  }
}