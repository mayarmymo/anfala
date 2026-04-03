import 'package:flutter/material.dart';

// الحفاظ على ألوانك الأصلية
import '../pronunciation/evaluation_page.dart'; // استيراد صفحة التقييم

const Color pinoNavy = Color(0xFF1E2A47);
const Color pinoOrange = Color(0xFFFF9F1C);
const Color pinoBg = Colors.white;

class AdvancedExercisesPage extends StatefulWidget {
  const AdvancedExercisesPage({super.key});

  @override
  State<AdvancedExercisesPage> createState() => _AdvancedExercisesPageState();
}

class _AdvancedExercisesPageState extends State<AdvancedExercisesPage> {
  bool _isLevel2Locked = true;

  // المرحلة 1: الجملة الجديدة (الأرنب والجزرة)
  final List<String> _sentenceWords = [
    "الجزرةَ",
    "يأكلُ",
    "الأرنبُ",
    "الكبيرةَ",
    "القويُّ"
  ];
  final List<String> _correctSentence = [
    "الأرنبُ",
    "القويُّ",
    "يأكلُ",
    "الجزرةَ",
    "الكبيرةَ"
  ];

  // المرحلة 2: القصة الجديدة (الفيل والبالون)
  final List<String> _storyEvents = [
    "طارت البالونة بعيداً فوق الأشجار",
    "نفخ الفيل الصغير بالونة حمراء كبيرة",
    "أمسك العصفور خيط البالونة وأعادها للفيل",
    "ضحك الفيل وشكر صديقه العصفور"
  ];
  final List<String> _correctStory = [
    "نفخ الفيل الصغير بالونة حمراء كبيرة",
    "طارت البالونة بعيداً فوق الأشجار",
    "أمسك العصفور خيط البالونة وأعادها للفيل",
    "ضحك الفيل وشكر صديقه العصفور"
  ];

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: pinoBg,
        appBar: AppBar(
          title: const Text("تمارين الترتيب",
              style: TextStyle(
                  color: pinoNavy,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Vazirmatn')),
          backgroundColor: Colors.white,
          centerTitle: true,
          elevation: 0,
          automaticallyImplyLeading: false,
          leading: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(
                  color: pinoNavy.withOpacity(0.1), shape: BoxShape.circle),
              child: IconButton(
                icon: const Icon(Icons.arrow_forward_ios_rounded,
                    color: pinoNavy, size: 18),
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ),
        ),
        body: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            _buildLevelCard(
                "المرحلة 1: ترتيب جملة",
                "رتب كلمات الجملة بشكل صحيح",
                Icons.star_rounded,
                Colors.orange,
                _showLevel1Dialog),
            const SizedBox(height: 15),
            _buildLevelCard(
                "المرحلة 2: ترتيب القصة",
                _isLevel2Locked
                    ? "أكمل المرحلة الأولى للفتح"
                    : "رتب أحداث قصة الفيل والبالون",
                _isLevel2Locked ? Icons.lock : Icons.auto_stories,
                _isLevel2Locked ? Colors.grey : Colors.blue,
                _isLevel2Locked
                    ? () {
                        ScaffoldMessenger.of(context)
                            .showSnackBar(const SnackBar(
                          content:
                              Text("يجب عليك إكمال المرحلة الأولى أولاً! 🔒"),
                          backgroundColor: pinoOrange,
                        ));
                      }
                    : _showLevel2Dialog),
          ],
        ),
      ),
    );
  }

  Widget _buildLevelCard(String title, String subtitle, IconData icon,
      Color color, VoidCallback onTap) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: ListTile(
        leading: Icon(icon, color: color, size: 35),
        title: Text(title,
            style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontFamily: 'Vazirmatn',
                color: pinoNavy)),
        subtitle: Text(subtitle,
            style: const TextStyle(fontFamily: 'Vazirmatn', color: pinoNavy)),
        trailing:
            const Icon(Icons.play_arrow_rounded, color: Colors.green, size: 30),
        onTap: onTap,
      ),
    );
  }

  // نافذة ترتيب الجملة
  void _showLevel1Dialog() {
    _showReorderSheet("رتب كلمات الجملة:", _sentenceWords, _correctSentence,
        () {
      setState(() {
        _isLevel2Locked = false;
      });
    });
  }

  // نافذة ترتيب القصة
  void _showLevel2Dialog() {
    _showReorderSheet("رتب أحداث القصة:", _storyEvents, _correctStory, null);
  }

  // ويدجت موحد لعملية الترتيب (BottomSheet) للحفاظ على نظافة الكود
  void _showReorderSheet(String title, List<String> list,
      List<String> correctList, VoidCallback? onComplete) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(25))),
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) => Container(
          height: MediaQuery.of(context).size.height * 0.7,
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Text(title,
                  style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Vazirmatn',
                      color: pinoNavy)),
              const SizedBox(height: 10),
              const Text("اسحب العناصر لترتيبها",
                  style: TextStyle(color: pinoNavy, fontSize: 13)),
              Expanded(
                child: ReorderableListView(
                  onReorder: (oldIndex, newIndex) {
                    setModalState(() {
                      if (newIndex > oldIndex) newIndex -= 1;
                      final item = list.removeAt(oldIndex);
                      list.insert(newIndex, item);
                    });
                  },
                  children: [
                    for (final item in list)
                      Card(
                        key: ValueKey(item),
                        margin: const EdgeInsets.symmetric(vertical: 5),
                        child: ListTile(
                          title: Text(item,
                              textAlign: TextAlign.center,
                              style: const TextStyle(fontSize: 15)),
                          trailing:
                              const Icon(Icons.drag_handle, color: Colors.grey),
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: pinoOrange,
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12))),
                onPressed: () {
                  bool isCorrect = list.join("|") == correctList.join("|");
                  int score = isCorrect ? 100 : 0;

                  Navigator.pop(context); // إغلاق الـ BottomSheet
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EvaluationPage(score: score),
                    ),
                  ).then((_) {
                    if (isCorrect && onComplete != null)
                      onComplete(); // تنفيذ onComplete بعد العودة من صفحة التقييم
                  });
                },
                child: const Text("تحقق من الإجابة",
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold)),
              )
            ],
          ),
        ),
      ),
    );
  }
}
