import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:shared_preferences/shared_preferences.dart';
import 'settings_page.dart';
import 'statistics_page.dart';
import '../exercises/edit_profile_page.dart';

const Color pinoNavy = Color(0xFF1E2A47);
const Color pinoOrange = Color(0xFFFF9F1C);

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String _userName = "ميار";
  String? _imagePath;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _userName = prefs.getString('user_name') ?? "ميار";
      _imagePath = prefs.getString('user_image');
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
          title: const Text(
            "ملفي الشخصي",
            style: TextStyle(
                color: pinoNavy,
                fontSize: 18,
                fontWeight: FontWeight.bold,
                fontFamily: 'Vazirmatn'),
          ),
          automaticallyImplyLeading: false,
          leading: Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconButton(
              icon: const Icon(Icons.close, color: pinoNavy, size: 28),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.settings, color: pinoNavy),
              onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const SettingsPage())),
            ),
          ],
        ),
        body: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.only(bottom: 30, top: 10),
              decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius:
                      BorderRadius.vertical(bottom: Radius.circular(30)),
                  boxShadow: [
                    BoxShadow(color: Colors.black12, blurRadius: 10)
                  ]),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: screenWidth * 0.14,
                    backgroundColor: pinoNavy,
                    child: CircleAvatar(
                      radius: screenWidth * 0.13,
                      backgroundImage: _imagePath != null
                          ? (kIsWeb
                              ? NetworkImage(_imagePath!)
                              : FileImage(File(_imagePath!)) as ImageProvider)
                          : const AssetImage('assets/images/penguin_3d.jpg')
                              as ImageProvider,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        _userName,
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: pinoNavy,
                          fontFamily: 'Vazirmatn',
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.edit, color: pinoNavy, size: 20),
                        onPressed: () {
                          Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const EditProfilePage()))
                              .then((_) => _loadData());
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
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: pinoNavy,
                          fontFamily: 'Vazirmatn'),
                    ),
                  ),
                  _buildInfoTile(
                      icon: Icons.emoji_events,
                      color: pinoNavy,
                      title: "ترتيبي العالمي", // الأيقونات الكحلية في هذا القسم
                      value: "الرابع"),
                  _buildInfoTile(
                      icon: Icons.local_fire_department,
                      color: pinoNavy,
                      title: "سلسلة النشاط",
                      value: "يوم 15"),
                  _buildInfoTile(
                      icon: Icons.calendar_month,
                      color: pinoNavy,
                      title: "عضو منذ",
                      value: "فبراير 2026"),
                  _buildInfoTile(
                      icon: Icons.auto_graph,
                      color: pinoNavy,
                      title: "تفاصيل التقدم",
                      value: "عرض",
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const StatisticsPage()));
                      }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoTile(
      {required IconData icon,
      required Color color,
      required String title,
      required String value,
      VoidCallback? onTap}) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 2,
      child: ListTile(
        onTap: onTap,
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
              color: color.withOpacity(0.1), shape: BoxShape.circle),
          child: Icon(icon, color: color),
        ),
        title: Text(
          title,
          style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 16,
              fontFamily: 'Vazirmatn',
              color: pinoNavy),
        ),
        trailing: Text(
          value,
          style: const TextStyle(
              color: pinoNavy,
              fontWeight: FontWeight.bold,
              fontSize: 16,
              fontFamily: 'Vazirmatn'),
        ),
      ),
    );
  }
}
