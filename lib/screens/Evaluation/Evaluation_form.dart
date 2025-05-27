import 'package:flutter/material.dart';
import '../../models/criterion.dart';
import '../../models/subcriterion.dart';
import '../../models/evaluation.dart';

class EvaluationForm extends StatefulWidget {
  final String systemId;
  final List<Criterion> criteria;
  final List<SubCriterion> subCriteria;

  const EvaluationForm({
    Key? key,
    required this.systemId,
    required this.criteria,
    required this.subCriteria,
  }) : super(key: key);

  @override
  _EvaluationFormState createState() => _EvaluationFormState();
}

class _EvaluationFormState extends State<EvaluationForm> {
  final List<EvaluationItem> _evaluationItems = [];
  final Map<String, TextEditingController> _commentControllers = {};
  final Map<String, double> _scores = {};

  @override
  void initState() {
    super.initState();
    // Inicializar itens de avaliação para cada critério e subcritério
    for (var criterion in widget.criteria) {
      _commentControllers[criterion.id] = TextEditingController();
      _scores[criterion.id] = 0;

      final subCriteria = widget.subCriteria.where(
        (sc) => sc.criterionId == criterion.id,
      );
      for (var subCriterion in subCriteria) {
        _commentControllers['${criterion.id}_${subCriterion.id}'] =
            TextEditingController();
        _scores['${criterion.id}_${subCriterion.id}'] = 0;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Nova Avaliação')),
      body: ListView.builder(
        itemCount: widget.criteria.length,
        itemBuilder: (context, criterionIndex) {
          final criterion = widget.criteria[criterionIndex];
          final subCriteria = widget.subCriteria
              .where((sc) => sc.criterionId == criterion.id)
              .toList();

          return Card(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    criterion.name,
                    style: Theme.of(context).textTheme.headline6,
                  ),
                  Text(criterion.description),
                  const SizedBox(height: 10),
                  Text('Nota:', style: Theme.of(context).textTheme.subtitle1),
                  Slider(
                    value: _scores[criterion.id] ?? 0,
                    min: 0,
                    max: 10,
                    divisions: 10,
                    label: _scores[criterion.id]?.toStringAsFixed(1),
                    onChanged: (value) {
                      setState(() {
                        _scores[criterion.id] = value;
                      });
                    },
                  ),
                  TextField(
                    controller: _commentControllers[criterion.id],
                    decoration: const InputDecoration(labelText: 'Comentários'),
                    maxLines: 2,
                  ),
                  const SizedBox(height: 10),
                  if (subCriteria.isNotEmpty)
                    Text(
                      'Subcritérios:',
                      style: Theme.of(context).textTheme.subtitle1,
                    ),
                  ...subCriteria.map((subCriterion) {
                    final key = '${criterion.id}_${subCriterion.id}';
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(subCriterion.name),
                        Text(subCriterion.description),
                        Slider(
                          value: _scores[key] ?? 0,
                          min: 0,
                          max: 10,
                          divisions: 10,
                          label: _scores[key]?.toStringAsFixed(1),
                          onChanged: (value) {
                            setState(() {
                              _scores[key] = value;
                            });
                          },
                        ),
                        TextField(
                          controller: _commentControllers[key],
                          decoration: const InputDecoration(
                            labelText: 'Comentários',
                          ),
                          maxLines: 2,
                        ),
                      ],
                    );
                  }).toList(),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _submitEvaluation,
        child: const Icon(Icons.save),
      ),
    );
  }

  void _submitEvaluation() {
    final items = <EvaluationItem>[];

    for (var criterion in widget.criteria) {
      items.add(
        EvaluationItem(
          criterionId: criterion.id,
          comments: _commentControllers[criterion.id]?.text ?? '',
          score: _scores[criterion.id] ?? 0,
        ),
      );

      final subCriteria = widget.subCriteria.where(
        (sc) => sc.criterionId == criterion.id,
      );
      for (var subCriterion in subCriteria) {
        final key = '${criterion.id}_${subCriterion.id}';
        items.add(
          EvaluationItem(
            criterionId: criterion.id,
            subCriterionId: subCriterion.id,
            comments: _commentControllers[key]?.text ?? '',
            score: _scores[key] ?? 0,
          ),
        );
      }
    }

    final totalScore = items.isNotEmpty
        ? items.map((item) => item.score).reduce((a, b) => a + b) / items.length
        : 0;

    final evaluation = Evaluation(
      id: DateTime.now().toString(),
      systemId: widget.systemId,
      testerId: 'current_user_id', // Substituir pelo ID do usuário atual
      evaluatedAt: DateTime.now(),
      items: items,
      totalScore: totalScore,
    );

    // Salvar avaliação
    Navigator.pop(context, evaluation);
  }

  @override
  void dispose() {
    for (var controller in _commentControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }
}
