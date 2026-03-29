import 'package:flutter/material.dart';
ThemeData appTheme() {
  return ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: Colors.cyan,
      primary: Colors.cyan,
      secondary: Colors.amber,
      surface: Colors.white,
    ),
    // تحسين مظهر النصوص لتدعم العربية بشكل أفضل
    fontFamily: 'Vazirmatn', // تأكد من إضافة الخط في pubspec.yaml إذا أردت استخدامه
    // تنسيق موحد للبطاقات (Cards)
    cardTheme: CardTheme(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
    ),
    // تنسيق موحد للأزرار الكبيرة
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        backgroundColor: Colors.cyan,
        foregroundColor: Colors.white,
      ),),
    // تنسيق حقول الإدخال (إذا استخدمتها لاحقاً)
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      filled: true,
      fillColor: Colors.grey[50],
),);}