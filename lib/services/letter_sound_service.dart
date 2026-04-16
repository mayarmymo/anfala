import 'package:flutter/material.dart';

Widget letterCard(String letter, {bool isFeedback = false}) {
  return Material(
    color: Colors.transparent,
    child: InkWell(
      borderRadius: BorderRadius.circular(15),
      onTap: () {
        // LetterSoundService.playLetter(letter); 
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 90,
        height: 90,
        decoration: BoxDecoration(
          color: const Color(0xFF1E2A47), // لون Pino الأزرق
          borderRadius: BorderRadius.circular(15),
          boxShadow: isFeedback
              ? const [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 10,
                    offset: Offset(0, 5),
                  )
                ]
              : [],
          border: Border.all(color: const Color(0xFFFF9F1C), width: 1),
        ),
        child: Center(
          child: Text(
            letter,
            style: const TextStyle(
              fontSize: 42,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    ),
  );
}