import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  // متغيرات للتحكم في الحالة (إعدادات تجريبية)
  bool _isSoundEnabled = true;
  bool _isNotificationsEnabled = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E2A47),
        elevation: 0,
        title: const Text(
          "الإعدادات",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        // سهم العودة يظهر تلقائياً بلون أبيض
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _buildSectionTitle("الصوت والتنبيهات"),
            _buildSwitchTile(
              icon: Icons.volume_up,
              title: "تأثيرات صوتية",
              subtitle: "تشغيل الأصوات عند النقر والنجاح",
              value: _isSoundEnabled,
              onChanged: (val) => setState(() => _isSoundEnabled = val),
            ),
            _buildSwitchTile(
              icon: Icons.notifications_active,
              title: "الإشعارات",
              subtitle: "تذكيري بالدراسة اليومية",
              value: _isNotificationsEnabled,
              onChanged: (val) => setState(() => _isNotificationsEnabled = val),
            ),
            const Divider(height: 40),
            _buildSectionTitle("الحساب واللغة"),
            _buildActionTile(
              icon: Icons.language,
              title: "لغة التطبيق",
              trailing: "العربية",
              onTap: () {
                // منطق تغيير اللغة مستقبلاً
              },
            ),
            _buildActionTile(
              icon: Icons.info_outline,
              title: "عن تطبيق بينو",
              trailing: "v1.0.0",
              onTap: () {
                showAboutDialog(
                  context: context,
                  applicationName: "بينو - تعلم الحروف",
                  applicationVersion: "1.0.0",
                  applicationIcon: const Text("🐧", style: TextStyle(fontSize: 40)),
                );
              },
            ),
            const SizedBox(height: 30),
            // زر مساعدة إضافي
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orangeAccent,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              ),
              onPressed: () {},
              icon: const Icon(Icons.help_center, color: Colors.white),
              label: const Text("مركز المساعدة", style: TextStyle(color: Colors.white, fontSize: 16)),
            ),
          ],
        ),
      ),
    );
  }

  // عنوان القسم
  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10, right: 10),
      child: Text(
        title,
        style: const TextStyle(
          color: Color(0xFF1E2A47),
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  // ويدجت Switch (تفعيل/تعطيل)
  Widget _buildSwitchTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: SwitchListTile(
        secondary: Icon(icon, color: const Color(0xFF1E2A47)),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle, style: const TextStyle(fontSize: 12)),
        value: value,
        onChanged: onChanged,
        activeColor: Colors.green,
      ),
    );
  }

  // ويدجت إجراء (نقر فقط)
  Widget _buildActionTile({
    required IconData icon,
    required String title,
    required String trailing,
    required VoidCallback onTap,
  }) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: ListTile(
        leading: Icon(icon, color: const Color(0xFF1E2A47)),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(trailing, style: const TextStyle(color: Colors.grey)),
            const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
          ],
        ),
        onTap: onTap,
      ),
    );
  }
}