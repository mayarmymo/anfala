import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

class PenguinChefPage extends StatefulWidget {
  const PenguinChefPage({super.key});

  @override
  State<PenguinChefPage> createState() => _PenguinChefPageState();
}

class _PenguinChefPageState extends State<PenguinChefPage> with SingleTickerProviderStateMixin {
  final AudioPlayer _audioPlayer = AudioPlayer();
  List<String> potIngredients = []; 
  final String recipe = "قمر"; 

  final Color pinoNavy = const Color(0xFF1E2A47);
  final Color pinoOrange = const Color(0xFFFF9F1C);
  late AnimationController _steamController;

  @override
  void initState() {
    super.initState();
    _steamController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
  }

  @override
  void dispose() {
    _steamController.dispose();
    _audioPlayer.dispose();
    super.dispose();
  }

  Future<void> _playCookingSound(String letter) async {
    final Map<String, String> sounds = {'ق': 'qaf', 'م': 'meem', 'ر': 'raa'};
    try {
      await _audioPlayer.stop();
      await _audioPlayer.play(AssetSource('sounds/letters/${sounds[letter]}.mp3'));
    } catch (e) { print(e); }
  }

  void _addToPot(String letter) {
    if (potIngredients.length < 3) {
      setState(() {
        potIngredients.add(letter);
        _playCookingSound(letter);
      });

      if (potIngredients.length == 3) {
        Future.delayed(const Duration(milliseconds: 500), () {
          if (potIngredients.join() == recipe) {
            _showChefSuccess();
          } else {
            _showChefError();
          }
        });
      }
    }
  }

  void _showChefSuccess() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text("✨ طبخة مذهلة! ✨", textAlign: TextAlign.center, style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold, fontFamily: 'Vazirmatn')),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text("👨‍🍳🥣", style: TextStyle(fontSize: 60)),
            const SizedBox(height: 10),
            Text("لقد صنعت شوربة ($recipe) بنجاح!", textAlign: TextAlign.center, style: const TextStyle(fontFamily: 'Vazirmatn', fontSize: 16)),
          ],
        ),
        actions: [
          Center(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: pinoOrange),
              onPressed: () {
                setState(() => potIngredients.clear());
                Navigator.pop(context);
              },
              child: const Text("وصفة جديدة", style: TextStyle(color: Colors.white, fontFamily: 'Vazirmatn')),
            ),
          )
        ],
      ),
    );
  }

  void _showChefError() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.redAccent,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        content: const Text("أوه! الترتيب خاطئ، احترقت الطبخة! 🔥", textAlign: TextAlign.center, style: TextStyle(fontFamily: 'Vazirmatn')),
      ),
    );
    setState(() => potIngredients.clear());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

    

      backgroundColor: const Color(0xFFFFF8E1), // تم التعديل للون المطلوب
      appBar: AppBar(
        title: const Text("شيف الحروف", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontFamily: 'Vazirmatn')),
        backgroundColor: pinoNavy, // تم التعديل للكحلي
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(3),
                  decoration: BoxDecoration(color: pinoOrange, shape: BoxShape.circle),
                  child: const CircleAvatar(
                    radius: 35,
                    backgroundImage: AssetImage('assets/images/penguin_3d.jpg'),
                    backgroundColor: Colors.white,
                  ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(20),
                        bottomRight: Radius.circular(20),
                        bottomLeft: Radius.circular(20),
                      ),
                      boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 5, offset: const Offset(2, 2))],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("ساعدني لنطبخ:", style: TextStyle(fontSize: 14, color: Colors.grey[600], fontFamily: 'Vazirmatn')),
                        Text("شوربة ($recipe)", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: pinoNavy, fontFamily: 'Vazirmatn')),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Spacer(),
          Stack(
            alignment: Alignment.bottomCenter,
            clipBehavior: Clip.none,
            children: [
               Positioned(top: -50, child: _buildSteam()),
              Container(
                width: 200, height: 160,
                decoration: BoxDecoration(
                   gradient: LinearGradient(
                     colors: [Colors.redAccent.shade400, Colors.redAccent.shade700],
                     begin: Alignment.topLeft, end: Alignment.bottomRight,
                   ),
                  borderRadius: const BorderRadius.vertical(bottom: Radius.circular(90), top: Radius.circular(10)),
                  boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 15, offset: const Offset(0, 10))],
                ),
                child: Center(
                  child: Wrap(
                    alignment: WrapAlignment.center,
                    spacing: 8,
                    children: potIngredients.map((l) => _buildFloatingIngredient(l)).toList(),
                  ),
                ),
              ),
               Positioned(left: -15, top: 20, child: Container(width: 25, height: 15, decoration: BoxDecoration(color: Colors.red.shade900, borderRadius: BorderRadius.circular(5)))),
               Positioned(right: -15, top: 20, child: Container(width: 25, height: 15, decoration: BoxDecoration(color: Colors.red.shade900, borderRadius: BorderRadius.circular(5)))),
            ],
          ),
          const Spacer(),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.only(top: 30, bottom: 40, left: 20, right: 20),
            decoration: const BoxDecoration(
              color: Color(0xFF8D6E63),
              borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
            ),
            child: Column(
              children: [
                const Text("أضف المكونات:", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 16, fontFamily: 'Vazirmatn')),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: ['ر', 'م', 'ق'].map((letter) => _buildIngredientBtn(letter)).toList(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSteam() {
    return AnimatedBuilder(
      animation: _steamController,
      builder: (context, child) {
        return Opacity(
          opacity: 1.0 - _steamController.value,
          child: Transform.translate(offset: Offset(0, -30 * _steamController.value), child: child),
        );
      },
      child: const Row(mainAxisSize: MainAxisSize.min, children: [Icon(Icons.cloud, color: Colors.white, size: 20), Icon(Icons.cloud, color: Colors.white, size: 30)]),
    );
  }

  Widget _buildFloatingIngredient(String char) {
    return Container(
      width: 45, height: 45, alignment: Alignment.center,
      decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
      child: Text(char, style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: pinoNavy, fontFamily: 'Vazirmatn')),
    );
  }

  Widget _buildIngredientBtn(String letter) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: InkWell(
        onTap: () => _addToPot(letter),
        child: Container(
          width: 65, height: 65, alignment: Alignment.center,
          decoration: BoxDecoration(color: Colors.white, shape: BoxShape.circle, border: Border.all(color: const Color(0xFF6D4C41), width: 3)),
          child: Text(letter, style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: pinoNavy, fontFamily: 'Vazirmatn')),
        ),
      ),
    );
  }
}