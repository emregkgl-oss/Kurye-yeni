import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/badge_model.dart';
import '../providers/app_providers.dart';
import '../widgets/badge_tile.dart';

class AchievementsScreen extends ConsumerWidget {
  const AchievementsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final progress = ref.watch(progressProvider);

    return Scaffold(
      appBar: AppBar(
          title: const Text('Başarılar',
              style: TextStyle(fontWeight: FontWeight.w800))),
      body: SafeArea(
        child: GridView.builder(
          padding: const EdgeInsets.all(20),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 14,
            crossAxisSpacing: 14,
            childAspectRatio: 0.95,
          ),
          itemCount: AppBadges.all.length,
          itemBuilder: (context, index) {
            final badge = AppBadges.all[index];
            final unlocked = progress.unlockedBadgeIds.contains(badge.id);
            return BadgeTile(badge: badge, unlocked: unlocked);
          },
        ),
      ),
    );
  }
}
