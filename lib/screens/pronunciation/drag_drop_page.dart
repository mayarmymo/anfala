import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DragDropPage extends StatefulWidget {
  final String wordTitle;
  final List<String> targetLetters;
  final String? nextLevelKey;

  const DragDropPage({
    super.key,
    required this.wordTitle,
    required this.targetLetters,
    this.nextLevelKey,
  });

  @override
  State<DragDropPage> createState() => _DragDropPageState();
}

class _DragDropPageState extends State<DragDropPage> {
  late List<String> shuffledLetters;
  late List<String?> droppedLetters;
  final Color pinoNavy = const Color(0xFF1E2A47);
  final Color pinoOrange = const Color(0xFFFF9F1C);

  @override
  void initState() {
    super.initState();
    shuffledLetters = List.from(widget.targetLetters)..shuffle();
    droppedLetters = List.filled(widget.targetLetters.length, null);
  }

  // إصلاح الخطأ: إضافة async هنا لاستخدام await
  Future<void> _checkResult() async {
    if (droppedLetters.contains(null)) return;

    bool isCorrect = true;
    for (int i = 0; i < widget.targetLetters.length; i++) {
      if (droppedLetters[i] != widget.targetLetters[i]) {
        isCorrect = false;
        break;
      }
    }

    if (isCorrect) {
      if (widget.nextLevelKey != null) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool(widget.nextLevelKey!, true);
      }
      _showFeedback(true);
    } else {
      _showFeedback(false);
    }
  }

  void _showFeedback(bool success) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(success ? "أحسنت! ترتيب صحيح 🎉" : "حاول مرة أخرى ❌"),
        backgroundColor: pinoOrange,
        duration: const Duration(seconds: 2),
      ),
    );
    if (success) {
      Future.delayed(const Duration(seconds: 1), () => Navigator.pop(context));
    } else {
      setState(() {
        droppedLetters = List.filled(widget.targetLetters.length, null);
        shuffledLetters = List.from(widget.targetLetters)..shuffle();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("رتب كلمة: ${widget.wordTitle}"),
        backgroundColor: pinoNavy,
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // منطقة الإفلات (Slots)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(widget.targetLetters.length, (index) {
              return DragTarget<String>(
                builder: (context, candidateData, rejectedData) {
                  return Container(
                    width: 60, height: 60,
                    margin: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: pinoNavy.withOpacity(0.2)),
                    ),
                    child: Center(
                      child: Text(droppedLetters[index] ?? "", 
                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: pinoNavy)),
                    ),
                  );
                },
                onAccept: (data) {
                  setState(() {
                    droppedLetters[index] = data;
                    shuffledLetters.remove(data);
                  });
                  _checkResult();
                },
              );
            }),
          ),
          const SizedBox(height: 50),
          // منطقة السحب (Letters)
          Wrap(
            children: shuffledLetters.map((letter) {
              return Draggable<String>(
                data: letter,
                feedback: Material(child: _buildLetterBox(letter)),
                childWhenDragging: Opacity(opacity: 0.3, child: _buildLetterBox(letter)),
                child: _buildLetterBox(letter),
              );
            }).toList(),
          ),
        ],
      ),
    ),
    );
  }

  Widget _buildLetterBox(String letter) {
    return Container(
      width: 60, height: 60,
      margin: const EdgeInsets.all(8),
      decoration: BoxDecoration(color: pinoNavy, borderRadius: BorderRadius.circular(10)),
      child: Center(child: Text(letter, style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold))),
    );
  }
}