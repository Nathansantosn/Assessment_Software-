import 'package:assessment_software/models/question.dart';
import 'package:flutter/material.dart';
import '../../models/system.dart';
import '../../models/criterion.dart';
import '../../models/subcriterion.dart';

class QuestionFormScreen extends StatefulWidget {
  final List<System> systems;
  final List<Criterion> criteria;
  final List<SubCriterion> subCriteria;

  const QuestionFormScreen({
    Key? key,
    required this.systems,
    required this.criteria,
    required this.subCriteria,
    required String systemId,
    required Question question,
  }) : super(key: key);

  @override
  _QuestionFormScreenState createState() => _QuestionFormScreenState();
}

class _QuestionFormScreenState extends State<QuestionFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _idController = TextEditingController();
  final _analysisController = TextEditingController();
  String? _selectedSystemId;
  String? _selectedCriterionId;
  String? _selectedSubCriterionId;
  bool _isSubjective = false;

  @override
  void initState() {
    super.initState();
    _idController.text =
        'Q-${DateTime.now().millisecondsSinceEpoch.toString().substring(8)}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Nova Questão')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _idController,
                decoration: const InputDecoration(
                  labelText: 'ID da Questão',
                  border: OutlineInputBorder(),
                ),
                readOnly: true,
              ),
              const SizedBox(height: 16),

              // Seleção do Sistema
              DropdownButtonFormField<String>(
                value: _selectedSystemId,
                decoration: const InputDecoration(
                  labelText: 'Sistema',
                  border: OutlineInputBorder(),
                ),
                items: widget.systems.map((system) {
                  return DropdownMenuItem<String>(
                    value: system.id.toString(),
                    child: Text(system.name),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedSystemId = value;
                    _selectedCriterionId = null;
                    _selectedSubCriterionId = null;
                  });
                },
                validator: (value) =>
                    value == null ? 'Selecione um sistema' : null,
              ),
              const SizedBox(height: 16),

              // Seleção do Critério (só aparece depois de selecionar sistema)
              if (_selectedSystemId != null)
                DropdownButtonFormField<String>(
                  value: _selectedCriterionId,
                  decoration: const InputDecoration(
                    labelText: 'Critério',
                    border: OutlineInputBorder(),
                  ),
                  items: widget.criteria
                      .where((c) => c.systemId == _selectedSystemId)
                      .map((criterion) {
                        return DropdownMenuItem<String>(
                          value: criterion.id,
                          child: Text(criterion.name),
                        );
                      })
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedCriterionId = value;
                      _selectedSubCriterionId = null;
                    });
                  },
                  validator: (value) =>
                      value == null ? 'Selecione um critério' : null,
                ),
              if (_selectedSystemId != null) const SizedBox(height: 16),

              // Seleção do Subcritério (só aparece depois de selecionar critério)
              if (_selectedCriterionId != null)
                DropdownButtonFormField<String>(
                  value: _selectedSubCriterionId,
                  decoration: const InputDecoration(
                    labelText: 'Subcritério',
                    border: OutlineInputBorder(),
                  ),
                  items: widget.subCriteria
                      .where((sc) => sc.id == _selectedCriterionId)
                      .map((subCriterion) {
                        return DropdownMenuItem<String>(
                          value: subCriterion.id,
                          child: Text(subCriterion.name),
                        );
                      })
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedSubCriterionId = value;
                    });
                  },
                  validator: (value) =>
                      value == null ? 'Selecione um subcritério' : null,
                ),
              if (_selectedCriterionId != null) const SizedBox(height: 16),

              // Campo de texto para análise
              TextFormField(
                controller: _analysisController,
                decoration: const InputDecoration(
                  labelText: 'Texto de Análise',
                  border: OutlineInputBorder(),
                ),
                maxLines: 5,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Insira o texto de análise';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Checkbox para questão subjetiva
              CheckboxListTile(
                title: const Text('Questão Subjetiva'),
                value: _isSubjective,
                onChanged: (value) {
                  setState(() {
                    _isSubjective = value ?? false;
                  });
                },
              ),
              const SizedBox(height: 24),

              // Botões de ação
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Cancelar'),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _saveQuestion,
                      child: const Text('Salvar'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _saveQuestion() {
    if (_formKey.currentState!.validate()) {
      final newQuestion = {
        'id': _idController.text,
        'systemId': _selectedSystemId!,
        'criterionId': _selectedCriterionId!,
        'subCriterionId': _selectedSubCriterionId!,
        'analysisText': _analysisController.text,
        'isSubjective': _isSubjective,
        'createdAt': DateTime.now().toIso8601String(),
      };

      Navigator.pop(context, newQuestion);
    }
  }

  @override
  void dispose() {
    _idController.dispose();
    _analysisController.dispose();
    super.dispose();
  }
}
