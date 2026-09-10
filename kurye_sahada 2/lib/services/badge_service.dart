import '../models/badge_model.dart';
import '../models/user_progress.dart';
import '../repositories/progress_repository.dart';

class BadgeService {
  final ProgressRepository progressRepository;

  BadgeService(this.progressRepository);

  /// Mevcut ilerlemeye göre yeni açılmış rozetleri hesaplar,
  /// repository'e kaydeder ve YENİ açılan rozetleri döndürür.
  Future<List<BadgeModel>> evaluateAndUnlock({
    required UserProgress progress,
    required int totalCaseCount,
  }) async {
    final newlyUnlocked = <BadgeModel>[];

    for (final badge in AppBadges.all) {
      final alreadyUnlocked = progress.unlockedBadgeIds.contains(badge.id);
      if (alreadyUnlocked) continue;

      final earned = badge.condition(
        progress.totalCasesSolved,
        progress.averageScore,
        progress.currentStreakDays,
        totalCaseCount,
      );

      if (earned) {
        await progressRepository.unlockBadge(badge.id);
        newlyUnlocked.add(badge);
      }
    }

    return newlyUnlocked;
  }
}
