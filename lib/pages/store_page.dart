import 'package:flutter/material.dart';
import '../models/store_item.dart';

class StorePage extends StatefulWidget {
  const StorePage({super.key});

  @override
  State<StorePage> createState() => _StorePageState();
}

class _StorePageState extends State<StorePage> {
  int userStars = 60; // رصيد افتراضي
  List<StoreItem> items = [
    StoreItem(id: '1', name: 'قبعة حمراء', emoji: '🎩', price: 20),
    StoreItem(id: '2', name: 'تاج بطل', emoji: '👑', price: 50),
  ];

  // الألوان الخاصة بهوية التطبيق
  final Color pinoNavy = const Color(0xFF1E2A47);
  final Color pinoOrange = const Color(0xFFFF9F1C);



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5FA), // خلفية رمادية فاتحة جداً لإبراز البطاقات
      appBar: AppBar(
        title: const Text("متجر بينو", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: pinoNavy,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        elevation: 0,
      ),
      body: Column(
        children: [
          // --- رأس الصفحة: عرض الرصيد ---
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 30),
            decoration: BoxDecoration(
              color: pinoNavy,
              borderRadius: const BorderRadius.vertical(bottom: Radius.circular(30)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("رصيدك الحالي: ", style: TextStyle(color: Colors.white70, fontSize: 18)),
                Text("$userStars", style: TextStyle(color: pinoOrange, fontSize: 32, fontWeight: FontWeight.bold)),
                const SizedBox(width: 8),
                Icon(Icons.star, color: pinoOrange, size: 35),
              ],
            ),
          ),

          // --- شبكة المنتجات ---
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(20),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.75, // جعل البطاقة أطول قليلاً لاستيعاب المحتوى
                crossAxisSpacing: 15,
                mainAxisSpacing: 15,
              ),
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index];
                return Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 5))
                    ],
                    border: item.isBought ? Border.all(color: Colors.green.withOpacity(0.3), width: 2) : null,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      // دائرة خلفية للإيموجي
                      Container(
                        padding: const EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          color: item.isBought ? Colors.green.withOpacity(0.1) : pinoOrange.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Text(item.emoji, style: const TextStyle(fontSize: 50)),
                      ),
                    

                      Text(
                        item.name, 
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                        textAlign: TextAlign.center,
                      ),

                      // زر الشراء أو حالة الامتلاك
                      if (item.isBought)
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children:  [
                            Icon(Icons.check_circle, color: Colors.green, size: 20),
                            SizedBox(width: 5),
                            Text("مملوك", style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
                          ],
                        )
                      else
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: pinoNavy,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                          ),
                          onPressed: () {
                            if (userStars >= item.price) {
                              setState(() {
                                userStars -= item.price;
                                item.isBought = true;
                              });
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text("مبروك! حصلت على ${item.name} 🎉"),
                                  backgroundColor: Colors.green,
                                ),
                              );
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("ليس لديك نجوم كافية! حاول جمع المزيد ⭐"),
                                  backgroundColor: Colors.redAccent,
                                ),
                              );
                            }
                          },
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text("${item.price}"),
                              const SizedBox(width: 4),
                              const Icon(Icons.star, size: 16, color: Color(0xFFFF9F1C)),
                            ],
                          ),
                        )
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}