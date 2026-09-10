import 'package:hive_flutter/hive_flutter.dart';

import '../models/user_progress.dart';

class ProgressRepository {
  static const String boxName = 'progress_box';
  static const String progressKey = 'user_progress';

  Box? _box;

  Future<void> init() async {
    _box = await Hive.openBox(boxName);
  }

  Box get _requireBox {
    final box = _box;
    if (box == null) {
      throw StateError('ProgressRepository.init() önce çağrılmalı');
    }
    return box;
  }

  UserProgress getProgress() {
    final raw = _requireBox.get(progressKey);
    if (raw == null) return const UserProgress();
    return UserProgress.fromMap(Map<dynamic, dynamic>.from(raw as Map));
  }

  Future<void> saveProgress(UserProgress progress) async {
    await _requireBox.put(progressKey, progress.toMap());
  }

  Future<UserProgress> addAttempt(CaseAttempt attempt) async {
    final current = getProgress();
    final newAttempts = [...current.attempts, attempt];

    final newStreak = _computeStreak(
      previousDate: current.lastTrainingDate,
      previousStreak: current.currentStreakDays,
      newDate: attempt.completedAt,
    );

    final updated = current.copyWith(
      attempts: newAttempts,
      currentStreakDays: newStreak,
      lastTrainingDate: attempt.completedAt,
    );

    await saveProgress(updated);
    return updated;
  }

  Future<UserProgress> unlockBadge(String badgeId) async {
    final current = getProgress();
    if (current.unlockedBadgeIds.contains(badgeId)) return current;
    final updated = current.copyWith(
      unlockedBadgeIds: [...current.unlockedBadgeIds, badgeId],
    );
    await saveProgress(updated);
    return updated;
  }

  int _computeStreak({
    required DateTime? previousDate,
    required int previousStreak,
    required DateTime newDate,
  }) {
    if (previousDate == null) return 1;

    final prevDay =
        DateTime(previousDate.year, previousDate.month, previousDate.day);
    final newDay = DateTime(newDate.year, newDate.month, newDate.day);
    final diff = newDay.difference(prevDay).inDays;

    if (diff == 0) return previousStreak == 0 ? 1 : previousStreak; // aynı gün
    if (diff == 1) return previousStreak + 1; // ardışık gün
    return 1; // seri bozuldu
  }
}
