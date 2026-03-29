import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  // متغيرات للتحكم في مفاتيح التشغيل
  bool soundEffects = true;
  bool notifications = false;

  // الألوان الخاصة بالهوية البصرية (بينو)
  static const Color pinoNavy = Color(0xFF1E2A47);
  static const Color pinoOrange = Color(0xFFFF9F1C);
  static const Color backgroundColor = Color(0xFFF9F9F9);

  // دالة إظهار قصة بينو
  void _showPinoStory(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            ClipOval(
              child: Image.asset('assets/images/penguin_3d.jpg', width: 40, height: 40, fit: BoxFit.cover),
            ),
            const SizedBox(width: 10),
            const Text("قصة بينو", style: TextStyle(color: pinoNavy, fontWeight: FontWeight.bold)),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
             const Text(
              "بينو ليس مجرد تطبيق، بل هو صديق قادم من القطب المتجمد! ❄️\n\n"
              "لقد قطع مسافات طويلة وترك الجليد خلفه ليأتي إلينا هنا، ليكون دليلك في رحلة التعلم ويساعدك على تطوير مهاراتك خطوة بخطوة. استمتع بالرحلة معه!",
              style: TextStyle(color: pinoNavy, fontSize: 16, height: 1.5),
              textAlign: TextAlign.right,
            ),
            const SizedBox(height: 20),
            Text(
              "الإصدار: 1.0.0",
              style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
              textAlign: TextAlign.right,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text("شكراً بينو!", style: TextStyle(color: pinoOrange, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: pinoNavy,
        elevation: 0,
        title: const Text(
          "الإعدادات",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // قسم الصوت والتنبيهات
              _buildSectionTitle("الصوت والتنبيهات"),
              _buildSettingTile(
                icon: Icons.volume_up,
                title: "تأثيرات صوتية",
                subtitle: "تشغيل الأصوات عند النقر والنجاح",
                trailing: Switch(
                  value: soundEffects,
                  activeColor: Colors.green,
                  onChanged: (val) => setState(() => soundEffects = val),
                ),
              ),
              _buildSettingTile(
                icon: Icons.notifications,
                title: "الإشعارات",
                subtitle: "تذكيري بالدراسة اليومية",
                trailing: Switch(
                  value: notifications,
                  activeColor: Colors.green,
                  onChanged: (val) => setState(() => notifications = val),
                ),
              ),

              const SizedBox(height: 20),

              // قسم الحساب واللغة
              _buildSectionTitle("الحساب واللغة"),
              _buildSettingTile(
                icon: Icons.language,
                title: "لغة التطبيق",
                trailing: const Text("العربية", style: TextStyle(color: pinoNavy, fontWeight: FontWeight.bold, fontSize: 14)),
                onTap: null,
              ),
              _buildSettingTile(
                icon: Icons.info_outline,
                title: "عن تطبيق بينو",
                trailing: const Icon(Icons.arrow_back_ios_new, size: 16, color: Colors.grey),
                onTap: () => _showPinoStory(context), // استدعاء القصة
              ),

              const SizedBox(height: 40),

              // زر مركز المساعدة (كما يظهر في الصورة)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: GestureDetector(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            const Text("مركز المساعدة", textAlign: TextAlign.right, style: TextStyle(color: pinoNavy, fontWeight: FontWeight.bold)),
                            const SizedBox(width: 10),
                            ClipOval(child: Image.asset('assets/images/penguin_3d.jpg', width: 35, height: 35, fit: BoxFit.cover)),
                          ],
                        ),
                        content: SingleChildScrollView(
                          child: RichText(
                            textAlign: TextAlign.right,
                            text: const TextSpan(
                              style: TextStyle(
                                fontFamily: 'Vazirmatn',
                                color: pinoNavy,
                                fontSize: 15,
                                height: 1.6,
                              ),
                              children: <TextSpan>[
                                TextSpan(text: "أهلاً بك في عالم بينو!\n\n"),
                                TextSpan(text: "صديقك بينو هنا ليجعل رحلة تعلم الحروف والكلمات ممتعة ومسلية.\n\n"),
                                TextSpan(
                                  text: "كيف ألعب؟\n",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                TextSpan(text: "• اسحب الحروف المبعثرة وضعها في الخانات الصحيحة.\n"),
                                TextSpan(text: "• استمع جيداً لنطق كل حرف تضعه!\n\n"),
                                TextSpan(
                                  text: "ما هي المكافأة؟\n",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                TextSpan(text: "• مع كل كلمة صحيحة، ستحصل على نجوم لامعة! 🌟\n"),
                                TextSpan(text: "• استخدم نجومك في المتجر لشراء أشياء رائعة لبينو.\n\n"),
                                TextSpan(
                                  text: "لا تقلق إذا أخطأت!\n",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                TextSpan(text: "• المحاولة مرة أخرى هي سر النجاح. استمر في اللعب!\n\n"),
                                TextSpan(
                                  text: "استمتع بالرحلة!",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(ctx), 
                            child: const Text("فهمت، لنبدأ!", style: TextStyle(color: pinoOrange, fontWeight: FontWeight.bold))
                          ),
                        ],
                      ),
                    );
                  },
                  child: Container(
                    width: double.infinity,
                    height: 55,
                    decoration: BoxDecoration(
                      color: pinoOrange.withOpacity(0.8),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: const Center(
                      child: Text(
                        "مركز المساعدة",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ويدجت عنوان القسم
  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 25, 20, 10),
      child: Text(
        title,
        style: const TextStyle(
          color: pinoNavy,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  // ويدجت الصف الخاص بالإعداد
  Widget _buildSettingTile({
    required IconData icon,
    required String title,
    String? subtitle,
    Widget? trailing,
    VoidCallback? onTap,
  }) {
    return ListTile(
      onTap: onTap,
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: pinoNavy.withOpacity(0.05),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: pinoNavy),
      ),
      title: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
      ),
      subtitle: subtitle != null
          ? Text(subtitle, style: const TextStyle(fontSize: 13, color: Colors.grey))
          : null,
      trailing: trailing,
    );
  }
}