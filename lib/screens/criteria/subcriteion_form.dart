import 'package:flutter/material.dart';
import '../../models/subcriterion.dart';

class SubCriterionForm extends StatefulWidget {
  final SubCriterion? subCriterion;
  final String
  parentCriterionName; // Nome do critério pai para exibir no cabeçalho

  const SubCriterionForm({
    Key? key,
    this.subCriterion,
    required this.parentCriterionName,
  }) : super(key: key);

  @override
  _SubCriterionFormState createState() => _SubCriterionFormState();
}

class _SubCriterionFormState extends State<SubCriterionForm> {
  final _formKey = GlobalKey<FormState>();
  final _systemId = TextEditingController();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _idController = TextEditingController();

  @override
  void initState() {
    super.initState();

    // Preenche os valores se estiver editando
    if (widget.subCriterion != null) {
      _idController.text = _generateAutoId();
      _nameController.text = widget.subCriterion!.name;
      _descriptionController.text = widget.subCriterion!.description;
    } else {
      _idController.text = _generateAutoId();
      _nameController.text = '';
      _descriptionController.text = '';
    }
  }

  String _generateAutoId() {
    // Gera um ID automático, por exemplo, usando o timestamp atual
    return DateTime.now().millisecondsSinceEpoch.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Subcritérios', style: TextStyle(fontSize: 18)),
            Text(
              widget.parentCriterionName,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Nome',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira um nome';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Descrição',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira uma descrição';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                      onPressed: _saveSubCriterion,
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

  void _saveSubCriterion() {
    if (_formKey.currentState!.validate()) {
      final subCriterion = SubCriterion(
        id: _idController.text,
        systemId: _systemId.text,
        name: _nameController.text,
        description: _descriptionController.text,
        weight:
            widget.subCriterion?.weight ??
            1.0, // Mantém o peso existente ou usa padrão
        createdAt: widget.subCriterion?.createdAt ?? DateTime.now(),
        updatedAt: DateTime.now(),
      );

      Navigator.pop(context, subCriterion);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }
}
