import 'package:flutter/material.dart';
import '../pronunciation/speech_practice_page.dart';                    
import '../motivation/penguin_chef_page.dart';
import 'leaderboard_page.dart';
// import 'letter_selection_page.dart';

class ExercisesHubPage extends StatelessWidget {
  const ExercisesHubPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            "التمارين التعليمية",
            style: TextStyle(
              color: Colors.white, 
              fontWeight: FontWeight.bold,
              fontFamily: 'Vazirmatn',
            ),
          ),
          backgroundColor: const Color(0xFF1E2A47),
          centerTitle: true,
          automaticallyImplyLeading: false, // إلغاء الزر الافتراضي على اليمين
          actions: [ // إضافة زر الخروج في اليسار
            IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        ),
        body: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            // بطاقة ترحيبية كبيرة
            Container(
              margin: const EdgeInsets.only(bottom: 20),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(colors: [Color(0xFF1E2A47), Color(0xFF4361EE)]),
                borderRadius: BorderRadius.circular(25),
                boxShadow: [BoxShadow(color: const Color(0xFF4361EE).withOpacity(0.4), blurRadius: 10, offset: const Offset(0, 5))],
              ),
              child: const Row(
                children: [
                  Expanded(child: Text("هل أنت مستعد للمغامرة يا بطل؟ \nاختر لعبة لتبدأ!", style: TextStyle(color: Colors.white, fontFamily: 'Vazirmatn', fontSize: 18, height: 1.5))),
                  Icon(Icons.videogame_asset, color: Colors.white70, size: 50),
                ],
              ),
            ),
            _buildExerciseCard(
              context,
              title: "تمرين نطق الكلمات",
              subtitle: "تحدث مع بينو",
              icon: Icons.mic,
              gradientColors: [const Color(0xFFFF9A9E), const Color(0xFFFECFEF)], // تدرج وردي
              iconColor: const Color(0xFFD63384),
              page: const SpeechPracticePage(),
            ),
            _buildExerciseCard(
              context,
              title: "تعلم الحركات",
              subtitle: "الفتحة والضمة والكسرة",
              icon: Icons.text_fields,
              gradientColors: [const Color(0xFFA18CD1), const Color(0xFFFBC2EB)], // تدرج بنفسجي
              iconColor: const Color(0xFF6F42C1),
              page: const MovementsPage(),
            ),
            _buildExerciseCard(
              context,
              title: "تمارين متقدمة",
              subtitle: "رتب القصة المبعثرة",
              icon: Icons.school,
              gradientColors: [const Color(0xFF84FAB0), const Color(0xFF8FD3F4)], // تدرج سماوي مخضر
              iconColor: const Color(0xFF0D6EFD),
              page: const AdvancedExercisesPage(),
            ),
            _buildExerciseCard(
              context,
              title: "لعبة الشيف بينو",
              subtitle: "اطبخ حساء الحروف",
              icon: Icons.soup_kitchen,
              gradientColors: [const Color(0xFFFF9F1C), const Color(0xFFFFC371)], // تدرج برتقالي
              iconColor: const Color(0xFFFD7E14),
              page: const PenguinChefPage(),
            ),
             _buildExerciseCard(
              context,
              title: "لوحة المتصدرين",
              subtitle: "انظر من هم الأبطال",
              icon: Icons.leaderboard,
              gradientColors: [const Color(0xFF43E97B), const Color(0xFF38F9D7)], // تدرج أخضر
              iconColor: const Color(0xFF198754),
              page: const LeaderboardPage(),
            ),
            // _buildExerciseCard(
            //   context,
            //   title: "أين يختبئ بينو؟",
            //   icon: Icons.help_outline,
            //   color: Colors.pinkAccent,
            //   page: const LetterSelectionPage(),
            // ),
          ],
        ),
      ),
    );
  }

  Widget _buildExerciseCard(BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required List<Color> gradientColors,
    required Color iconColor,
    required Widget page
  }) {
    return GestureDetector(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => page)),
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        height: 100, // ارتفاع ثابت للبطاقة
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(color: Colors.grey.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, 4)),
          ],
        ),
        child: Row(
          children: [
            // الجزء الملون الجانبي (أيقونة)
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: gradientColors, begin: Alignment.topLeft, end: Alignment.bottomRight),
                borderRadius: const BorderRadius.only(topRight: Radius.circular(20), bottomRight: Radius.circular(20)),
              ),
              child: Icon(icon, color: Colors.white, size: 40),
            ),
            const SizedBox(width: 15),
            // النصوص
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, fontFamily: 'Vazirmatn', color: Color(0xFF1E2A47))),
                  const SizedBox(height: 5),
                  Text(subtitle, style: TextStyle(fontSize: 14, fontFamily: 'Vazirmatn', color: Colors.grey.shade600)),
                ],
              ),
            ),
            // أيقونة السهم
            Padding(
              padding: const EdgeInsets.only(left: 20),
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(color: Colors.grey.shade100, shape: BoxShape.circle),
                child: const Icon(Icons.arrow_forward_ios_rounded, size: 16, color: Colors.grey),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// --- صفحة تعلم الحركات ---
class MovementsPage extends StatefulWidget {
  const MovementsPage({super.key});

  @override
  State<MovementsPage> createState() => _MovementsPageState();
}

class _MovementsPageState extends State<MovementsPage> {
  bool fatheDone = false;
  bool dammaDone = false;
  bool kasraDone = false;

  @override
  Widget build(BuildContext context) {
    int score = (fatheDone ? 1 : 0) + (dammaDone ? 1 : 0) + (kasraDone ? 1 : 0);

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          actions: [ // زر الخروج في اليسار
            IconButton(
              icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
          title: const Text("مهمة الحركات الثلاث", style: TextStyle(color: Colors.white, fontFamily: 'Vazirmatn')),
          backgroundColor: const Color(0xFF1E2A47),
        ),
        body: Column(
          children: [
            const SizedBox(height: 20),
            Text("أنجز الحركات لجمع النجوم! ($score/3)", 
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.blueGrey, fontFamily: 'Vazirmatn')),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.star_rounded, color: fatheDone ? const Color(0xFFFF9F1C) : Colors.grey.shade300, size: 50),
                Icon(Icons.star_rounded, color: dammaDone ? const Color(0xFFFF9F1C) : Colors.grey.shade300, size: 50),
                Icon(Icons.star_rounded, color: kasraDone ? const Color(0xFFFF9F1C) : Colors.grey.shade300, size: 50),
              ],
            ),
            const Divider(height: 40),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                children: [
                  _buildMovementTask(
                    symbol: "َ", 
                    title: "الفتحة", 
                    desc: "نفتح الفم عند النطق بها", 
                    isDone: fatheDone,
                    onTap: () => setState(() => fatheDone = true),
                  ),
                  _buildMovementTask(
                    symbol: "ُ", 
                    title: "الضمة", 
                    desc: "نضم الشفتين عند النطق بها", 
                    isDone: dammaDone,
                    onTap: () => setState(() => dammaDone = true),
                  ),
                  _buildMovementTask(
                    symbol: "ِ", 
                    title: "الكسرة", 
                    desc: "نبتسم قليلاً عند النطق بها", 
                    isDone: kasraDone,
                    onTap: () => setState(() => kasraDone = true),
                  ),
                ],
              ),
            ),
            if (score == 3) 
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Container(
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(color: Colors.green.withOpacity(0.2), borderRadius: BorderRadius.circular(15)),
                  child: const Row(
                    children: [
                      Icon(Icons.emoji_events, color: Colors.green, size: 40),
                      SizedBox(width: 15),
                      Text("رائع! لقد أصبحت بطل الحركات!", 
                        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green, fontFamily: 'Vazirmatn')),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildMovementTask({required String symbol, required String title, required String desc, required bool isDone, required VoidCallback onTap}) {
    return Card(
      color: isDone ? Colors.green.shade50 : Colors.white,
      margin: const EdgeInsets.only(bottom: 15),
      child: ListTile(
        onTap: onTap,
        leading: Text(symbol, style: const TextStyle(fontSize: 45, fontWeight: FontWeight.bold, color: Colors.blue)),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Vazirmatn')),
        subtitle: Text(desc, style: const TextStyle(fontFamily: 'Vazirmatn')),
        trailing: Icon(isDone ? Icons.check_circle : Icons.radio_button_unchecked, color: isDone ? Colors.green : Colors.grey),
      ),
    );
  }
}

// --- صفحة التمارين المتقدمة (ترتيب القصة) ---
class AdvancedExercisesPage extends StatefulWidget {
  const AdvancedExercisesPage({super.key});

  @override
  State<AdvancedExercisesPage> createState() => _AdvancedExercisesPageState();
}

class _AdvancedExercisesPageState extends State<AdvancedExercisesPage> {
  final List<String> _storySentences = [
    "ثم طار العصفور عالياً في السماء.",
    "وجد العصفور حبة قمح لذيذة.",
    "كان هناك عصفور صغير جائع.",
    "أكل العصفور الحبة وشعر بالسعادة.",
  ];

  final List<String> _correctOrder = [
    "كان هناك عصفور صغير جائع.",
    "وجد العصفور حبة قمح لذيذة.",
    "أكل العصفور الحبة وشعر بالسعادة.",
    "ثم طار العصفور عالياً في السماء.",
  ];

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          actions: [ // زر الخروج في اليسار
            IconButton(
              icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
          title: const Text("ترتيب القصة المبعثرة", style: TextStyle(color: Colors.white, fontFamily: 'Vazirmatn')),
          backgroundColor: const Color(0xFF1E2A47),
        ),
        body: Column(
          children: [
            const Padding(
              padding: EdgeInsets.all(25.0),
              child: Text("رتب أحداث القصة بسحب الجمل:", 
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, fontFamily: 'Vazirmatn')),
            ),
            Expanded(
              child: ReorderableListView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                onReorder: (oldIndex, newIndex) {
                  setState(() {
                    if (newIndex > oldIndex) newIndex -= 1;
                    final item = _storySentences.removeAt(oldIndex);
                    _storySentences.insert(newIndex, item);
                  });
                },
                children: [
                  for (int index = 0; index < _storySentences.length; index++)
                    Card(
                      key: ValueKey(_storySentences[index]),
                      margin: const EdgeInsets.symmetric(vertical: 5),
                      child: ListTile(
                        leading: const Icon(Icons.drag_indicator, color: Colors.purple),
                        title: Text(_storySentences[index], style: const TextStyle(fontFamily: 'Vazirmatn')),
                      ),
                    ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 30, top: 10),
              child: ElevatedButton(
                onPressed: () {
                  bool isCorrect = true;
                  for (int i = 0; i < _correctOrder.length; i++) {
                    if (_storySentences[i] != _correctOrder[i]) {
                      isCorrect = false;
                      break;
                    }
                  }

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        isCorrect ? "أحسنت! الترتيب صحيح 🎉" : "حاول مرة أخرى، الترتيب غير صحيح ⛔",
                        style: const TextStyle(fontFamily: 'Vazirmatn'),
                      ),
                      backgroundColor: isCorrect ? Colors.green : Colors.red,
                      duration: const Duration(seconds: 2),
                    ),
                  );
                }, 
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purple,
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15)
                ),
                child: const Text("تحقق من الحل", 
                  style: TextStyle(color: Colors.white, fontSize: 16, fontFamily: 'Vazirmatn')),
              ),
            )
          ],
        ),
      ),
    );
  }
}