import 'package:flutter/material.dart';
import 'movements_page.dart';
import 'advanced_exercises_page.dart';
import '../pronunciation/speech_practice_page.dart';
import '../motivation/penguin_chef_page.dart';
import 'leaderboard_page.dart';
import 'letter_selection_page.dart';

const Color pinoNavy = Color(0xFF1E2A47);
const Color pinoOrange = Color(0xFFFF9F1C);
const Color pinoBg = Colors.white;

class ExercisesHubPage extends StatelessWidget {
  const ExercisesHubPage({super.key});

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
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontFamily: 'Vazirmatn'),
          ),
          backgroundColor: pinoNavy,
          centerTitle: true,
          elevation: 0,
          leading: _buildUnifiedBackButton(context),
        ),
        body: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            _buildExerciseCard(context,
                title: "تمرين نطق الكلمات",
                icon: Icons.mic,
                color: Colors.orange,
                page: const SpeechPracticePage(targetWord: "تفاحة")),
            _buildExerciseCard(context,
                title: "تعلم الحركات",
                icon: Icons.text_fields,
                color: Colors.green,
                page: const MovementsPage()),
            _buildExerciseCard(context,
                title: "ترتيب جملة وقصة",
                icon: Icons.school,
                color: Colors.purple,
                page: const AdvancedExercisesPage()),
            _buildExerciseCard(context,
                title: "لعبة الشيف بينو",
                icon: Icons.soup_kitchen,
                color: pinoOrange,
                page: const PinoChefPage()),
            _buildExerciseCard(context,
                title: "لوحة المتصدرين",
                icon: Icons.leaderboard,
                color: Colors.blueAccent,
                page: const LeaderboardPage()),
            _buildExerciseCard(context,
                title: "أين يختبئ بينو؟",
                icon: Icons.help_outline,
                color: Colors.pinkAccent,
                page: const LetterSelectionPage()),
          ],
        ),
      ),
    );
  }

  Widget _buildExerciseCard(BuildContext context,
      {required String title,
      required IconData icon,
      required Color color,
      required Widget page}) {
    return Card(
      margin: const EdgeInsets.only(bottom: 15),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: ListTile(
        contentPadding: const EdgeInsets.all(15),
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration:
              BoxDecoration(color: color.withOpacity(0.1), shape: BoxShape.circle),
          child: Icon(icon, color: color, size: 30),
        ),
        title: Text(title,
            style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                fontFamily: 'Vazirmatn',
                color: pinoNavy)),
        // في RTL، السهم لليسار يعني "ادخل لهذه الصفحة"
        trailing: const Icon(Icons.arrow_back_ios, size: 16, color: Colors.grey),
        onTap: () => Navigator.push(
            context, MaterialPageRoute(builder: (context) => page)),
      ),
    );
  }

  Widget _buildUnifiedBackButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration:
            const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
        child: IconButton(
          // في RTL، زر الرجوع يجب أن يشير لليمين للخروج من الصفحة
          icon: const Icon(Icons.arrow_forward_ios_rounded,
              color: pinoNavy, size: 18),
          onPressed: () => Navigator.pop(context),
        ),
      ),
    );
  }
}
