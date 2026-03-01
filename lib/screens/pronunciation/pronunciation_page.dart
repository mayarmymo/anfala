import 'package:flutter/material.dart';
import '../../widgets/penguin_scaffold.dart';
import '../../widgets/penguin_mood.dart';
class PronunciationPage extends StatefulWidget {
  const PronunciationPage({super.key});
  @override
  State<PronunciationPage> createState() => _PronunciationPageState();
}
class _PronunciationPageState extends State<PronunciationPage> {
  bool isRecording = false;
  void startRecording() {
    debugPrint("بدأ التسجيل...");
  }
  void stopRecording() {
    debugPrint("تم إيقاف التسجيل...");
  }
  @override
  Widget build(BuildContext context) {
    return PenguinScaffold(
      title: 'تمرين النطق',
      mood: isRecording ? PenguinMood.speaking : PenguinMood.encouraging,
      message:
          isRecording ? 'أنا أسمعك الآن... انطق!' : 'انطق الحرف بصوت واضح 🎙',
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'أَ',
              style: TextStyle(
                fontSize: 100,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
            const SizedBox(height: 50),
            GestureDetector(
              onTap: () {
                setState(() {
                  isRecording = !isRecording;
                });
                if (isRecording) {
                  startRecording();
                } else {
                  stopRecording();
                }
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                padding: const EdgeInsets.all(30),
                decoration: BoxDecoration(
                  color: isRecording ? Colors.red : Colors.blue,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  isRecording ? Icons.stop : Icons.mic,
                  size: 50,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}