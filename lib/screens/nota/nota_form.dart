import 'package:flutter/material.dart';
import '../../models/system.dart';
import '../../models/criterion.dart';
import '../../models/subcriterion.dart';

class NotaFormScreen extends StatefulWidget {
  final List<System> systems;
  final List<Criterion> criteria;
  final List<SubCriterion> subCriteria;

  const NotaFormScreen({
    Key? key,
    required this.systems,
    required this.criteria,
    required this.subCriteria,
  }) : super(key: key);

  @override
  _NotaFormScreenState createState() => _NotaFormScreenState();
}

class _NotaFormScreenState extends State<NotaFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _idController = TextEditingController();
  final _avaliacaoController = TextEditingController();
  final _notaController = TextEditingController();
  String? _selectedSystemId;
  String? _selectedCriterionId;
  String? _selectedSubCriterionId;
  double _currentNote = 0.0;

  @override
  void initState() {
    super.initState();
    _idController.text =
        'NT-${DateTime.now().millisecondsSinceEpoch.toString().substring(5)}';
    _notaController.text = '0.0';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Atribuir Nota')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // ID da Nota
              TextFormField(
                controller: _idController,
                decoration: const InputDecoration(
                  labelText: 'ID da Nota',
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

              // Seleção do Critério
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

              // Seleção do Subcritério
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

              // Campo de avaliação
              TextFormField(
                controller: _avaliacaoController,
                decoration: const InputDecoration(
                  labelText: 'Avaliação',
                  border: OutlineInputBorder(),
                  hintText: 'Descreva sua avaliação...',
                ),
                maxLines: 4,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Insira sua avaliação';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Controle de nota
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Nota (0-10)',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Slider(
                    value: _currentNote,
                    min: 0,
                    max: 10,
                    divisions: 20,
                    label: _currentNote.toStringAsFixed(1),
                    onChanged: (value) {
                      setState(() {
                        _currentNote = value;
                        _notaController.text = value.toStringAsFixed(1);
                      });
                    },
                  ),
                  TextFormField(
                    controller: _notaController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      suffixText: 'pontos',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Informe a nota';
                      }
                      final note = double.tryParse(value);
                      if (note == null || note < 0 || note > 10) {
                        return 'Nota deve ser entre 0 e 10';
                      }
                      return null;
                    },
                    onChanged: (value) {
                      final note = double.tryParse(value) ?? 0.0;
                      if (note >= 0 && note <= 10) {
                        setState(() {
                          _currentNote = note;
                        });
                      }
                    },
                  ),
                ],
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
                      onPressed: _salvarNota,
                      child: const Text('Salvar Nota'),
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

  void _salvarNota() {
    if (_formKey.currentState!.validate()) {
      final nota = {
        'id': _idController.text,
        'systemId': _selectedSystemId!,
        'criterionId': _selectedCriterionId!,
        'subCriterionId': _selectedSubCriterionId!,
        'avaliacao': _avaliacaoController.text,
        'nota': double.parse(_notaController.text),
        'data': DateTime.now().toIso8601String(),
      };

      Navigator.pop(context, nota);
    }
  }

  @override
  void dispose() {
    _idController.dispose();
    _avaliacaoController.dispose();
    _notaController.dispose();
    super.dispose();
  }
}
