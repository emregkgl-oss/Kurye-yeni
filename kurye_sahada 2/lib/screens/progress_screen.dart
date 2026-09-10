import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/app_providers.dart';
import '../theme/app_theme.dart';

class ProgressScreen extends ConsumerWidget {
  const ProgressScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final progress = ref.watch(progressProvider);
    final attempts = progress.attempts;

    return Scaffold(
      appBar: AppBar(
          title: const Text('Gelişimim',
              style: TextStyle(fontWeight: FontWeight.w800))),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 1.5,
              children: [
                _StatCard(
                    emoji: '📊',
                    label: 'Toplam Çözülen Vaka',
                    value: '${progress.totalCasesSolved}'),
                _StatCard(
                    emoji: '⭐',
                    label: 'Ortalama Puan',
                    value: progress.averageScore.toStringAsFixed(1)),
                _StatCard(
                    emoji: '🔥',
                    label: 'Arka Arkaya Eğitim Günü',
                    value: '${progress.currentStreakDays}'),
                _StatCard(
                    emoji: '🏆',
                    label: 'En Yüksek Puan',
                    value: '${progress.highestScore}'),
              ],
            ),
            const SizedBox(height: 24),
            const Text('📈 Gelişim Grafiği',
                style: TextStyle(fontWeight: FontWeight.w800, fontSize: 15)),
            const SizedBox(height: 12),
            Card(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(8, 20, 20, 12),
                child: SizedBox(
                  height: 220,
                  child: attempts.isEmpty
                      ? const Center(
                          child: Text('Henüz veri yok. İlk vakanı çöz!',
                              style: TextStyle(color: AppColors.textGray)),
                        )
                      : LineChart(
                          LineChartData(
                            minY: 0,
                            maxY: 100,
                            gridData: const FlGridData(show: true),
                            titlesData: const FlTitlesData(
                              rightTitles: AxisTitles(
                                  sideTitles: SideTitles(showTitles: false)),
                              topTitles: AxisTitles(
                                  sideTitles: SideTitles(showTitles: false)),
                            ),
                            borderData: FlBorderData(show: false),
                            lineBarsData: [
                              LineChartBarData(
                                isCurved: true,
                                color: AppColors.primaryGreen,
                                barWidth: 3,
                                dotData: const FlDotData(show: true),
                                spots: [
                                  for (int i = 0; i < attempts.length; i++)
                                    FlSpot(i.toDouble(),
                                        attempts[i].totalScore.toDouble()),
                                ],
                              ),
                            ],
                          ),
                        ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String emoji;
  final String label;
  final String value;

  const _StatCard(
      {required this.emoji, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(emoji, style: const TextStyle(fontSize: 22)),
            const SizedBox(height: 6),
            Text(value,
                style: const TextStyle(
                    fontSize: 20, fontWeight: FontWeight.w800)),
            Text(label,
                style: const TextStyle(
                    fontSize: 11.5, color: AppColors.textGray)),
          ],
        ),
      ),
    );
  }
}
