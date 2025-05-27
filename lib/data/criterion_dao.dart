class CriterionDao {
  static const String _criterion = 'criterion';
  static const String _id = 'id';
  static const String _name = 'name';
  static const String _description = 'description';

  static const String tableSql =
      'CREATE TABLE $_criterion('
      '$_id INT PRIMARY KEY, '
      '$_name TEXT NOT NULL, '
      '$_description  TEXT NOT NULL UNIQUE, '
      ');';
}
