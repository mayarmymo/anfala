import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../pronunciation/drag_drop_page.dart';

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
      'level': 1, 'title': "المرحلة الأولى: القمر", 'desc': "رتب حروف كلمة قمر", 'icon': Icons.nightlight_round, 'color': Colors.purple,
      'wordTitle': 'قمر', 'targetLetters': ['ق', 'م', 'ر'], 'nextLevelKey': 'level_2_unlocked',
    },
    {
      'level': 2, 'title': "المرحلة الثانية: الأسد", 'desc': "رتب حروف كلمة أسد", 'icon': Icons.pets, 'color': Colors.orange,
      'wordTitle': 'أسد', 'targetLetters': ['أ', 'س', 'د'], 'nextLevelKey': 'level_3_unlocked',
    },
    {
      'level': 3, 'title': "المرحلة الثالثة: الجمل", 'desc': "رتب حروف كلمة جمل", 'icon': Icons.terrain, 'color': Colors.brown,
      'wordTitle': 'جمل', 'targetLetters': ['ج', 'م', 'ل'], 'nextLevelKey': null,
    },
  ];

  @override
  void initState() {
    super.initState();
    _loadLevelStatus();
  }

  // تحميل حالة المراحل (مفتوحة/مغلقة)
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
    return Scaffold(
      appBar: AppBar(
        title: const Text("ترتيب الكلمات", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF1E2A47),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: _levelData.length,
        itemBuilder: (context, index) {
          final level = _levelData[index];
          bool isLocked = false;
          if (level['level'] == 2) {
            isLocked = !_isLevel2Unlocked;
          } else if (level['level'] == 3) {
            isLocked = !_isLevel3Unlocked;
          }

          return _buildLevelCard(
            context,
            level['level'],
            level['title'],
            level['desc'],
            level['icon'],
            level['color'],
            isLocked,
            () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DragDropPage(
                    wordTitle: level['wordTitle'],
                    targetLetters: level['targetLetters'] as List<String>,
                    nextLevelKey: level['nextLevelKey'],
                  ),
                ),
              ).then((_) => _loadLevelStatus());
            },
          );
        },
      ),
    );
  }

  Widget _buildLevelCard(BuildContext context, int level, String title, String desc, IconData icon, Color color, bool isLocked, VoidCallback onTap) {
    return Card(
      margin: const EdgeInsets.only(bottom: 15),
      child: ListTile(
        onTap: isLocked 
            ? () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("عليك إنهاء المرحلة السابقة أولاً! 🔒")))
            : onTap,
        leading: CircleAvatar(
          backgroundColor: isLocked ? Colors.grey.shade300 : color.withOpacity(0.1),
          child: Icon(icon, color: isLocked ? Colors.grey : color),
        ),
        title: Text(title, style: TextStyle(fontWeight: FontWeight.bold, color: isLocked ? Colors.grey : Colors.black)),
        subtitle: Text(desc),
        trailing: Icon(isLocked ? Icons.lock : Icons.arrow_forward_ios, size: 16, color: isLocked ? Colors.grey : Colors.black),
      ),
    );
  }
}