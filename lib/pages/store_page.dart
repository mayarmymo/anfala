import 'package:flutter/material.dart';
import '../models/store_item.dart';

class StorePage extends StatefulWidget {
  const StorePage({super.key});

  @override
  State<StorePage> createState() => _StorePageState();
}

class _StorePageState extends State<StorePage> {
  int userStars = 100; // رصيد افتراضي
  List<StoreItem> items = [
    StoreItem(id: '1', name: 'قبعة حمراء', emoji: '🎩', price: 20),
    StoreItem(id: '2', name: 'تاج بطل', emoji: '👑', price: 50),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("متجر بينو ($userStars ⭐)")),
      body: GridView.builder(
        padding: const EdgeInsets.all(15),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
        itemCount: items.length,
        itemBuilder: (context, index) {
          final item = items[index];
          return Card(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(item.emoji, style: const TextStyle(fontSize: 40)),
                Text(item.name),
                ElevatedButton(
                  onPressed: () {
                    if (userStars >= item.price) {
                      setState(() {
                        userStars -= item.price;
                        item.isBought = true;
                      });
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("ليس لديك نجوم كافية! ⭐")),
                      );
                    }
                  },
                  child: Text(item.isBought ? "تم الشراء" : "${item.price} ⭐"),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}