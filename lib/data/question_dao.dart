class QuestionDao {
  static const String _questionDao = 'questionDao';
  static const String _id = 'id';
  static const String _systemId = 'systemId';
  static const String _criterionId = 'criterionId';
  static const String _subcriterion = 'subCriterion';
  static const String _texto = 'texto';

  static const String tableSql =
      'CREATE TABLE $_questionDao('
      '$_id INT PRIMARY KEY, '
      '$_systemId INT  NULL, '
      '$_criterionId  INT NOT NULL UNIQUE, '
      '$_subcriterion  INT NOT NULL UNIQUE, '
      '$_texto TEXT NOT NULL,'
      ');';
}
