class BadgeModel {
  final String id;
  final String emoji;
  final String title;
  final String description;
  final bool Function(int totalSolved, double averageScore, int streakDays,
      int totalCases) condition;

  const BadgeModel({
    required this.id,
    required this.emoji,
    required this.title,
    required this.description,
    required this.condition,
  });
}

class AppBadges {
  static final List<BadgeModel> all = [
    BadgeModel(
      id: 'ilk_adim',
      emoji: '🥉',
      title: 'İlk Adım',
      description: 'İlk vakayı tamamladı.',
      condition: (solved, avg, streak, total) => solved >= 1,
    ),
    BadgeModel(
      id: 'iletisim_uzmani',
      emoji: '🥈',
      title: 'İletişim Uzmanı',
      description: '10 vakayı tamamladı.',
      condition: (solved, avg, streak, total) => solved >= 10,
    ),
    BadgeModel(
      id: 'saha_profesyoneli',
      emoji: '🥇',
      title: 'Saha Profesyoneli',
      description: 'Ortalama 90 puanın üzerine çıktı.',
      condition: (solved, avg, streak, total) => avg >= 90,
    ),
    BadgeModel(
      id: 'yedi_gunluk_seri',
      emoji: '🔥',
      title: '7 Günlük Seri',
      description: '7 gün üst üste eğitim yaptı.',
      condition: (solved, avg, streak, total) => streak >= 7,
    ),
    BadgeModel(
      id: 'usta_kurye',
      emoji: '🏆',
      title: 'Usta Kurye',
      description: 'Tüm vakaları tamamladı.',
      condition: (solved, avg, streak, total) => total > 0 && solved >= total,
    ),
  ];
}
