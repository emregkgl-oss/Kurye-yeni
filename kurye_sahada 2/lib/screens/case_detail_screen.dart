import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/case_model.dart';
import '../models/evaluation_result.dart';
import '../models/user_progress.dart';
import '../providers/app_providers.dart';
import '../theme/app_theme.dart';
import 'evaluation_result_screen.dart';

class CaseDetailScreen extends ConsumerStatefulWidget {
  final int caseId;

  const CaseDetailScreen({super.key, required this.caseId});

  @override
  ConsumerState<CaseDetailScreen> createState() => _CaseDetailScreenState();
}

class _CaseDetailScreenState extends ConsumerState<CaseDetailScreen> {
  final TextEditingController _controller = TextEditingController();
  bool _submitting = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _submit(CaseModel caseModel) async {
    if (_controller.text.trim().length < 10) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Lütfen daha detaylı bir cevap yazın.')),
      );
      return;
    }

    setState(() => _submitting = true);

    final engine = ref.read(evaluationEngineProvider);
    final EvaluationResult result = await engine.evaluate(
      caseModel: caseModel,
      userAnswer: _controller.text.trim(),
    );

    await ref.read(progressProvider.notifier).addAttempt(
          CaseAttempt(
            caseId: caseModel.id,
            totalScore: result.totalScore,
            completedAt: DateTime.now(),
          ),
        );

    final allCases = await ref.read(caseServiceProvider).loadCases();
    final newBadges = await ref.read(badgeServiceProvider).evaluateAndUnlock(
          progress: ref.read(progressProvider),
          totalCaseCount: allCases.length,
        );

    if (!mounted) return;
    setState(() => _submitting = false);

    Navigator.of(context).pushReplacement(MaterialPageRoute(
      builder: (_) => EvaluationResultScreen(
        caseModel: caseModel,
        result: result,
        newlyUnlockedBadges: newBadges,
      ),
    ));
  }

  @override
  Widget build(BuildContext context) {
    final casesAsync = ref.watch(allCasesProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Saha Vakası')),
      body: casesAsync.when(
        data: (cases) {
          final caseModel = cases.firstWhere((c) => c.id == widget.caseId);
          return SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '📍 SAHA VAKASI #${caseModel.id.toString().padLeft(2, '0')}',
                    style: const TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 15,
                        color: AppColors.primaryGreen),
                  ),
                  const SizedBox(height: 4),
                  Text('Kategori: ${caseModel.category}',
                      style: const TextStyle(
                          fontSize: 13, color: AppColors.textGray)),
                  const SizedBox(height: 18),
                  const Text('OLAY',
                      style: TextStyle(
                          fontWeight: FontWeight.w800, fontSize: 13)),
                  const SizedBox(height: 8),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(caseModel.scenario,
                              style: const TextStyle(fontSize: 14.5, height: 1.5)),
                          const SizedBox(height: 12),
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: AppColors.lightGreen,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              '"${caseModel.customerDialogue}"',
                              style: const TextStyle(
                                  fontStyle: FontStyle.italic, fontSize: 14),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(caseModel.question,
                      style: const TextStyle(
                          fontWeight: FontWeight.w800, fontSize: 16)),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _controller,
                    maxLines: 6,
                    decoration: const InputDecoration(
                      hintText:
                          'Bu durumda nasıl davranacağınızı ve müşteriye ne söyleyeceğinizi yazın...',
                    ),
                  ),
                  const SizedBox(height: 18),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _submitting ? null : () => _submit(caseModel),
                      child: _submitting
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                  strokeWidth: 2, color: Colors.white),
                            )
                          : const Text('CEVABIMI GÖNDER'),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, st) => Center(child: Text('Hata: $e')),
      ),
    );
  }
}
