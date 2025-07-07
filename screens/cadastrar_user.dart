import 'package:flutter/material.dart';
import 'package:teste/screens/AppDatabase.dart';

class CadastrarUserPage extends StatefulWidget {
  const CadastrarUserPage({Key? key}) : super(key: key);

  @override
  State<CadastrarUserPage> createState() => _CadastrarUserPageState();
}

class _CadastrarUserPageState extends State<CadastrarUserPage> {
  final nomeController = TextEditingController();
  final emailController = TextEditingController();
  final senhaController = TextEditingController();

  void _salvarUsuario() async {
    final nome = nomeController.text.trim();
    final email = emailController.text.trim();
    final senha = senhaController.text.trim();

    if (nome.isNotEmpty && email.isNotEmpty && senha.isNotEmpty) {
      await AppDatabase().inserirUsuario(nome, email, senha);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Usuário cadastrado com sucesso!')),
      );
      nomeController.clear();
      emailController.clear();
      senhaController.clear();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Preencha todos os campos')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cadastrar Usuário')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: nomeController,
              decoration: const InputDecoration(labelText: 'Nome'),
            ),
            TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: senhaController,
              decoration: const InputDecoration(labelText: 'Senha'),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _salvarUsuario,
              child: const Text('Salvar'),
            ),
          ],
        ),
      ),
    );
  }
}
