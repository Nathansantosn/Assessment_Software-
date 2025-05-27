import 'package:flutter/material.dart';
import '../../models/criterion.dart';

class CriterionForm extends StatefulWidget {
  final Criterion? criterion;

  const CriterionForm({Key? key, this.criterion}) : super(key: key);

  @override
  _CriterionFormState createState() => _CriterionFormState();
}

class _CriterionFormState extends State<CriterionForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _idController = TextEditingController();

  @override
  void initState() {
    super.initState();

    if (widget.criterion != null) {
      _idController.text = widget.criterion!.id;
      _nameController.text = widget.criterion!.name;
      _descriptionController.text = widget.criterion!.description;
    } else {
      _idController.text = _generateAutoId();
      _nameController.text = widget.criterion!.name;
      _descriptionController.text = widget.criterion!.description;
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
        title: Text(
          widget.criterion == null ? 'Novo Critério' : 'Editar Critério',
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
                  labelText: 'Nome do Critério',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira um nome';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: 'Descrição'),
                maxLines: 3,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira uma descrição';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    final criterion = Criterion(
                      id: _idController.text,
                      name: _nameController.text,
                      description: _descriptionController.text,
                    );
                    // Salvar critério
                    Navigator.pop(context, criterion);
                  }
                },
                child: const Text('Salvar'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }
}
