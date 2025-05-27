class Question {
  final int id;
  final int systemId;
  final int criterionId;
  final int subCriterion;
  final String texto;

  Question({
    required this.id,
    required this.systemId,
    required this.criterionId,
    required this.subCriterion,
    required this.texto,
  });
}
