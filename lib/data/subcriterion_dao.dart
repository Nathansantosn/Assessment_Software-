class SubcriterionDao {
  static const String _subcriterion = 'subcriterion';
  static const String _id = 'id';
  static const String _name = 'name';
  static const String _description = 'description';

  static const String tableSql =
      'CREATE TABLE $_subcriterion('
      '$_id INT PRIMARY KEY, '
      '$_name TEXT NOT NULL, '
      '$_description  TEXT NOT NULL UNIQUE, '
      ');';
}
