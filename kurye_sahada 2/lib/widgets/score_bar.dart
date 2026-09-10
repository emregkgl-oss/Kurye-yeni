import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

class ScoreBar extends StatelessWidget {
  final String emoji;
  final String label;
  final int score; // 0-100

  const ScoreBar({
    super.key,
    required this.emoji,
    required this.label,
    required this.score,
  });

  Color get _color {
    if (score >= 85) return AppColors.primaryGreen;
    if (score >= 65) return AppColors.warning;
    return AppColors.danger;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('$emoji  $label',
                  style: const TextStyle(
                      fontSize: 14, fontWeight: FontWeight.w600)),
              Text('$score/100',
                  style: TextStyle(
                      fontSize: 14, fontWeight: FontWeight.w700, color: _color)),
            ],
          ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: score / 100,
              minHeight: 8,
              backgroundColor: const Color(0xFFECEEF1),
              valueColor: AlwaysStoppedAnimation(_color),
            ),
          ),
        ],
      ),
    );
  }
}
