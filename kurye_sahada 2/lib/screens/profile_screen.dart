import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/app_providers.dart';
import '../theme/app_theme.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final progress = ref.watch(progressProvider);

    return Scaffold(
      appBar: AppBar(
          title:
              const Text('Profil', style: TextStyle(fontWeight: FontWeight.w800))),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            const CircleAvatar(
              radius: 40,
              backgroundColor: AppColors.lightGreen,
              child: Icon(Icons.local_shipping,
                  size: 38, color: AppColors.primaryGreen),
            ),
            const SizedBox(height: 12),
            const Center(
              child: Text('Saha Kuryesi',
                  style: TextStyle(fontWeight: FontWeight.w800, fontSize: 17)),
            ),
            const SizedBox(height: 24),
            Card(
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.check_circle_outline,
                        color: AppColors.primaryGreen),
                    title: const Text('Tamamlanan Vaka'),
                    trailing: Text('${progress.totalCasesSolved}',
                        style: const TextStyle(fontWeight: FontWeight.w700)),
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.star_outline,
                        color: AppColors.primaryGreen),
                    title: const Text('Ortalama Puan'),
                    trailing: Text(progress.averageScore.toStringAsFixed(1),
                        style: const TextStyle(fontWeight: FontWeight.w700)),
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.emoji_events_outlined,
                        color: AppColors.primaryGreen),
                    title: const Text('Kazanılan Rozet'),
                    trailing: Text('${progress.unlockedBadgeIds.length}',
                        style: const TextStyle(fontWeight: FontWeight.w700)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Card(
              child: ListTile(
                leading: const Icon(Icons.info_outline),
                title: const Text('Uygulama Hakkında'),
                subtitle: const Text(
                    'Kurye Sahada v1.0.0 — Saha iletişim ve vaka eğitim uygulaması'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
