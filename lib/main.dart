import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart'; // أضف هذا السطر
import 'package:anfalahmad/screens/motivation/main_screen.dart';
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const PinoApp());
}
class PinoApp extends StatelessWidget {
  const PinoApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, 
      title: 'بينو - Pino',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF1E2A47),
          primary: const Color(0xFF1E2A47),
          secondary: const Color(0xFFFF9F1C),
        ),
        useMaterial3: true,
        // تأكدي من تعريف الخط في pubspec.yaml كما في الصور السابقة
        fontFamily: 'Vazirmatn', 
        scaffoldBackgroundColor: Colors.white,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      // عرض الصفحة الرئيسية التي تحتوي على الشريط السفلي
      home: const MainScreen(), 
    );
  }
}