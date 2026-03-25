import 'package:flutter/material.dart';

class PenguinChefPage extends StatefulWidget {
  const PenguinChefPage({super.key});

  @override
  State<PenguinChefPage> createState() => _PenguinChefPageState();
}

class _PenguinChefPageState extends State<PenguinChefPage> {
  // ألوان الشيف بينو
  final Color chefOrange = const Color(0xFFFF9F1C);
  final Color chefNavy = const Color(0xFF1E2A47);
  final Color chefBg = const Color(0xFFFDEFD3); // خلفية أفتح قليلاً

  int _soupProgress = 0;
  String _message = "ساعد الشيف بينو في الطبخ!";

  void _addIngredient(String name, String emoji) {
    if (_soupProgress < 5) {
      setState(() {
        _soupProgress++;
        _message = "أضفت $name للحساء! يم يم 😋";
      });
    } else {
      setState(() {
        _message = "الحساء جاهز! أحسنت يا شيف! 🍲👨‍🍳";
      });
      // هنا يمكن إضافة صوت احتفال
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: chefBg,
        body: Stack(
          children: [
            // --- خلفية المطبخ ---
            Positioned.fill(
              child: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFFFDEFD3), Color(0xFFFFF8E1)],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
              ),
            ),
            // --- زر الرجوع ---
            Positioned(
              top: 40, left: 20,
              child: Container(
                 decoration: BoxDecoration(color: Colors.white, shape: BoxShape.circle, boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 5)]),
                 child: IconButton(
                  icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.orange, size: 20),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // --- منطقة الشيف والقدر ---
                Padding(
                  padding: const EdgeInsets.only(top: 80.0),
                  child: Column(
                    children: [
                      const Text("مطبخ الشيف بينو 👨‍🍳", style: TextStyle(fontFamily: 'Vazirmatn', fontSize: 26, fontWeight: FontWeight.bold, color: Color(0xFF1E2A47))),
                      const SizedBox(height: 10),
                      Text(
                        _message,
                        style: TextStyle(fontFamily: 'Vazirmatn', fontSize: 18, color: chefNavy.withOpacity(0.8)),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 20),
                      Stack(
                        alignment: Alignment.bottomCenter,
                        children: [
                          // --- القدر ---
                          Container(
                            width: 180, height: 120,
                            decoration: const BoxDecoration(
                              gradient: LinearGradient(colors: [Color(0xFFC0C0C0), Color(0xFF808080)]),
                              borderRadius: BorderRadius.vertical(bottom: Radius.circular(90), top: Radius.circular(20)),
                              boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 10, offset: Offset(0, 5))]
                            ),
                            alignment: Alignment.bottomCenter,
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 500),
                              width: 180,
                              height: 24.0 * _soupProgress, // يرتفع مع كل إضافة
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: _soupProgress >= 5 ? [Colors.lightGreen, Colors.green] : [Colors.orange, Colors.deepOrange],
                                ),
                                borderRadius: const BorderRadius.vertical(bottom: Radius.circular(90)),
                              ),
                            ),
                          ),
                          // --- صورة البطريق ---
                          Positioned(
                            bottom: 80,
                            child: Image.asset(
                              'assets/images/penguin_3d.jpg', height: 120, 
                              errorBuilder: (c,e,s) => const Icon(Icons.face, size: 80, color: Color(0xFF1E2A47))
                            ),
                          ),
                        ],
                      ),
                      // --- النار ---
                      const Text("🔥🔥", style: TextStyle(fontSize: 40, height: 0.8)),
                    ],
                  ),
                ),
                
                // --- أزرار المكونات ---
                Expanded(
              child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(40)),
                      boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 20, offset: const Offset(0, -5))]
                    ),
                    child: GridView(
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 15,
                        mainAxisSpacing: 15,
                      ),
                      children: [
                        _buildIngredientBtn("طماطم", "🍅"),
                        _buildIngredientBtn("جزر", "🥕"),
                        _buildIngredientBtn("بطاطس", "🥔"),
                        _buildIngredientBtn("بصل", "🧅"),
                        _buildIngredientBtn("ملح", "🧂"),
                        _buildIngredientBtn("فلفل", "🌶️"),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIngredientBtn(String name, String emoji) {
    return InkWell( // استخدام InkWell لإظهار تأثير الضغط
      borderRadius: BorderRadius.circular(25),
      onTap: () => _addIngredient(name, emoji),
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFFF0F4F8),
          borderRadius: BorderRadius.circular(25),
          border: Border.all(color: Colors.grey.shade200, width: 2),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(emoji, style: const TextStyle(fontSize: 45)), // تكبير الإيموجي
            const SizedBox(height: 5),
            Text(name, style: TextStyle(fontFamily: 'Vazirmatn', color: chefNavy, fontWeight: FontWeight.bold, fontSize: 14)),
          ],
        ),
      ),
    );
  }
}