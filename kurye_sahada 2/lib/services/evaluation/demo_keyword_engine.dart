import 'dart:math';

import '../../models/case_model.dart';
import '../../models/evaluation_result.dart';
import 'evaluation_engine.dart';

/// İlk versiyon: gerçek bir AI çağrısı yapmaz.
/// Kullanıcının cevabını, vakanın anahtar kelimeleriyle ve
/// bazı basit sezgisel kurallarla (uzunluk, ton, empati ifadeleri)
/// karşılaştırarak örnek bir puan ve geri bildirim üretir.
class DemoKeywordEvaluationEngine implements EvaluationEngine {
  final Random _random = Random();

  static const List<String> _empatiKelimeleri = [
    'anlıyorum',
    'üzgünüm',
    'özür',
    'haklısınız',
    'anlarım',
    'farkındayım',
  ];

  static const List<String> _profesyonellikKelimeleri = [
    'sakin',
    'nazikçe',
    'profesyonel',
    'saygı',
    'yardımcı olurum',
  ];

  static const List<String> _prosedurKelimeleri = [
    'prosedür',
    'kural',
    'şirket',
    'sistem',
    'bildiririm',
    'yönlendiririm',
    'destek',
  ];

  static const List<String> _agresifKelimeler = [
    'salla',
    'umurumda değil',
    'bilmiyorum işte',
    'kapatıyorum',
  ];

  @override
  Future<EvaluationResult> evaluate({
    required CaseModel caseModel,
    required String userAnswer,
  }) async {
    // Gerçek bir ağ çağrısı hissi vermek için küçük bir gecikme.
    await Future.delayed(const Duration(milliseconds: 600));

    final normalized = userAnswer.toLowerCase();
    final lengthScore = _lengthScore(normalized);

    final keywordHits = caseModel.keywords
        .where((k) => normalized.contains(k.toLowerCase()))
        .length;
    final keywordRatio = caseModel.keywords.isEmpty
        ? 0.0
        : keywordHits / caseModel.keywords.length;

    final empatiHit = _countHits(normalized, _empatiKelimeleri);
    final profesyonellikHit = _countHits(normalized, _profesyonellikKelimeleri);
    final prosedurHit = _countHits(normalized, _prosedurKelimeleri);
    final agresifHit = _countHits(normalized, _agresifKelimeler);

    int communication = _clampScore(
        55 + (lengthScore * 20) + (keywordRatio * 20) - (agresifHit * 15));
    int empathy = _clampScore(50 + (empatiHit * 18) + (keywordRatio * 15));
    int problemSolving =
        _clampScore(50 + (keywordRatio * 30) + (lengthScore * 15));
    int professionalism = _clampScore(
        60 + (profesyonellikHit * 15) - (agresifHit * 25) + (lengthScore * 10));
    int procedure = _clampScore(50 + (prosedurHit * 20) + (keywordRatio * 20));

    // Küçük bir doğal varyasyon ekle (hep aynı sayı hissi olmasın)
    communication = _jitter(communication);
    empathy = _jitter(empathy);
    problemSolving = _jitter(problemSolving);
    professionalism = _jitter(professionalism);
    procedure = _jitter(procedure);

    final feedback = _buildFeedback(
      communication: communication,
      empathy: empathy,
      problemSolving: problemSolving,
      professionalism: professionalism,
      procedure: procedure,
    );

    return EvaluationResult(
      communicationScore: communication,
      empathyScore: empathy,
      problemSolvingScore: problemSolving,
      professionalismScore: professionalism,
      procedureScore: procedure,
      feedback: feedback,
    );
  }

  double _lengthScore(String text) {
    final wordCount = text.trim().split(RegExp(r'\s+')).length;
    if (wordCount < 5) return 0.1;
    if (wordCount < 15) return 0.5;
    if (wordCount < 40) return 1.0;
    return 0.8; // çok uzun cevaplar da hafif düşürülür
  }

  int _countHits(String text, List<String> words) {
    return words.where((w) => text.contains(w)).length;
  }

  int _clampScore(num value) => value.round().clamp(35, 100);

  int _jitter(int score) {
    final delta = _random.nextInt(7) - 3; // -3..+3
    return (score + delta).clamp(35, 100);
  }

  String _buildFeedback({
    required int communication,
    required int empathy,
    required int problemSolving,
    required int professionalism,
    required int procedure,
  }) {
    final buffer = StringBuffer();

    if (professionalism >= 80 && communication >= 75) {
      buffer.write(
          'Cevabınızda sakin kalmanız ve profesyonel bir dil kullanmanız oldukça doğru bir yaklaşım. ');
    } else {
      buffer.write(
          'Cevabınızda temel bir yaklaşım görülüyor, ancak dilinizi biraz daha sakin ve yapıcı hale getirebilirsiniz. ');
    }

    if (empathy < 70) {
      buffer.write(
          'Müşterinin yaşadığı sorunla ilgili daha fazla empati kurabilir, onun bakış açısını anladığınızı belirten ifadeler ekleyebilirsiniz. ');
    } else {
      buffer.write('Empati kurma konusunda iyi bir sezgi gösteriyorsunuz. ');
    }

    if (procedure < 70) {
      buffer.write(
          'Şirket prosedürlerine ve doğru yönlendirme kanallarına daha net referans vermeniz cevabı güçlendirir. ');
    }

    if (problemSolving < 70) {
      buffer.write(
          'Çözüm sürecini daha somut adımlarla (ne yapacağınızı sırayla) anlatmanız faydalı olur.');
    } else {
      buffer.write('Çözüm odaklı yaklaşımınız olumlu.');
    }

    return buffer.toString();
  }
}
