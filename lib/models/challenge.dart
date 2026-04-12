// lib/models/challenge.dart
class Challenge {
  final String id;
  final String title;
  bool isCompleted;

  Challenge({
    required this.id,
    required this.title,
    this.isCompleted = false,
  });
}