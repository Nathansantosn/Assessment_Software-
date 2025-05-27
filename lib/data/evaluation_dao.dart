class EvaluationDao {
  static const String _tableName = 'evaluations'; // Nome da tabela
  static const String _id = 'id';
  static const String _systemId = 'systemId';
  static const String _questionId = 'questionId';

  // Nomes das tabelas relacionadas
  static const String _systemsTable = 'systems';
  static const String _questionsTable = 'questions';

  static const String tableSql =
      '''
    CREATE TABLE $_tableName (
      $_id INT PRIMARY KEY,
      $_systemId INT NOT NULL,
      $_questionId INT NOT NULL,
      UNIQUE($_systemId, $_questionId),  -- Garante combinação única
      FOREIGN KEY ($_systemId) REFERENCES $_systemsTable(id) ON DELETE CASCADE,
      FOREIGN KEY ($_questionId) REFERENCES $_questionsTable(id) ON DELETE CASCADE
    );
  ''';

  // Índices para melhor performance nas buscas
  static const String createSystemIdIndex =
      '''
    CREATE INDEX idx_${_tableName}_$_systemId ON $_tableName($_systemId);
  ''';

  static const String createQuestionIdIndex =
      '''
    CREATE INDEX idx_${_tableName}_$_questionId ON $_tableName($_questionId);
  ''';
}
