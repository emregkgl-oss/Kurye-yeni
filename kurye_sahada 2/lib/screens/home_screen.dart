import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/case_model.dart';
import '../providers/app_providers.dart';
import '../theme/app_theme.dart';
import 'case_detail_screen.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final caseOfDay = ref.watch(caseOfTheDayProvider);
    final progress = ref.watch(progressProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Kurye Sahada',
            style: TextStyle(fontWeight: FontWeight.w800)),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            const Text('Merhaba! 👋',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800)),
            const SizedBox(height: 6),
            const Text(
              'Bugün sahada karşılaşabileceğin durumlara hazır mısın?',
              style: TextStyle(fontSize: 14, color: AppColors.textGray),
            ),
            const SizedBox(height: 20),

            // Kısa istatistik şeridi
            Row(
              children: [
                _StatChip(
                    label: 'Çözülen',
                    value: '${progress.totalCasesSolved}'),
                const SizedBox(width: 10),
                _StatChip(
                    label: 'Ortalama',
                    value: progress.averageScore.toStringAsFixed(0)),
                const SizedBox(width: 10),
                _StatChip(label: 'Seri', value: '${progress.currentStreakDays} 🔥'),
              ],
            ),

            const SizedBox(height: 24),
            const Text('📍 GÜNÜN SAHA VAKASI',
                style: TextStyle(fontWeight: FontWeight.w800, fontSize: 15)),
            const SizedBox(height: 10),

            caseOfDay.when(
              data: (c) => _CaseOfDayCard(caseModel: c),
              loading: () => const Padding(
                padding: EdgeInsets.symmetric(vertical: 40),
                child: Center(child: CircularProgressIndicator()),
              ),
              error: (e, st) => Text('Vaka yüklenemedi: $e'),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatChip extends StatelessWidget {
  final String label;
  final String value;

  const _StatChip({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 14),
          child: Column(
            children: [
              Text(value,
                  style: const TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 16,
                      color: AppColors.primaryGreen)),
              const SizedBox(height: 2),
              Text(label,
                  style: const TextStyle(
                      fontSize: 11.5, color: AppColors.textGray)),
            ],
          ),
        ),
      ),
    );
  }
}

class _CaseOfDayCard extends StatelessWidget {
  final CaseModel caseModel;

  const _CaseOfDayCard({required this.caseModel});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.darkGreen,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${CaseCategories.emojiFor(caseModel.category)}  ${caseModel.category}',
              style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 12.5,
                  fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 10),
            Text(
              caseModel.scenario,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 15.5,
                  height: 1.4,
                  fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 8),
            Text(
              '"${caseModel.customerDialogue}"',
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14.5,
                  fontStyle: FontStyle.italic),
            ),
            const SizedBox(height: 18),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: AppColors.darkGreen,
                ),
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (_) => CaseDetailScreen(caseId: caseModel.id),
                  ));
                },
                child: const Text('VAKAYI ÇÖZ →'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
