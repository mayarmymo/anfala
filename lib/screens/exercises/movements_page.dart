import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  double _progress = 0.0;
  int _userHearts = 0;

  @override
  void initState() {
    super.initState();
    _loadProgress();
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

  // قائمة البيانات الأساسية
  final List<Map<String, dynamic>> movements = [
    {
      "title": "الفتحة",
      "desc": "نفتح الفم عند النطق بها",
      "done": false,
      "image": "images/alef_fatha.jpg"
    },
    {
      "title": "الضمة",
      "desc": "نضم الشفتين عند النطق بها",
      "done": false,
      "image": "images/alef_damma.jpg"
    },
    {
      "title": "الكسرة",
      "desc": "نبتسم قليلاً عند النطق بها",
      "done": false,
      "image": "images/alef_kasra.jpg"
    },
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
          backgroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
          automaticallyImplyLeading: false,
          leading: Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconButton(
              icon: const Icon(Icons.close, color: pinoNavy, size: 28),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          title: Text(stage == 0 ? "تعلم الحركات" : "",
              style: const TextStyle(
                  color: pinoNavy, fontWeight: FontWeight.bold)),
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
              child:
                  stage == 0 ? _buildLearningStage(score) : _buildQuizStage(),
            ),
          ],
        ),
      ),
    );
  }

  // --- مرحلة التعلم ---
  Widget _buildLearningStage(int score) {
    return Column(
      children: [
        const SizedBox(height: 10),
        const SizedBox(height: 15),

        // عرض القلوب (التقدم)
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: movements
              .map((e) => Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    child: Icon(
                        e["done"] ? Icons.favorite : Icons.favorite_border,
                        color: Colors.red,
                        size: 45),
                  ))
              .toList(),
        ),

        const SizedBox(height: 20),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            children:
                movements.map((item) => _buildMovementCard(item)).toList(),
          ),
        ),

        if (score == 3)
          Padding(
            padding: const EdgeInsets.only(bottom: 40, left: 20, right: 20),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: pinoNavy,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 60),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15))),
              onPressed: () {
                setState(() {
                  shuffledMovements = List.from(movements)..shuffle();
                  stage = 1;
                  currentQuestion = 0;
                  correctAnswers = 0;
                });
              },
              child: const Text("ابدأ التحدي الآن! 🔥",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            ),
          ),
      ],
    );
  }

  Widget _buildMovementCard(Map item) {
    return Card(
      margin: const EdgeInsets.only(bottom: 15),
      elevation: 0,
      color: item["done"] ? pinoNavy.withOpacity(0.05) : Colors.white,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(
              color: item["done"] ? pinoNavy : Colors.grey.shade300, width: 2)),
      child: ListTile(
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        onTap: () => setState(() => item["done"] = true),
        leading: CircleAvatar(
          backgroundColor: item["done"] ? pinoNavy : Colors.grey.shade200,
          child: Icon(item["done"] ? Icons.check : Icons.book,
              color: Colors.white),
        ),
        title: Text(item["title"],
            style: const TextStyle(
                fontWeight: FontWeight.bold, fontSize: 20, color: pinoNavy)),
        subtitle: Text(item["desc"],
            style: const TextStyle(color: pinoNavy, fontSize: 16)),
        trailing: Icon(
            item["done"] ? Icons.check_circle : Icons.circle_outlined,
            color: item["done"] ? Colors.green : Colors.grey),
      ),
    );
  }

  // --- مرحلة الاختبار (تم التعديل هنا لتصغير الصور وحل مشكلة المساحة) ---
  Widget _buildQuizStage() {
    var question = shuffledMovements[currentQuestion];
    List options = List.from(movements);

    return SizedBox(
      width: double.infinity,
      child: SingleChildScrollView(
        // يسمح بالتمرير إذا كانت الشاشة صغيرة
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 5),
            const Text("ما هي الحركة الموضحة في الصورة؟",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: pinoNavy)),
            const SizedBox(height: 20),

            // إطار الصورة - تم تصغير الحجم من 180 إلى 140
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(25),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black.withOpacity(0.1), blurRadius: 8)
                  ]),
              child: Image.asset(
                question["image"],
                width: 140,
                height: 140,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) => Column(
                  children: const [
                    Icon(Icons.image_not_supported,
                        size: 60, color: Colors.red),
                    Text("الصورة غير موجودة!",
                        style: TextStyle(color: Colors.red, fontSize: 12)),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 25),

            // أزرار الخيارات - تم تقليل الارتفاع والمسافات قليلاً
            ...options
                .map((option) => Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: pinoNavy,
                            elevation: 2,
                            side: const BorderSide(color: pinoNavy, width: 2),
                            minimumSize: const Size(double.infinity, 50),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15))),
                        onPressed: () => checkAnswer(option["title"]),
                        child: Text(option["title"],
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold)),
                      ),
                    ))
                .toList(),
          ],
        ),
      ),
    );
  }

  void checkAnswer(String selected) {
    if (selected == shuffledMovements[currentQuestion]["title"]) {
      correctAnswers++;
    }

    if (currentQuestion < shuffledMovements.length - 1) {
      setState(() => currentQuestion++);
    } else {
      _showResult();
    }
  }

  Future<void> _showResult() async {
    // حفظ الإنجاز وزيادة القلوب
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('ex_movements', true);
    if (correctAnswers == 3) {
      int hearts = prefs.getInt('user_hearts') ?? 60;
      await prefs.setInt('user_hearts', hearts + 10);
    }
    _loadProgress(); // تحديث شريط التقدم

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text("انتهى الاختبار! 🎉",
            textAlign: TextAlign.center,
            style: TextStyle(color: pinoNavy, fontWeight: FontWeight.bold)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // تم استبدال أيقونة النجمة بصورة القمر
            Image.asset(
              "assets/images/happy.jpg", // تأكد من أن هذا المسار صحيح وأن الصورة موجودة في المشروع
              height: 80,
              width: 80,
            ),
            const SizedBox(height: 15),
            const Text("نتيجتك الرائعة هي:",
                style: TextStyle(fontSize: 18, color: pinoNavy)),
            Text("$correctAnswers من 3",
                style: const TextStyle(
                    fontSize: 35,
                    fontWeight: FontWeight.bold,
                    color: pinoOrange)),
          ],
        ),
        actions: [
          Center(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: pinoNavy, foregroundColor: Colors.white),
              onPressed: () {
                Navigator.pop(context);
                setState(() {
                  stage = 0;
                  currentQuestion = 0;
                  correctAnswers = 0;
                  for (var m in movements) {
                    m["done"] = false;
                  }
                });
              },
              child: const Text("العودة للتعلم"),
            ),
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}
