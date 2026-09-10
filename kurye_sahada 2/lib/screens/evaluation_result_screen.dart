import 'package:flutter/material.dart';

import '../models/badge_model.dart';
import '../models/case_model.dart';
import '../models/evaluation_result.dart';
import '../theme/app_theme.dart';
import '../widgets/score_bar.dart';

class EvaluationResultScreen extends StatelessWidget {
  final CaseModel caseModel;
  final EvaluationResult result;
  final List<BadgeModel> newlyUnlockedBadges;

  const EvaluationResultScreen({
    super.key,
    required this.caseModel,
    required this.result,
    this.newlyUnlockedBadges = const [],
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Değerlendirme Sonucu')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Center(
              child: Column(
                children: [
                  Text('${result.totalScore}',
                      style: const TextStyle(
                          fontSize: 48,
                          fontWeight: FontWeight.w900,
                          color: AppColors.primaryGreen)),
                  const Text('TOPLAM PUAN / 100',
                      style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textGray)),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(18),
                child: Column(
                  children: [
                    ScoreBar(
                        emoji: '🗣️',
                        label: 'İletişim',
                        score: result.communicationScore),
                    ScoreBar(
                        emoji: '❤️', label: 'Empati', score: result.empathyScore),
                    ScoreBar(
                        emoji: '🧠',
                        label: 'Problem Çözme',
                        score: result.problemSolvingScore),
                    ScoreBar(
                        emoji: '⭐',
                        label: 'Profesyonellik',
                        score: result.professionalismScore),
                    ScoreBar(
                        emoji: '📋',
                        label: 'Prosedüre Uygunluk',
                        score: result.procedureScore),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 18),
            const Text('🤖 Değerlendirme',
                style: TextStyle(fontWeight: FontWeight.w800, fontSize: 14)),
            const SizedBox(height: 8),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Text(result.feedback,
                    style: const TextStyle(fontSize: 14, height: 1.5)),
              ),
            ),
            const SizedBox(height: 18),
            const Text('✅ ÖNERİLEN YAKLAŞIM',
                style: TextStyle(fontWeight: FontWeight.w800, fontSize: 14)),
            const SizedBox(height: 8),
            Card(
              color: AppColors.lightGreen,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Text(caseModel.recommendedAnswer,
                    style: const TextStyle(fontSize: 14, height: 1.5)),
              ),
            ),
            if (newlyUnlockedBadges.isNotEmpty) ...[
              const SizedBox(height: 18),
              const Text('🎉 Yeni Rozet Kazandınız!',
                  style: TextStyle(fontWeight: FontWeight.w800, fontSize: 14)),
              const SizedBox(height: 8),
              ...newlyUnlockedBadges.map((b) => Card(
                    child: ListTile(
                      leading: Text(b.emoji, style: const TextStyle(fontSize: 26)),
                      title: Text(b.title,
                          style: const TextStyle(fontWeight: FontWeight.w700)),
                      subtitle: Text(b.description),
                    ),
                  )),
            ],
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).popUntil((route) => route.isFirst);
                },
                child: const Text('ANA SAYFAYA DÖN'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
