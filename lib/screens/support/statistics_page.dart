import 'package:flutter/material.dart';

class StatisticsPage extends StatelessWidget {
  const StatisticsPage({super.key});

  @override
  Widget build(BuildContext context) {
    const Color pinoNavy = Color(0xFF1E2A47);
    const Color pinoOrange = Color(0xFFFF9F1C);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "إحصائيات التقدم",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontFamily: 'Vazirmatn'),
        ),
        centerTitle: true,
        backgroundColor: pinoNavy, // الشريط العلوي الكحلي
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        elevation: 0,
      ),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [BoxShadow(color: pinoNavy.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, 5))],
                ),
                child: Column(
                  children: [
                    const Text("النشاط الأسبوعي", style: TextStyle(fontWeight: FontWeight.bold, color: pinoNavy, fontSize: 18, fontFamily: 'Vazirmatn')),
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
              const SizedBox(height: 25),
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
      ),
    );
  }

  Widget _buildBar(String day, double heightFactor, Color color) => Column(
    children: [
      Container(width: 15, height: 100 * heightFactor, decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(10))),
      const SizedBox(height: 8),
      Text(day, style: const TextStyle(fontSize: 14, fontFamily: 'Vazirmatn')),
    ],
  );

  Widget _buildStatItem(String title, String value, IconData icon, Color color) => Container(
    decoration: BoxDecoration(
      color: Colors.white, 
      borderRadius: BorderRadius.circular(20), 
      border: Border.all(color: color.withOpacity(0.2)),
      boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 5)],
    ),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, color: color, size: 35),
        const SizedBox(height: 8),
        Text(value, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, fontFamily: 'Vazirmatn')),
        Text(title, style: const TextStyle(color: Colors.grey, fontSize: 13, fontFamily: 'Vazirmatn')),
      ],
    ),
  );
}