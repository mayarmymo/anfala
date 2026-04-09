import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/store_item.dart';

// تم تعريفها هنا
const Color pinoNavy = Color(0xFF1E2A47);
const Color pinoOrange = Color(0xFFFF9F1C);

class StorePage extends StatefulWidget {
  const StorePage({super.key});

  @override
  State<StorePage> createState() => _StorePageState();
}

class _StorePageState extends State<StorePage> {
  int userHearts = 60;

  @override
  void initState() {
    super.initState();
    _loadHearts();
  }

  Future<void> _loadHearts() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      userHearts = prefs.getInt('user_hearts') ?? 60;
    });
  }

  // قائمة العناصر بمسارات الصور والأسعار
  List<StoreItem> items = [
    StoreItem(
        id: '1', name: 'قبعة', imagePath: 'assets/images/hat.jpg', price: 20),
    StoreItem(
        id: '2', name: 'تاج', imagePath: 'assets/images/crown.jpg', price: 50),
  ];

  // دالة الشراء
  Future<void> _buyItem(StoreItem item) async {
    if (userHearts >= item.price) {
      final prefs = await SharedPreferences.getInstance();
      setState(() {
        userHearts -= item.price;
        item.isBought = true;
      });
      await prefs.setInt('user_hearts', userHearts);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("مبروك! حصلت على ${item.name}",
              style: const TextStyle(fontFamily: 'Vazirmatn')),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("عذراً، رصيدك غير كافٍ ❤️",
              style: TextStyle(fontFamily: 'Vazirmatn')),
          backgroundColor: Colors.redAccent,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl, // لضمان التنسيق العربي الصحيح
      child: Scaffold(
        backgroundColor: const Color(0xFFF5F5FA),
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          automaticallyImplyLeading: false,
          title: const Text(
            "المتجر",
            style: TextStyle(
                color: pinoNavy,
                fontWeight: FontWeight.bold,
                fontFamily: 'Vazirmatn'),
          ),
          centerTitle: true,
          leading: Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconButton(
              icon: const Icon(Icons.close, color: pinoNavy, size: 28),
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ),
        body: Column(
          children: [
            // لوحة الرصيد العلوية
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 15),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius:
                    BorderRadius.vertical(bottom: Radius.circular(30)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("رصيدك الحالي: ",
                      style: TextStyle(
                          color: pinoNavy,
                          fontSize: 14,
                          fontFamily: 'Vazirmatn')),
                  Text("$userHearts",
                      style: TextStyle(
                          color: pinoNavy,
                          fontSize: 22,
                          fontWeight: FontWeight.bold)),
                  const SizedBox(width: 8),
                  const Icon(Icons.favorite, color: Colors.red, size: 22),
                ],
              ),
            ),

            // شبكة عرض المنتجات
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.all(12),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.85,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemCount: items.length,
                itemBuilder: (context, index) {
                  return _buildStoreCard(items[index]);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ويدجت بطاقة المنتج
  Widget _buildStoreCard(StoreItem item) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          )
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // حاوية الصورة (تكبير وملء الدائرة)
          Container(
            width: 75, // حجم أصغر للصورة
            height: 75,
            decoration: BoxDecoration(
              color: item.isBought
                  ? Colors.green.withOpacity(0.1)
                  : pinoNavy.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: ClipOval(
              child: Image.asset(
                item.imagePath,
                fit: BoxFit.contain, // لضمان ظهور التاج بشكل رأسي كامل
                errorBuilder: (context, error, stackTrace) => const Icon(
                    Icons.broken_image,
                    size: 40,
                    color: Colors.grey),
              ),
            ),
          ),

          Text(
            item.name,
            style: const TextStyle(
                color: pinoNavy,
                fontWeight: FontWeight.bold,
                fontSize: 13,
                fontFamily: 'Vazirmatn'),
          ),

          if (item.isBought) _buildOwnedBadge() else _buildBuyButton(item),
        ],
      ),
    );
  }

  Widget _buildOwnedBadge() {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.check_circle, color: Colors.green, size: 20),
        SizedBox(width: 5),
        Text(
          "مملوك",
          style: TextStyle(
              color: Colors.green,
              fontWeight: FontWeight.bold,
              fontFamily: 'Vazirmatn'),
        ),
      ],
    );
  }

  Widget _buildBuyButton(StoreItem item) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: pinoNavy,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),
      onPressed: () => _buyItem(item),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "${item.price}",
            style: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(width: 4),
          const Icon(Icons.favorite, size: 16, color: Colors.red),
        ],
      ),
    );
  }
}
