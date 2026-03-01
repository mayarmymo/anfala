import 'package:flutter/material.dart';
// استيراد الشاشة الرئيسية التي تربط (المراحل، المتجر، السلسلة، التحديات، وحسابي)
import 'screens/motivation/main_screen.dart'; 

void main() {
  // هذا السطر يضمن تهيئة التطبيق بشكل صحيح قبل التشغيل
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const PinoApp());
}

class PinoApp extends StatelessWidget {
  const PinoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // لإخفاء علامة "Debug" المزعجة في طرف الشاشة
      debugShowCheckedModeBanner: false, 
      
      title: 'بينو - Pino',
      
      theme: ThemeData(
        // تحديد اللون الأساسي للتطبيق
        primarySwatch: Colors.blue,
        
        // تفعيل خط Tajawal الذي أضفتيه في pubspec.yaml
        // تأكدي أن الاسم هنا "Tajawal" مطابق تماماً للاسم الموجود في ملف الـ yaml
        fontFamily: 'Tajawal', 
        
        // تحسين جودة النصوص على الشاشات المختلفة
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),

      // الصفحة التي يبدأ منها التطبيق (تحتوي على شريط التنقل السفلي)
      home: const MainScreen(), 
      
      // تعريف المسارات (Routes) إذا كنتِ تستخدمين التنقل بالأسماء
      // مثال: Navigator.pushNamed(context, '/evaluation');
      routes: {
        // أضيفي هنا مسارات الصفحات الأخرى إذا لزم الأمر
        // '/evaluation': (context) => const EvaluationPage(),
      },
    );
  }
}