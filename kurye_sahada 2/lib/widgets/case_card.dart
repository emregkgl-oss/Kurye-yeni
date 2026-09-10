import 'package:flutter/material.dart';

import '../models/case_model.dart';
import '../theme/app_theme.dart';

class CaseCard extends StatelessWidget {
  final CaseModel caseModel;
  final bool solved;
  final VoidCallback onTap;

  const CaseCard({
    super.key,
    required this.caseModel,
    required this.onTap,
    this.solved = false,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: AppColors.lightGreen,
                  borderRadius: BorderRadius.circular(12),
                ),
                alignment: Alignment.center,
                child: Text(
                  CaseCategories.emojiFor(caseModel.category),
                  style: const TextStyle(fontSize: 22),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      caseModel.title,
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 15,
                        color: AppColors.textDark,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      caseModel.category,
                      style: const TextStyle(
                        fontSize: 12.5,
                        color: AppColors.textGray,
                      ),
                    ),
                  ],
                ),
              ),
              if (solved)
                const Icon(Icons.check_circle, color: AppColors.primaryGreen)
              else
                const Icon(Icons.chevron_right, color: AppColors.textGray),
            ],
          ),
        ),
      ),
    );
  }
}
