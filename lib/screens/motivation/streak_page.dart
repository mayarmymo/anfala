import 'package:flutter/material.dart';

// تأكدي من تسمية الكلاس ليتوافق مع طريقة استدعائك له في التطبيق
class StreakPage extends StatelessWidget {
  const StreakPage({super.key});

  @override
  Widget build(BuildContext context) {
    // الألوان الخاصة بهوية "بينو" البصرية
    const Color pinoNavy = Color(0xFF1E2A47); // الكحلي الأساسي
    const Color pinoOrange = Color(0xFFFF9F1C); // البرتقالي الثانوي
    const String appFont = 'Vazirmatn'; // الخط المطلوب (تأكدي من تعريفه في pubspec.yaml)
    // بيانات الأيام (تجريبي، يمكنك ربطها بقاعدة البيانات لاحقاً)
    final List<Map<String, dynamic>> weekDays = [
      {"day": "السبت", "short": "س", "done": true},
      {"day": "الأحد", "short": "اح", "done": true},
      {"day": "الاثنين", "short": "اث", "done": true},
      {"day": "الثلاثاء", "short": "ث", "done": true},
      {"day": "الأربعاء", "short": "ار", "done": true},
      {"day": "الخميس", "short": "خ", "done": true},
      {"day": "الجمعة", "short": "ج", "done": false}, // اليوم الحالي
    ];

    return Scaffold(
      backgroundColor: pinoNavy, // الخلفية الكحلية المطلوبة
      appBar: AppBar(
        backgroundColor: pinoNavy,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Directionality(
        textDirection: TextDirection.rtl, // لضمان اتجاه النص العربي
        child: SingleChildScrollView(
          child: Column(
            children: [
              // --- شعار البطريق والرقم (العنصر الأساسي الجديد) ---
              Column(
                children: [
                  // تأكدي من إضافة ملف الصورة إلى Assets في pubspec.yaml
                  ClipRRect(
                    borderRadius: BorderRadius.circular(100), // جعل الصورة دائرية تماماً
                    child: Image.asset(
                      'assets/images/penguin_3d.jpg', // مسار ملف البطريق (image_4.png)
                      height: 120, // ضبط الحجم ليتناسب مع التصميم
                      width: 120,
                      fit: BoxFit.cover, // ملء الدائرة بالكامل
                      // التعامل مع الأخطاء في حال لم يتم العثور على الملف
                      errorBuilder: (context, error, stackTrace) {
                        return const Text("🐧", style: TextStyle(fontSize: 80)); // إيموجي بديل
                      },
                    ),
                  ),
                  
                  const SizedBox(height: 10),
                  
                  // رقم السلسلة (مثال: 12 يوم)
                  const Text(
                    "12",
                    style: TextStyle( // تكبير الرقم قليلاً
                      fontFamily: appFont, // خط Vazirmatn
                      fontSize: 110, // حجم كبير مثل تصميم Duolingo
                      fontWeight: FontWeight.w900, // عريض جداً
                      color: pinoOrange, // الرقم بالبرتقالي ليبرز على الكحلي
                      height: 1.0, // ضبط التباعد العمودي للنص
                    ),
                  ),
                  
                  // النص "يوم من الاستمرار"
                  const Text(
                    "يوم من الاستمرار!",
                    style: TextStyle(
                      fontFamily: appFont, // إضافة الخط
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 40),

              // --- شريط تتبع الأيام الأسبوعي (بشكل Duolingo) ---
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1), // خلفية شفافة خفيفة فوق الكحلي
                    borderRadius: BorderRadius.circular(25),
                    border: Border.all(color: Colors.white.withOpacity(0.2)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: weekDays.map((dayData) {
                      return Column(
                        children: [
                          // اسم اليوم
                          Text(
                            dayData["short"], // الحرف المخصص لليوم
                            style: const TextStyle(
                              fontFamily: appFont,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                          const SizedBox(height: 12),
                          // دائرة التقدم
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: dayData["done"] ? pinoOrange : Colors.transparent, // برتقالي إذا اكتمل
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: dayData["done"] ? pinoOrange : Colors.white.withOpacity(0.5),
                                width: 2,
                              ),
                            ),
                            child: dayData["done"]
                                ? const Icon(Icons.check, color: pinoNavy, size: 25) // علامة صح
                                : null,
                          ),
                        ],
                      );
                    }).toList(),
                  ),
                ),
              ),

              const SizedBox(height: 50),

              // --- رسالة تشجيعية من بينو ---
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 40),
                child: Text(
                  "أنت بطل يا بطل! حافظ على مستوى PINO لتفتح جوائز أكثر.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: appFont,
                    color: Colors.white70,
                    fontSize: 18,
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}