import 'package:assessment_software/models/user.dart';

class UserDao {
  static const String _user = 'user';
  static const String _id = 'id';
  static const String _name = 'name';
  static const String _email = 'email';
  static const String _role = 'role';
  static const String _password = 'password';

  static const String tableSql =
      'CREATE TABLE $_user('
      '$_id INT PRIMARY KEY, '
      '$_name TEXT NOT NULL, '
      '$_email TEXT NOT NULL UNIQUE, '
      '$_role TEXT NOT NULL, '
      '$_password password TEXT NOT NULL, '
      ');';
}

save(User user) async {}
// procurar todas tarefas existentes
Future<List<User>> findAll() async {}
Future<List<User>> find(String nomeUser) async {}
Future<Null> delete(String nomeUser) async {}
  // deletar tarefa

