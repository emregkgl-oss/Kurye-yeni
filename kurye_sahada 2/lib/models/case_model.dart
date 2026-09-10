class CaseModel {
  final int id;
  final String title;
  final String category;
  final String difficulty;
  final String scenario;
  final String customerDialogue;
  final String question;
  final String recommendedAnswer;
  final List<String> keywords;

  const CaseModel({
    required this.id,
    required this.title,
    required this.category,
    required this.difficulty,
    required this.scenario,
    required this.customerDialogue,
    required this.question,
    required this.recommendedAnswer,
    required this.keywords,
  });

  factory CaseModel.fromJson(Map<String, dynamic> json) {
    return CaseModel(
      id: json['id'] as int,
      title: json['title'] as String,
      category: json['category'] as String,
      difficulty: json['difficulty'] as String,
      scenario: json['scenario'] as String,
      customerDialogue: json['customerDialogue'] as String,
      question: json['question'] as String,
      recommendedAnswer: json['recommendedAnswer'] as String,
      keywords: (json['keywords'] as List).map((e) => e.toString()).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'category': category,
      'difficulty': difficulty,
      'scenario': scenario,
      'customerDialogue': customerDialogue,
      'question': question,
      'recommendedAnswer': recommendedAnswer,
      'keywords': keywords,
    };
  }
}

/// Sabit kategori listesi (filtreleme ve ikonlar için)
class CaseCategories {
  static const String iletisim = 'Müşteri İletişimi';
  static const String zorMusteriler = 'Zor Müşteriler';
  static const String teslimat = 'Teslimat Problemleri';
  static const String adres = 'Adres Problemleri';
  static const String kriz = 'Kriz Yönetimi';
  static const String profesyonel = 'Profesyonel Davranış';
  static const String operasyon = 'Saha Operasyonları';

  static const List<String> all = [
    iletisim,
    zorMusteriler,
    teslimat,
    adres,
    kriz,
    profesyonel,
    operasyon,
  ];

  static String emojiFor(String category) {
    switch (category) {
      case iletisim:
        return '🗣️';
      case zorMusteriler:
        return '😡';
      case teslimat:
        return '📦';
      case adres:
        return '🏠';
      case kriz:
        return '⚠️';
      case profesyonel:
        return '🤝';
      case operasyon:
        return '🚚';
      default:
        return '📍';
    }
  }
}
