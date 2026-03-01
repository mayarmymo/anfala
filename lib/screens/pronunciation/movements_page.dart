import 'package:flutter/material.dart';
import 'drag_drop_page.dart';

class MovementsPage extends StatelessWidget {
  const MovementsPage({super.key});

  @override
  Widget build(BuildContext context) {
    const Color pinoNavy = Color(0xFF1E2A47);

    return Scaffold(
      appBar: AppBar(
        title: const Text("مراحل اللعب"),
        backgroundColor: pinoNavy,
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _buildLevelCard(
            context,
            title: "المرحلة الأولى",
            subtitle: "ترتيب كلمة قَمَر",
            icon: Icons.extension,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const DragDropPage()),
              );
            },
          ),
          // يمكنك إضافة مراحل أخرى هنا بنفس الطريقة
        ],
      ),
    );
  }

  Widget _buildLevelCard(BuildContext context, {required String title, required String subtitle, required IconData icon, required VoidCallback onTap}) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.only(bottom: 20),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: ListTile(
        contentPadding: const EdgeInsets.all(20),
        leading: CircleAvatar(
          backgroundColor: const Color(0xFFFF9F1C),
          child: Icon(icon, color: Colors.white),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.arrow_forward_ios),
        onTap: onTap,
      ),
    );
  }
}