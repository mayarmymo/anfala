import 'package:flutter/material.dart';

// تعريف الألوان الموحدة للتطبيق
const Color pinoNavy = Color(0xFF1E2A47);
const Color pinoOrange = Color(0xFFFF9F1C);
const Color pinoBg = Color(0xFFF7F9FC);

class MovementsPage extends StatefulWidget {
  const MovementsPage({super.key});

  @override
  State<MovementsPage> createState() => _MovementsPageState();
}

class _MovementsPageState extends State<MovementsPage> {
  int stage = 0; // 0 للتعلم، 1 للاختبار
  int currentQuestion = 0;
  int correctAnswers = 0;

  List<Map<String, dynamic>> movements = [
    {"title": "الفتحة", "desc": "نفتح الفم عند النطق بها", "done": false},
    {"title": "الضمة", "desc": "نضم الشفتين عند النطق بها", "done": false},
    {"title": "الكسرة", "desc": "نبتسم قليلاً عند النطق بها", "done": false},
  ];

  List<Map<String, dynamic>> shuffledMovements = [];

  @override
  Widget build(BuildContext context) {
    int score = movements.where((e) => e["done"] == true).length;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: pinoNavy,
          centerTitle: true,
          title: const Text("تعلم الحركات", style: TextStyle(color: Colors.white, fontFamily: 'Vazirmatn')),
        ),
        body: stage == 0 ? _buildLearningStage(score) : _buildQuizStage(),
      ),
    );
  }

  Widget _buildLearningStage(int score) {
    return Column(
      children: [
        const SizedBox(height: 20),
        Text("أنجز الحركات ($score/3)", style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: pinoNavy, fontFamily: 'Vazirmatn')),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: movements.map((e) => Icon(e["done"] ? Icons.favorite : Icons.favorite_border, color: pinoNavy, size: 40)).toList(),
        ),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: movements.map((item) => _buildMovementCard(item)).toList(),
          ),
        ),
        if (score == 3)
          Padding(
            padding: const EdgeInsets.all(20),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: pinoNavy, foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 30)),
              onPressed: () {
                setState(() {
                  shuffledMovements = List.from(movements)..shuffle();
                  stage = 1;
                });
              },
              child: const Text("ابدأ الاختبار", style: TextStyle(fontFamily: 'Vazirmatn')),
            ),
          ),
      ],
    );
  }

  Widget _buildMovementCard(Map item) {
    return Card(
      margin: const EdgeInsets.only(bottom: 15),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15), side: const BorderSide(color: pinoNavy)),
      child: ListTile(
        onTap: () => setState(() => item["done"] = true),
        leading: Image.asset(item["image"], width: 50, height: 50, errorBuilder: (c, e, s) => const Icon(Icons.image)),
        title: Text(item["title"], style: const TextStyle(fontWeight: FontWeight.bold, color: pinoNavy, fontFamily: 'Vazirmatn')),
        subtitle: Text(item["desc"], style: const TextStyle(color: pinoNavy, fontFamily: 'Vazirmatn')),
        trailing: Icon(item["done"] ? Icons.check_circle : Icons.circle_outlined, color: pinoNavy),
      ),
    );
  }

  Widget _buildQuizStage() {
    var question = shuffledMovements[currentQuestion];
    List options = List.from(movements)..shuffle();
    return Column(mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("ما هذه الحركة؟", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: pinoNavy, fontFamily: 'Vazirmatn')),
        const SizedBox(height: 20),
        Image.asset(question["image"], width: 120, errorBuilder: (c, e, s) => const Icon(Icons.help, size: 100)),
        const SizedBox(height: 30),
        ...options.map((option) => Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: pinoNavy, foregroundColor: Colors.white, minimumSize: const Size(double.infinity, 50)),
            onPressed: () => checkAnswer(option["title"]),
            child: Text(option["title"], style: const TextStyle(fontFamily: 'Vazirmatn')),
          ),
        )).toList(),
      ],
    );
  }

  void checkAnswer(String selected) {
    if (selected == shuffledMovements[currentQuestion]["title"]) correctAnswers++;
    if (currentQuestion < shuffledMovements.length - 1) {
      setState(() => currentQuestion++);
    } else {
      _showResult();
    }
  }

  void _showResult() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("النتيجة", textAlign: TextAlign.center),
        content: Text("أجبت صحيح $correctAnswers من 3", textAlign: TextAlign.center),
        actions: [
          TextButton(onPressed: () { Navigator.pop(context); setState(() { stage = 0; currentQuestion = 0; correctAnswers = 0; for (var m in movements) { m["done"] = false; } }); }, child: const Text("إعادة")),
        ],
      ),
    );
  }
}