import 'package:flutter/material.dart';
import '../models/store_item.dart';

class StorePage extends StatefulWidget {
  const StorePage({super.key});

  @override
  State<StorePage> createState() => _StorePageState();
}

class _StorePageState extends State<StorePage> {
  int userHearts = 60; // الرصيد بالقلوب
  
  // تحديث قائمة العناصر بالأسماء المختصرة ومسارات الصور
  List<StoreItem> items = [
    StoreItem(id: '1', name: 'قبعة', imagePath: 'assets/images/hat.jpg', price: 20),
    StoreItem(id: '2', name: 'تاج', imagePath: 'assets/images/crown.jpg', price: 50),
  ];

  final Color pinoNavy = const Color(0xFF1E2A47);
  final Color pinoOrange = const Color(0xFFFF9F1C);

  // دالة الشراء (كما في النسخة المحسنة سابقاً)
  void _buyItem(StoreItem item) {
    if (userHearts >= item.price) {
      setState(() {
        userHearts -= item.price;
        item.isBought = true;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("مبروك! حصلت على ${item.name}"),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("عذراً، رصيدك غير كافٍ ❤️"),
          backgroundColor: Colors.redAccent,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5FA),
      appBar: AppBar(
        backgroundColor: pinoNavy,
        elevation: 0,
        automaticallyImplyLeading: false, // مهم جداً
        title: const Text(
           "المتجر", // تم تغيير العنوان ليكون أنسب
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontFamily: 'Vazirmatn'),
        ),
        centerTitle: true,
        leading: Align(
          alignment: Alignment.centerLeft,
          child: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
        ),
      ),
      body: Column(
        children: [
          // لوحة الرصيد
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
                const Text("رصيدك الحالي: ", style: TextStyle(color: Colors.white70, fontSize: 18, fontFamily: 'Vazirmatn')),
                Text("$userHearts", style: TextStyle(color: pinoOrange, fontSize: 32, fontWeight: FontWeight.bold)),
                const SizedBox(width: 8),
                const Icon(Icons.favorite, color: Colors.red, size: 35), // قلب
              ],
            ),
          ),
          
          // شبكة المنتجات
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(20),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.75, // نسبة العرض إلى الارتفاع للبطاقة
                crossAxisSpacing: 15,
                mainAxisSpacing: 15,
              ),
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index];
                return _buildStoreCard(item);
              },
            ),
          ),
        ],
      ),
    );
  }

  // ويدجت منفصل لكل بطاقة منتج (محدث لعرض الصور)
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
          // حاوية الصورة (بدلاً من الإيموجي)
          Container(
            padding: const EdgeInsets.all(10), // تقليل البادينج ليناسب الصور
            width: 100, // تحديد عرض ثابت للحاوية
            height: 100, // تحديد ارتفاع ثابت للحاوية
            decoration: BoxDecoration(
              color: item.isBought ? Colors.green.withOpacity(0.1) : pinoOrange.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            // استخدام Image.asset لعرض الصورة
            child: ClipOval( // قص الصورة لتكون دائرية
              child: Image.asset(
                item.imagePath,
                fit: BoxFit.contain, // لجعل الصورة تتناسب داخل الدائرة
                errorBuilder: (context, error, stackTrace) {
                  // في حال لم يتم تحميل الصورة، اعرض أيقونة افتراضية
                  return Icon(Icons.broken_image, size: 40, color: Colors.grey);
                },
              ),
            ),
          ),
          
          // اسم العنصر المختصر (قبعة، تاج)
          Text(
            item.name,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, fontFamily: 'Vazirmatn'),
          ),
          
          // حالة الشراء أو زر الشراء
          if (item.isBought)
            _buildOwnedBadge() 
          else
            _buildBuyButton(item),
        ],
      ),
    );
  }

  // ويدجت شارة "مملوك" (المحسنة)
  Widget _buildOwnedBadge() {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.check_circle, color: Colors.green, size: 20),
        SizedBox(width: 5),
        Text(
          "مملوك",
          style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold, fontFamily: 'Vazirmatn'),
        ),
      ],
    );
  }

  // ويدجت زر الشراء (المحسن)
  Widget _buildBuyButton(StoreItem item) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: pinoNavy,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        padding: const EdgeInsets.symmetric(horizontal: 16),
      ),
      onPressed: () => _buyItem(item),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "${item.price}",
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          const SizedBox(width: 4),
          const Icon(Icons.favorite, size: 16, color: Colors.red),
        ],
      ),
    );
  }
}