import 'package:flutter/material.dart';
import 'settings_page.dart';
import 'statistics_page.dart';
import '../exercises/edit_profile_page.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    const Color pinoNavy = Color(0xFF1E2A47);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: pinoNavy,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "ملفي الشخصي",
          style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold, fontFamily: 'Vazirmatn'),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings, color: Colors.white),
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const SettingsPage())),
          ),
        ],
      ),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.only(bottom: 30, top: 10),
              decoration: const BoxDecoration(
                color: pinoNavy,
                borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
              ),
              child: Column(
                children: [
                  const CircleAvatar(
                    radius: 55,
                    backgroundColor: Colors.white,
                    child: CircleAvatar(
                      radius: 50,
                      backgroundImage: AssetImage('assets/images/penguin_3d.jpg'),
                    ),
                  ),
                  const SizedBox(height: 15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        " ميار",
                        style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold, fontFamily: 'Vazirmatn'),
                      ),
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.white70, size: 20),
                        onPressed: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => const EditProfilePage()));
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                children: [
                  const Padding(
                    padding: EdgeInsets.only(bottom: 10),
                    child: Text(
                      "الإحصائيات العامة",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: pinoNavy, fontFamily: 'Vazirmatn'),
                    ),
                  ),
                  _buildInfoTile(icon: Icons.emoji_events, color: Colors.amber, title: "ترتيبي العالمي", value: "الرابع"),
                  _buildInfoTile(icon: Icons.local_fire_department, color: Colors.orange, title: "سلسلة النشاط", value: "يوم 15"),
                  _buildInfoTile(icon: Icons.calendar_month, color: Colors.blue, title: "عضو منذ", value: "فبراير 2026"),
                  _buildInfoTile(
                    icon: Icons.auto_graph,
                    color: Colors.purple,
                    title: "تفاصيل التقدم",
                    value: "عرض",
                    onTap: () {
                       Navigator.push(context, MaterialPageRoute(builder: (context) => const StatisticsPage()));
                    }
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoTile({required IconData icon, required Color color, required String title, required String value, VoidCallback? onTap}) {
         return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 2,
      child: ListTile(
        onTap: onTap,
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(color: color.withOpacity(0.1), shape: BoxShape.circle),
          child: Icon(icon, color: color),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16, fontFamily: 'Vazirmatn')),
        trailing: Text(value, style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 16, fontFamily: 'Vazirmatn')),
      ),
    );
  }
}