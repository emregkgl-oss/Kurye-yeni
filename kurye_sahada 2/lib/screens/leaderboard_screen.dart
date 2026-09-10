import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/app_providers.dart';
import '../theme/app_theme.dart';

/// NOT: Bu ekran şu an DEMO/local veriyle çalışır.
/// İleride Firebase/Supabase entegrasyonu için:
/// bu widget'ı bir ILeaderboardProvider arkasında yeniden kurgulayıp
/// gerçek zamanlı kullanıcı verisiyle değiştirebilirsiniz.
class LeaderboardScreen extends ConsumerWidget {
  const LeaderboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final progress = ref.watch(progressProvider);

    final demoEntries = <_LeaderboardEntry>[
      const _LeaderboardEntry('Ahmet K.', 950, '🥇'),
      const _LeaderboardEntry('Elif T.', 920, '🥈'),
      const _LeaderboardEntry('Mert Y.', 890, '🥉'),
      const _LeaderboardEntry('Sena D.', 840, ''),
      const _LeaderboardEntry('Burak S.', 810, ''),
    ];

    final myScore = (progress.averageScore * progress.totalCasesSolved).round();

    return Scaffold(
      appBar: AppBar(
          title: const Text('Liderlik Tablosu',
              style: TextStyle(fontWeight: FontWeight.w800))),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            const Card(
              color: AppColors.lightGreen,
              child: Padding(
                padding: EdgeInsets.all(14),
                child: Text(
                  'Bu tablo şu an demo verilerle gösteriliyor. Gerçek kullanıcı '
                  'sıralaması yakında eklenecek.',
                  style: TextStyle(fontSize: 12.5, color: AppColors.textDark),
                ),
              ),
            ),
            const SizedBox(height: 16),
            ...demoEntries.map((e) => Card(
                  child: ListTile(
                    leading: Text(e.medal.isEmpty ? '•' : e.medal,
                        style: const TextStyle(fontSize: 20)),
                    title: Text(e.name,
                        style: const TextStyle(fontWeight: FontWeight.w700)),
                    trailing: Text('${e.score} Puan',
                        style: const TextStyle(
                            fontWeight: FontWeight.w700,
                            color: AppColors.primaryGreen)),
                  ),
                )),
            const SizedBox(height: 10),
            Card(
              color: AppColors.darkGreen,
              child: ListTile(
                leading: const Icon(Icons.person, color: Colors.white),
                title: const Text('Sen',
                    style: TextStyle(
                        fontWeight: FontWeight.w700, color: Colors.white)),
                trailing: Text('$myScore Puan',
                    style: const TextStyle(
                        fontWeight: FontWeight.w700, color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LeaderboardEntry {
  final String name;
  final int score;
  final String medal;

  const _LeaderboardEntry(this.name, this.score, this.medal);
}
