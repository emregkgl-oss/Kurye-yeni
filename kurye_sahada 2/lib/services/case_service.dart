import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

import '../models/case_model.dart';

class CaseService {
  List<CaseModel>? _cache;

  Future<List<CaseModel>> loadCases() async {
    if (_cache != null) return _cache!;
    final raw = await rootBundle.loadString('assets/cases.json');
    final List<dynamic> jsonList = json.decode(raw) as List<dynamic>;
    _cache = jsonList
        .map((e) => CaseModel.fromJson(e as Map<String, dynamic>))
        .toList();
    return _cache!;
  }

  Future<CaseModel> getById(int id) async {
    final cases = await loadCases();
    return cases.firstWhere((c) => c.id == id);
  }

  Future<List<CaseModel>> byCategory(String category) async {
    final cases = await loadCases();
    if (category == 'Tümü') return cases;
    return cases.where((c) => c.category == category).toList();
  }

  /// "Günün vakası" — basit ve deterministik: gün numarasına göre seçilir.
  Future<CaseModel> caseOfTheDay() async {
    final cases = await loadCases();
    final dayIndex = DateTime.now().day % cases.length;
    return cases[dayIndex];
  }
}
