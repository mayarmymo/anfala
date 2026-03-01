import 'package:flutter/material.dart';
import '../../widgets/penguin_scaffold.dart';
import '../../widgets/penguin_mood.dart';
/// نموذج بيانات التحدي
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
class ChallengesPage extends StatefulWidget {
  const ChallengesPage({super.key});
  @override
  State<ChallengesPage> createState() => _ChallengesPageState();
}
class _ChallengesPageState extends State<ChallengesPage> {
  final List<Challenge> _challenges = [
    Challenge(id: '1', title: 'أكمل 3 تمارين رياضية'),
    Challenge(id: '2', title: 'اشرب 8 أكواب من الماء'),
    Challenge(id: '3', title: 'قراءة لمدة 15 دقيقة'),
    Challenge(id: '4', title: 'تأمل الصباح لمدة 5 دقائق'),
  ];
  void _toggleChallenge(int index) {
    setState(() {
      _challenges[index].isCompleted = !_challenges[index].isCompleted;
    });
  }
  double get _progress =>
      _challenges.where((c) => c.isCompleted).length / _challenges.length;
  @override
  Widget build(BuildContext context) {
    final completedCount =
        _challenges.where((c) => c.isCompleted).length;
    return PenguinScaffold(
      title: 'التحديات اليومية',
      mood: PenguinMood.encouraging,
      message: 'أنجزت $completedCount من ${_challenges.length} اليوم 👏',
      child: Column(
        children: [
          /// شريط التقدم
          Padding(
            padding: const EdgeInsets.all(16),
            child: LinearProgressIndicator(
              value: _progress,
              minHeight: 8,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          /// القائمة
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _challenges.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                return ChallengeCard(
                  key: ValueKey(_challenges[index].id),
                  challenge: _challenges[index],
                  onTap: () => _toggleChallenge(index),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
/// كرت التحدي
class ChallengeCard extends StatelessWidget {
  final Challenge challenge;
  final VoidCallback onTap;

  const ChallengeCard({
    super.key,
    required this.challenge,
    required this.onTap,
  });
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Material(
      borderRadius: BorderRadius.circular(15),
      child: InkWell(
        borderRadius: BorderRadius.circular(15),
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          decoration: BoxDecoration(
            color: challenge.isCompleted
                ? theme.colorScheme.primary.withOpacity(0.1)
                : theme.cardColor,
            borderRadius: BorderRadius.circular(15),
            border: Border.all(
              color: challenge.isCompleted
                  ? theme.colorScheme.primary
                  : theme.dividerColor,
              width: 2,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 6,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Row(
            children: [
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                transitionBuilder: (child, animation) =>
                    ScaleTransition(scale: animation, child: child),
child: Icon(
                  challenge.isCompleted
                      ? Icons.check_circle
                      : Icons.radio_button_unchecked,
                  key: ValueKey(challenge.isCompleted),
                  color: challenge.isCompleted
                      ? theme.colorScheme.primary
                      : Colors.grey,
                  size: 28,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  challenge.title,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    decoration: challenge.isCompleted
                        ? TextDecoration.lineThrough
                        : TextDecoration.none,
                    color: challenge.isCompleted
                        ? Colors.grey
                        : theme.textTheme.titleMedium?.color,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}