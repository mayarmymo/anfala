import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
// ملاحظة: تأكد من أن هذا المسار يؤدي فعلياً لمكان ملف الصفحة السابقة
import '../pronunciation/drag_drop_page.dart';

// تم تعريفها هنا
const Color pinoNavy = Color(0xFF1E2A47);

class LevelsPage extends StatefulWidget {
  const LevelsPage({super.key});

  @override
  State<LevelsPage> createState() => _LevelsPageState();
}

class _LevelsPageState extends State<LevelsPage> {
  bool _isLevel2Unlocked = false;
  bool _isLevel3Unlocked = false;

  final List<Map<String, dynamic>> _levelData = [
    {
      'level': 1,
      'title': "المرحلة الأولى: القمر",
      'desc': "رتب حروف كلمة قمر",
      'icon': Icons.nightlight_round,
      'color': Colors.purple,
      'wordTitle': 'قمر',
      'targetLetters': ['ق', 'م', 'ر'],
      'imagePath': 'assets/images/moon.jpg',
      'nextLevelKey': 'level_2_unlocked',
    },
    {
      'level': 2,
      'title': "المرحلة الثانية: الأسد",
      'desc': "رتب حروف كلمة أسد",
      'icon': Icons.pets,
      'color': pinoNavy,
      'wordTitle': 'أسد',
      'targetLetters': ['أ', 'س', 'د'],
      'imagePath': 'assets/images/lion.jpg',
      'nextLevelKey': 'level_3_unlocked',
    },
    {
      'level': 3,
      'title': "المرحلة الثالثة: الجمل",
      'desc': "رتب حروف كلمة جمل",
      'icon': Icons.terrain,
      'color': Colors.brown,
      'wordTitle': 'جمل',
      'targetLetters': ['ج', 'م', 'ل'],
      'imagePath': 'assets/images/camel.jpg',
      'nextLevelKey': null,
    },
  ];

  @override
  void initState() {
    super.initState();
    _loadLevelStatus();
  }

  Future<void> _loadLevelStatus() async {
    final prefs = await SharedPreferences.getInstance();
    if (mounted) {
      setState(() {
        _isLevel2Unlocked = prefs.getBool('level_2_unlocked') ?? false;
        _isLevel3Unlocked = prefs.getBool('level_3_unlocked') ?? false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("ترتيب الكلمات",
              style: TextStyle(color: pinoNavy, fontWeight: FontWeight.bold)),
          backgroundColor: Colors.white,
          centerTitle: true,
          automaticallyImplyLeading: false,
          leading: Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconButton(
              icon: const Icon(Icons.close, color: pinoNavy, size: 28),
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ),
        body: ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          itemCount: _levelData.length,
          itemBuilder: (context, index) {
            final level = _levelData[index];
            bool isLocked = (level['level'] == 2 && !_isLevel2Unlocked) ||
                (level['level'] == 3 && !_isLevel3Unlocked);

            return Card(
              margin: const EdgeInsets.only(bottom: 15),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              child: ListTile(
                onTap: isLocked
                    ? () => ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("🔒 هذه المرحلة مغلقة!")))
                    : () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DragDropPage(
                              wordTitle: level['wordTitle'],
                              targetLetters: level['targetLetters'],
                              imagePath: level['imagePath'],
                              nextLevelKey: level['nextLevelKey'],
                            ),
                          ),
                        ).then((_) => _loadLevelStatus()),
                title: Text(level['title'],
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: isLocked ? Colors.grey : Colors.black)),
                subtitle: Text(level['desc'],
                    style: const TextStyle(color: pinoNavy)),
                trailing: Icon(isLocked ? Icons.lock : Icons.arrow_forward_ios,
                    size: 16),
              ),
            );
          },
        ),
      ),
    );
  }
}
