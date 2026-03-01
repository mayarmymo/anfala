import 'package:flutter/material.dart';
import '../../widgets/penguin_mood.dart';
class PenguinCharacter extends StatelessWidget {
  final PenguinMood mood;
  final String message;
  const PenguinCharacter({
    super.key,
    required this.mood,
    required this.message,
  });
  // تحديد الرموز التعبيرية بناءً على الحالة
  String get _emoji {
    switch (mood) {
      case PenguinMood.success:
        return '🐧🎉';
      case PenguinMood.speaking:
        return '🐧🗣';
      case PenguinMood.sad:
        return '🐧😢';
      case PenguinMood.encouraging:
        return '🐧🔥';
      default:
        return '🐧🙂';
    }
  }
  // تحديد لون الحالة لزيادة التفاعل البصري
  Color get _moodColor {
    switch (mood) {
      case PenguinMood.success:
        return Colors.green;
      case PenguinMood.encouraging:
        return Colors.orange;
      case PenguinMood.sad:
        return Colors.blueGrey;
      default:
        return Colors.cyan;
    }
  }
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // حركة الإيموجي مع Scale واهتزاز خفيف
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 500),
          transitionBuilder: (child, animation) {
            return ScaleTransition(
              scale: Tween<double>(begin: 0.8, end: 1.0).animate(animation),
              child: child,
            );
          },
          child: Text(
            _emoji,
            key: ValueKey(_emoji),
            style: const TextStyle(fontSize: 80),
          ),
        ),
        const SizedBox(height: 15),
        // فقاعة الرسالة
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          margin: const EdgeInsets.symmetric(horizontal: 30),
          decoration: BoxDecoration(
            color: _moodColor.withOpacity(0.15),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: _moodColor.withOpacity(0.4),
              width: 2,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 5,
                offset: const Offset(0, 3),
              )
            ],
          ),
          child: Text(
            message,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: _moodColor, // اللون متناسق مع الحالة
            ),
          ),
        ),
      ],
    );
  }
}