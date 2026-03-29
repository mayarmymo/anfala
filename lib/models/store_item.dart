// lib/models/store_item.dart

class StoreItem {
  final String id;
  final String name;      // ستحتوي على "قبعة" أو "تاج"
  final String imagePath; 
  final int price;
  bool isBought;
  bool isEquipped;

  StoreItem({
    required this.id, 
    required this.name, 
    required this.imagePath, 
    required this.price, 
    this.isBought = false,
    this.isEquipped = false,
  });
}