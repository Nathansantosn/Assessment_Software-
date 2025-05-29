class SubCriterion {
  final String id;
  final String systemId;
  final String name;
  final String description;
  final double weight;
  final DateTime createdAt;
  final DateTime updatedAt;

  SubCriterion({
    required this.id,
    required this.systemId,
    required this.name,
    required this.description,
    required this.weight,
    required this.createdAt,
    required this.updatedAt,
  });
}
