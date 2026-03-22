class StoreItem {
  final String id;
  final String name;
  final String emoji; 
  final int price;
  bool isBought;
  bool isEquipped;

  StoreItem({
    required this.id, 
    required this.name, 
    required this.emoji, 
    required this.price, 
    this.isBought = false,
    this.isEquipped = false,
  });
}