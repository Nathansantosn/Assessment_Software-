import 'package:assessment_software/models/system.dart';

class SystemDao {
  static const String _system = 'System';
  static const String _id = 'id';
  static const String _name = 'name';
  static const String _description = 'description';
  static const String _createdAt = 'createdAt';

  static const String tableSql =
      'CREATE TABLE $_system('
      '$_id INT PRIMARY KEY, '
      '$_name TEXT NOT NULL, '
      '$_description  TEXT NOT NULL UNIQUE, '
      '$_createdAt TEXT NOT NULL, '
      ');';
}

save(System system) async {}
