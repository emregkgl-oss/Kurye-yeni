import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/case_model.dart';
import '../providers/app_providers.dart';
import '../theme/app_theme.dart';
import '../widgets/case_card.dart';
import 'case_detail_screen.dart';

class CaseListScreen extends ConsumerWidget {
  const CaseListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final casesAsync = ref.watch(allCasesProvider);
    final selectedCategory = ref.watch(selectedCategoryProvider);
    final progress = ref.watch(progressProvider);

    final categories = ['Tümü', ...CaseCategories.all];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Vakalar', style: TextStyle(fontWeight: FontWeight.w800)),
      ),
      body: Column(
        children: [
          SizedBox(
            height: 44,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: categories.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (context, index) {
                final cat = categories[index];
                final selected = cat == selectedCategory;
                return ChoiceChip(
                  label: Text(
                    cat == 'Tümü' ? 'Tümü' : '${CaseCategories.emojiFor(cat)} $cat',
                    style: const TextStyle(fontSize: 12.5),
                  ),
                  selected: selected,
                  selectedColor: AppColors.primaryGreen,
                  labelStyle: TextStyle(
                    color: selected ? Colors.white : AppColors.textDark,
                    fontWeight: FontWeight.w600,
                  ),
                  backgroundColor: Colors.white,
                  onSelected: (_) {
                    ref.read(selectedCategoryProvider.notifier).state = cat;
                  },
                );
              },
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: casesAsync.when(
              data: (allCases) {
                final filtered = selectedCategory == 'Tümü'
                    ? allCases
                    : allCases
                        .where((c) => c.category == selectedCategory)
                        .toList();

                if (filtered.isEmpty) {
                  return const Center(child: Text('Bu kategoride vaka yok.'));
                }

                return ListView.separated(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
                  itemCount: filtered.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 10),
                  itemBuilder: (context, index) {
                    final c = filtered[index];
                    final solved = progress.solvedCaseIds.contains(c.id);
                    return CaseCard(
                      caseModel: c,
                      solved: solved,
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (_) => CaseDetailScreen(caseId: c.id),
                        ));
                      },
                    );
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, st) => Center(child: Text('Hata: $e')),
            ),
          ),
        ],
      ),
    );
  }
}
