class CaseAttempt {
  final int caseId;
  final int totalScore;
  final DateTime completedAt;

  const CaseAttempt({
    required this.caseId,
    required this.totalScore,
    required this.completedAt,
  });

  Map<String, dynamic> toMap() => {
        'caseId': caseId,
        'totalScore': totalScore,
        'completedAt': completedAt.toIso8601String(),
      };

  factory CaseAttempt.fromMap(Map<dynamic, dynamic> map) => CaseAttempt(
        caseId: map['caseId'] as int,
        totalScore: map['totalScore'] as int,
        completedAt: DateTime.parse(map['completedAt'] as String),
      );
}

class UserProgress {
  final List<CaseAttempt> attempts;
  final List<String> unlockedBadgeIds;
  final int currentStreakDays;
  final DateTime? lastTrainingDate;

  const UserProgress({
    this.attempts = const [],
    this.unlockedBadgeIds = const [],
    this.currentStreakDays = 0,
    this.lastTrainingDate,
  });

  int get totalCasesSolved => attempts.length;

  double get averageScore {
    if (attempts.isEmpty) return 0;
    final sum = attempts.fold<int>(0, (acc, a) => acc + a.totalScore);
    return sum / attempts.length;
  }

  int get highestScore {
    if (attempts.isEmpty) return 0;
    return attempts.map((a) => a.totalScore).reduce((a, b) => a > b ? a : b);
  }

  Set<int> get solvedCaseIds => attempts.map((a) => a.caseId).toSet();

  Map<String, dynamic> toMap() => {
        'attempts': attempts.map((a) => a.toMap()).toList(),
        'unlockedBadgeIds': unlockedBadgeIds,
        'currentStreakDays': currentStreakDays,
        'lastTrainingDate': lastTrainingDate?.toIso8601String(),
      };

  factory UserProgress.fromMap(Map<dynamic, dynamic>? map) {
    if (map == null) return const UserProgress();
    return UserProgress(
      attempts: (map['attempts'] as List? ?? [])
          .map((e) => CaseAttempt.fromMap(e as Map))
          .toList(),
      unlockedBadgeIds:
          (map['unlockedBadgeIds'] as List? ?? []).map((e) => e.toString()).toList(),
      currentStreakDays: map['currentStreakDays'] as int? ?? 0,
      lastTrainingDate: map['lastTrainingDate'] != null
          ? DateTime.parse(map['lastTrainingDate'] as String)
          : null,
    );
  }

  UserProgress copyWith({
    List<CaseAttempt>? attempts,
    List<String>? unlockedBadgeIds,
    int? currentStreakDays,
    DateTime? lastTrainingDate,
  }) {
    return UserProgress(
      attempts: attempts ?? this.attempts,
      unlockedBadgeIds: unlockedBadgeIds ?? this.unlockedBadgeIds,
      currentStreakDays: currentStreakDays ?? this.currentStreakDays,
      lastTrainingDate: lastTrainingDate ?? this.lastTrainingDate,
    );
  }
}
