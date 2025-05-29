import 'package:flutter/material.dart';

class CadastroSistemaScreen extends StatefulWidget {
  const CadastroSistemaScreen({Key? key}) : super(key: key);

  @override
  _CadastroSistemaScreenState createState() => _CadastroSistemaScreenState();
}

class _CadastroSistemaScreenState extends State<CadastroSistemaScreen> {
  final _formKey = GlobalKey<FormState>();
  final _idController = TextEditingController();
  final _nomeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Gera ID autoincrementado no formato S-001, S-002, etc.
    _idController.text =
        'S-${DateTime.now().millisecondsSinceEpoch.toString().substring(7, 10)}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cadastro de Sistema')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Campo Nome
              TextFormField(
                controller: _nomeController,
                decoration: const InputDecoration(
                  labelText: 'Nome',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira o nome do sistema';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              // Campo ID (read-only)
              TextFormField(
                controller: _idController,
                decoration: const InputDecoration(
                  labelText: 'ID',
                  border: OutlineInputBorder(),
                ),
                readOnly: true,
              ),
              const SizedBox(height: 30),

              // Botões
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Voltar'),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _cadastrarSistema,
                      child: const Text('Cadastrar'),
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

  void _cadastrarSistema() {
    if (_formKey.currentState!.validate()) {
      final novoSistema = {
        'id': _idController.text,
        'nome': _nomeController.text,
        'dataCriacao': DateTime.now().toString(),
      };

      // Retorna o sistema cadastrado
      Navigator.pop(context, novoSistema);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Sistema cadastrado com sucesso!'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  @override
  void dispose() {
    _idController.dispose();
    _nomeController.dispose();
    super.dispose();
  }
}
