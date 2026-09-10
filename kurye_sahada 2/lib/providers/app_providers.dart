import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/case_model.dart';
import '../models/user_progress.dart';
import '../repositories/progress_repository.dart';
import '../services/badge_service.dart';
import '../services/case_service.dart';
import '../services/evaluation/demo_keyword_engine.dart';
import '../services/evaluation/evaluation_engine.dart';

// --- Servisler / Repository'ler (singleton) ---

final caseServiceProvider = Provider<CaseService>((ref) => CaseService());

final progressRepositoryProvider = Provider<ProgressRepository>((ref) {
  throw UnimplementedError(
      'progressRepositoryProvider main.dart içinde override edilmeli (init sonrası)');
});

final badgeServiceProvider = Provider<BadgeService>((ref) {
  return BadgeService(ref.watch(progressRepositoryProvider));
});

/// Değerlendirme motoru — ileride RemoteAIEvaluationEngine ile
/// değiştirilecek tek satır.
final evaluationEngineProvider = Provider<EvaluationEngine>((ref) {
  return DemoKeywordEvaluationEngine();
});

// --- Veri (async) provider'lar ---

final allCasesProvider = FutureProvider<List<CaseModel>>((ref) async {
  final service = ref.watch(caseServiceProvider);
  return service.loadCases();
});

final caseOfTheDayProvider = FutureProvider<CaseModel>((ref) async {
  final service = ref.watch(caseServiceProvider);
  return service.caseOfTheDay();
});

final selectedCategoryProvider = StateProvider<String>((ref) => 'Tümü');

// --- İlerleme state'i (değiştikçe UI'ı günceller) ---

class ProgressNotifier extends StateNotifier<UserProgress> {
  final ProgressRepository repository;

  ProgressNotifier(this.repository) : super(repository.getProgress());

  void refresh() {
    state = repository.getProgress();
  }

  Future<void> addAttempt(CaseAttempt attempt) async {
    state = await repository.addAttempt(attempt);
  }
}

final progressProvider =
    StateNotifierProvider<ProgressNotifier, UserProgress>((ref) {
  return ProgressNotifier(ref.watch(progressRepositoryProvider));
});
