import 'package:flutter/material.dart';
// تأكد من استيراد ملف صفحة النطق الصحيح من مشروعك
import 'speech_practice_page.dart'; 

class DragDropPage extends StatefulWidget {
  const DragDropPage({super.key});

  @override
  State<DragDropPage> createState() => _DragDropPageState();
}

class _DragDropPageState extends State<DragDropPage> {
  List<String> availableLetters = ['ر', 'ق', 'م'];
  Map<int, String?> droppedLetters = {0: null, 1: null, 2: null};
  final List<String> targetWord = ['ق', 'م', 'ر'];

  @override
  Widget build(BuildContext context) {
    const Color pinoNavy = Color(0xFF1E2A47);
    const Color pinoOrange = Color(0xFFFF9F1C);

    return Scaffold(
      appBar: AppBar(title: const Text("ترتيب كلمة قمر"), backgroundColor: pinoNavy),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          const Text("رتب الحروف لنطق الكلمة", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: pinoNavy)),
          
          // مربعات الهدف
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(targetWord.length, (index) => DragTarget<String>(
              onAccept: (data) {
                if (data == targetWord[index]) {
                  setState(() => droppedLetters[index] = data);
                  // إذا اكتملت الكلمة
                  if (!droppedLetters.values.contains(null)) {
                    _handleWin();
                  }
                }
              },
              builder: (context, candidate, rejected) {
                bool isCorrect = droppedLetters[index] != null;
                return Container(
                  margin: const EdgeInsets.all(8),
                  width: 80, height: 80,
                  decoration: BoxDecoration(
                    color: isCorrect ? Colors.green : Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(color: pinoOrange, width: 2),
                  ),
                  child: Center(
                    child: Text(droppedLetters[index] ?? "", 
                      style: const TextStyle(fontSize: 40, fontWeight: FontWeight.bold, color: Colors.white)),
                  ),
                );
              },
            )),
          ),

          // الحروف القابلة للسحب
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: availableLetters.map((letter) {
              return droppedLetters.values.contains(letter) 
                ? const SizedBox(width: 90)
                : Draggable<String>(
                    data: letter,
                    feedback: _letterBox(letter, pinoNavy, true),
                    child: _letterBox(letter, pinoNavy, false),
                  );
            }).toList(),
          ),
        ],
      ),
    );
  }

  void _handleWin() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text("رائع! 🎉"),
        content: const Text("لقد رتبت الكلمة بشكل صحيح، هل أنت جاهز لتجربة نطقها؟"),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
            onPressed: () {
              Navigator.pop(context); // إغلاق الرسالة
              // الانتقال لصفحة النطق
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SpeechPracticePage()),
              );
            }, 
            child: const Text("هيا بنا للنطق 🎤", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Widget _letterBox(String letter, Color color, bool dragging) {
    return Material(
      color: Colors.transparent,
      child: Container(
        width: 70, height: 70,
        margin: const EdgeInsets.all(10),
        decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(15)),
        child: Center(child: Text(letter, style: const TextStyle(color: Colors.white, fontSize: 35, decoration: TextDecoration.none))),
      ),
    );
  }
}