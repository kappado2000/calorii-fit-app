import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'streak_providers.dart';

/// A small flame + day-count chip — hidden entirely at zero (a "0" badge
/// reads as a nag, not encouragement) rather than always showing.
class StreakBadge extends ConsumerWidget {
  const StreakBadge({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final streak = ref.watch(currentStreakProvider).valueOrNull ?? 0;
    if (streak <= 0) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.orange.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('🔥', style: TextStyle(fontSize: 14)),
            const SizedBox(width: 4),
            Text(
              '$streak',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w800,
                color: Colors.orange.shade800,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
