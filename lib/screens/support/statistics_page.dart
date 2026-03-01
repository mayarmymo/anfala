import 'package:flutter/material.dart';

class StatisticsPage extends StatelessWidget {
  const StatisticsPage({super.key});

  @override
  Widget build(BuildContext context) {
    const Color pinoNavy = Color(0xFF1E2A47);
    const Color pinoOrange = Color(0xFFFF9F1C);

    return Scaffold(
      appBar: AppBar(title: const Text("إحصائيات التقدم")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // بطاقة الأداء الأسبوعي
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [BoxShadow(color: pinoNavy.withOpacity(0.05), blurRadius: 10)],
              ),
              child: Column(
                children: [
                  const Text("النشاط الأسبوعي", style: TextStyle(fontWeight: FontWeight.bold, color: pinoNavy)),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      _buildBar("ح", 0.4, pinoOrange), _buildBar("ن", 0.8, pinoOrange),
                      _buildBar("ث", 0.6, pinoOrange), _buildBar("ر", 0.9, pinoNavy),
                      _buildBar("خ", 0.5, pinoOrange), _buildBar("ج", 0.3, pinoOrange),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            // إحصائيات سريعة
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              crossAxisSpacing: 15,
              mainAxisSpacing: 15,
              children: [
                _buildStatItem("كلمات متقنة", "48", Icons.spellcheck, pinoOrange),
                _buildStatItem("وقت التمرين", "5.2 س", Icons.timer, pinoNavy),
                _buildStatItem("دقة النطق", "92%", Icons.auto_graph, pinoOrange),
                _buildStatItem("أعلى سلسلة", "15 يوم", Icons.local_fire_department, pinoNavy),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBar(String day, double heightFactor, Color color) => Column(
    children: [
      Container(width: 12, height: 100 * heightFactor, decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(10))),
      const SizedBox(height: 5),
      Text(day, style: const TextStyle(fontSize: 12)),
    ],
  );

  Widget _buildStatItem(String title, String value, IconData icon, Color color) => Container(
    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), border: Border.all(color: color.withOpacity(0.1))),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, color: color, size: 30),
        const SizedBox(height: 8),
        Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        Text(title, style: const TextStyle(color: Colors.grey, fontSize: 12)),
      ],
    ),
  );
}