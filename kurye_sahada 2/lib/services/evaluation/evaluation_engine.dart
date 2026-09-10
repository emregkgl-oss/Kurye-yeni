import '../../models/case_model.dart';
import '../../models/evaluation_result.dart';

/// Cevap değerlendirme motorlarının uyması gereken ortak arayüz.
///
/// Bugün: [DemoKeywordEvaluationEngine] anahtar kelime bazlı çalışır.
/// Yarın: RemoteAIEvaluationEngine adında yeni bir sınıf yazıp bu arayüzü
/// implemente ederek, uygulamanın geri kalanını DEĞİŞTİRMEDEN gerçek bir
/// AI API'sine (kendi backend proxy'niz üzerinden, API key istemcide
/// olmadan) bağlanabilirsiniz.
abstract class EvaluationEngine {
  Future<EvaluationResult> evaluate({
    required CaseModel caseModel,
    required String userAnswer,
  });
}
