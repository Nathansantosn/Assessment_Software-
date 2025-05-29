import 'package:flutter/material.dart';
import '../../models/system.dart';
import '../../models/question.dart';
import '../question/question_form.dart';

class AvaliacaoScreen extends StatefulWidget {
  final List<System> systems;
  final List<Question> questions;

  const AvaliacaoScreen({
    super.key,
    required this.systems,
    required this.questions,
  });

  @override
  // ignore: library_private_types_in_public_api
  _AvaliacaoScreenState createState() => _AvaliacaoScreenState();
}

class _AvaliacaoScreenState extends State<AvaliacaoScreen> {
  final _idController = TextEditingController();
  String? _selectedSystemId;
  List<Question> _filteredQuestions = [];
  int _currentQuestionIndex = 0;

  @override
  void initState() {
    super.initState();
    _idController.text =
        'AV-${DateTime.now().millisecondsSinceEpoch.toString().substring(5)}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Avaliação')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ID da Avaliação
            TextFormField(
              controller: _idController,
              decoration: const InputDecoration(
                labelText: 'ID',
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
                  _filteredQuestions = widget.questions
                      .where((q) => q.systemId == value)
                      .toList();
                  _currentQuestionIndex = 0;
                });
              },
            ),
            const SizedBox(height: 24),

            // Divisor visual
            const Divider(thickness: 2),
            const SizedBox(height: 16),

            // Questão atual
            if (_selectedSystemId != null && _filteredQuestions.isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Questão ${_currentQuestionIndex + 1}:',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _filteredQuestions[_currentQuestionIndex].texto,
                    style: const TextStyle(fontSize: 16),
                  ),
                ],
              )
            else if (_selectedSystemId != null)
              const Text('Nenhuma questão encontrada para este sistema.'),

            const Spacer(),

            // Botões de navegação
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
                    onPressed: _filteredQuestions.isNotEmpty ? _avancar : null,
                    child: const Text('Avançar'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _avancar() {
    if (_currentQuestionIndex < _filteredQuestions.length - 1) {
      setState(() {
        _currentQuestionIndex++;
      });
    } else {
      // Navegar para a tela de resultados ou finalização
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => QuestionFormScreen(
            systemId: _selectedSystemId!,
            question: _filteredQuestions[_currentQuestionIndex],
            systems: widget.systems,
            criteria: [], // TODO: Replace with actual criteria list
            subCriteria: [], // TODO: Replace with actual subCriteria list
          ),
        ),
      );
    }
  }

  @override
  void dispose() {
    _idController.dispose();
    super.dispose();
  }
}
