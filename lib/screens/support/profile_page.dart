import 'package:flutter/material.dart';
import 'settings_page.dart'; // تأكدي أن هذا الملف موجود في نفس المجلد

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // استخدام AppBar بلون غامق ليتناسب مع تصميم "بينو"
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E2A47),
        elevation: 0,
        centerTitle: false,
        title: const Text(
          "ملفي الشخصي",
          style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
        ),
        actions: [
          // زر الإعدادات: ينقلك لصفحة الإعدادات الحقيقية
          IconButton(
            icon: const Icon(Icons.settings, color: Colors.white),
            tooltip: 'الإعدادات',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingsPage()),
              );
            },
          ),
          // زر تسجيل الخروج: ينقلك لصفحة تسجيل الدخول
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.redAccent),
            tooltip: 'تسجيل الخروج',
            onPressed: () {
              // استبدلي '/login' باسم مسار صفحة الدخول لديكِ
              Navigator.pushReplacementNamed(context, '/login');
            },
          ),
        ],
      ),
      body: Directionality(
        textDirection: TextDirection.rtl, // لضمان اتجاه القوائم من اليمين لليسار
        child: Column(
          children: [
            // الجزء العلوي: بطاقة تعريف المستخدم
            Container(
              width: double.infinity,
              padding: const EdgeInsets.only(bottom: 30, top: 10),
              decoration: const BoxDecoration(
                color: Color(0xFF1E2A47),
                borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
              ),
              child: Column(
                children: [
                  const CircleAvatar(
                    radius: 55,
                    backgroundColor: Colors.white,
                    child: CircleAvatar(
                      radius: 50,
                      backgroundColor: Color(0xFFE0E0E0),
                      child: Text("🐧", style: TextStyle(fontSize: 50)),
                    ),
                  ),
                  const SizedBox(height: 15),
                  const Text(
                    "يزن قاسم",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      "مستوى: مستكشف الحروف 🌟",
                      style: TextStyle(color: Colors.white70, fontSize: 14),
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 20),

            // قائمة البيانات والإنجازات
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                children: [
                  _buildInfoTile(
                    icon: Icons.emoji_events,
                    color: Colors.amber,
                    title: "ترتيبي العالمي",
                    value: "الرابع",
                  ),
                  _buildInfoTile(
                    icon: Icons.local_fire_department,
                    color: Colors.orange,
                    title: "سلسلة النشاط",
                    value: "يوم 15",
                  ),
                  _buildInfoTile(
                    icon: Icons.calendar_month,
                    color: Colors.blue,
                    title: "عضو منذ",
                    value: "فبراير 2026",
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ودجت مخصصة لبناء عناصر القائمة بشكل متناسق
  Widget _buildInfoTile({required IconData icon, required Color color, required String title, required String value}) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 2,
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: color),
        ),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
        ),
        trailing: Text(
          value,
          style: TextStyle(
            color: color.darken(), // سيستخدم اللون نفسه بشكل أغمق أو لونه الأصلي
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}

// إضافة بسيطة لتغميق اللون في الـ trailing
extension ColorDarken on Color {
  Color darken([double amount = .1]) {
    assert(amount >= 0 && amount <= 1);
    final hsv = HSVColor.fromColor(this);
    final bgv = hsv.withValue((hsv.value - amount).clamp(0.0, 1.0));
    return bgv.toColor();
  }
}