import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'movements_page.dart';
import 'advanced_exercises_page.dart';
import '../motivation/penguin_chef_page.dart';
import 'letter_selection_page.dart';
import '../pronunciation/speech_practice_page.dart'; // تم نقل الاستيراد
import '../motivation/levels_page.dart';

const Color pinoNavy = Color(0xFF1E2A47);
const Color pinoOrange = Color(0xFFFF9F1C);
const Color pinoBg = Colors.white;

class ExercisesHubPage extends StatefulWidget {
  const ExercisesHubPage({super.key});

  @override
  State<ExercisesHubPage> createState() => _ExercisesHubPageState();
}

class _ExercisesHubPageState extends State<ExercisesHubPage> {
  double _progress = 0.0;
  int _completedCount = 0;
  final int _totalExercises = 6;

  @override
  void initState() {
    super.initState();
    _loadProgress();
  }

  // تحميل حالة التقدم وحساب عدد التمارين المكتملة
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
      _completedCount = count;
      _progress = count / _totalExercises;
    });

    // إذا اكتمل الشريط، نرسل قلوب للمتجر
    if (count == _totalExercises &&
        !(prefs.getBool('hearts_awarded') ?? false)) {
      int currentHearts = prefs.getInt('user_hearts') ?? 60;
      await prefs.setInt('user_hearts', currentHearts + 50);
      await prefs.setBool('hearts_awarded',
          true); // لضمان عدم إرسال القلوب أكثر من مرة لنفس الدورة

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("تهانينا! اكتمل شريط التقدم وتم إرسال 50 ❤️ للمتجر!"),
            backgroundColor: pinoNavy,
          ),
        );
      }
    }
  }

  // دالة لمحاكاة إكمال التمرين عند العودة من الصفحة
  void _handleExerciseReturn(String key) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(key, true);
    _loadProgress();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: pinoBg,
        appBar: AppBar(
          title: const Text(
            "التمارين التعليمية",
            style: TextStyle(
                color: pinoNavy,
                fontWeight: FontWeight.bold,
                fontFamily: 'Vazirmatn'),
          ),
          backgroundColor: Colors.white,
          centerTitle: true,
          elevation: 0,
          leading: _buildUnifiedBackButton(context),
        ),
        body: Column(
          children: [
            // شريط التقدم العلوي (أسلوب دولينجو)
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("تقدمك اليومي",
                          style: TextStyle(
                              color: pinoNavy, fontWeight: FontWeight.bold)),
                      Text("${(_progress * 100).toInt()}%",
                          style: const TextStyle(color: pinoNavy)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: LinearProgressIndicator(
                      value: _progress,
                      minHeight: 12,
                      backgroundColor: pinoNavy.withOpacity(0.1),
                      valueColor: const AlwaysStoppedAnimation<Color>(pinoNavy),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                children: [
                  _buildExerciseCard(context, "ex_speech",
                      title: "تمرين نطق الكلمات",
                      icon: Icons.mic,
                      page: const SpeechPracticePage(targetWord: "تفاحة")),
                  _buildExerciseCard(context, "ex_movements",
                      title: "تعلم الحركات",
                      icon: Icons.accessibility_new,
                      page: const MovementsPage()),
                  _buildExerciseCard(context, "ex_advanced",
                      title: "ترتيب جملة وقصة",
                      icon: Icons.format_list_numbered_rtl,
                      page: const AdvancedExercisesPage()),
                  _buildExerciseCard(context, "ex_chef",
                      title: "لعبة الشيف بينو",
                      icon: Icons.restaurant_menu,
                      page: const PinoChefPage()),
                  _buildExerciseCard(context, "ex_pino",
                      title: "أين يختبئ بينو؟",
                      icon: Icons.search,
                      page: const LetterSelectionPage()),
                  _buildExerciseCard(context, "ex_levels",
                      title: "ترتيب الكلمات",
                      icon: Icons.sort_by_alpha,
                      page: const LevelsPage()),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExerciseCard(BuildContext context, String key,
      {required String title, required Widget page, required IconData icon}) {
    return Card(
      margin: const EdgeInsets.only(bottom: 15),
      elevation: 0,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
          side: BorderSide(color: Colors.grey.shade300, width: 2)),
      child: ListTile(
        leading: Icon(icon, color: pinoNavy, size: 28),
        contentPadding: const EdgeInsets.all(15),
        title: Text(title,
            style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                fontFamily: 'Vazirmatn',
                color: pinoNavy)),
        // في RTL، السهم لليسار يعني "ادخل لهذه الصفحة"
        trailing: const Icon(Icons.chevron_left_rounded,
            size: 24, color: Colors.grey),
        onTap: () => Navigator.push(
                context, MaterialPageRoute(builder: (context) => page))
            .then((_) => _handleExerciseReturn(key)),
      ),
    );
  }

  Widget _buildUnifiedBackButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: IconButton(
        icon: const Icon(Icons.close, color: pinoNavy, size: 28),
        onPressed: () => Navigator.pop(context),
      ),
    );
  }
}
