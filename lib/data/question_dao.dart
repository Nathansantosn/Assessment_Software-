import 'package:assessment_software/data/database.dart';
import 'package:assessment_software/data/user_dao.dart';
import 'package:assessment_software/models/question.dart';
import 'package:sqflite/sqlite_api.dart';

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

save(Question question) async {}

Future<List<Question>> findAll() async {
  print('Acesssando o findAll do QuestionDao');
  final Database db = await getDatabase();
  final List<Map<String, dynamic>> result = await db.query(
    QuestionDao.tableSql,
  );
  print('Procurando no banco de dados... encontrado ${result.length} questões');
  return toList(result);
}

List<Question> toList(List<Map<String, dynamic>> MapQuestions) {
  print('Convertendo to List');
  final List<Question> questions = [];
  for (Map<String, dynamic> questionMap in MapQuestions) {
    final Question question = Question(
      id: questionMap[QuestionDao._id],
      systemId: questionMap[QuestionDao._systemId],
      criterionId: questionMap[QuestionDao._criterionId],
      subCriterion: questionMap[QuestionDao._subcriterion],
      texto: questionMap[QuestionDao._texto],
    );
    questions.add(question);
  }
  print('Lista de questões convertida com sucesso');
  return questions;
}
