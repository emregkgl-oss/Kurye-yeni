import 'package:flutter/material.dart';

import '../models/badge_model.dart';
import '../theme/app_theme.dart';

class BadgeTile extends StatelessWidget {
  final BadgeModel badge;
  final bool unlocked;

  const BadgeTile({super.key, required this.badge, required this.unlocked});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          children: [
            Opacity(
              opacity: unlocked ? 1.0 : 0.3,
              child: Text(badge.emoji, style: const TextStyle(fontSize: 36)),
            ),
            const SizedBox(height: 10),
            Text(
              badge.title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 13,
                color: unlocked ? AppColors.textDark : AppColors.textGray,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              badge.description,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 11, color: AppColors.textGray),
            ),
          ],
        ),
      ),
    );
  }
}
