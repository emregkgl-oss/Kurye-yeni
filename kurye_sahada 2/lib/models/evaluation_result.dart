class EvaluationResult {
  final int communicationScore; // İletişim
  final int empathyScore; // Empati
  final int problemSolvingScore; // Problem Çözme
  final int professionalismScore; // Profesyonellik
  final int procedureScore; // Prosedüre Uygunluk
  final String feedback; // Yapay zeka geri bildirimi (metinsel)

  const EvaluationResult({
    required this.communicationScore,
    required this.empathyScore,
    required this.problemSolvingScore,
    required this.professionalismScore,
    required this.procedureScore,
    required this.feedback,
  });

  int get totalScore =>
      ((communicationScore +
              empathyScore +
              problemSolvingScore +
              professionalismScore +
              procedureScore) /
          5)
          .round();

  Map<String, dynamic> toJson() => {
        'communicationScore': communicationScore,
        'empathyScore': empathyScore,
        'problemSolvingScore': problemSolvingScore,
        'professionalismScore': professionalismScore,
        'procedureScore': procedureScore,
        'feedback': feedback,
      };

  factory EvaluationResult.fromJson(Map<String, dynamic> json) {
    return EvaluationResult(
      communicationScore: json['communicationScore'] as int,
      empathyScore: json['empathyScore'] as int,
      problemSolvingScore: json['problemSolvingScore'] as int,
      professionalismScore: json['professionalismScore'] as int,
      procedureScore: json['procedureScore'] as int,
      feedback: json['feedback'] as String,
    );
  }
}
