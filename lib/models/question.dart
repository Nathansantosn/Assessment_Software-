class Question {
  final String id;
  final String systemId;
  final String criterionId;
  final String subCriterionId;
  final String texto;

  Question({
    required this.id,
    required this.systemId,
    required this.criterionId,
    required this.subCriterionId,
    required this.texto,
  });

  String get title => texto;
}
