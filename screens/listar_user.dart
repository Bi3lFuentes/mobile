import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class ListarUserPage extends StatefulWidget {
  const ListarUserPage({Key? key}) : super(key: key);

  @override
  _ListarUserPageState createState() => _ListarUserPageState();
}

class _ListarUserPageState extends State<ListarUserPage> {
  List<Map<String, dynamic>> usuarios = [];

  @override
  void initState() {
    super.initState();
    carregarUsuarios();
  }

  Future<Database> _abrirBanco() async {
    final caminhoBanco = await getDatabasesPath();
    final caminho = join(caminhoBanco, 'student_database.db'); // nome do banco
    return openDatabase(caminho);
  }

  Future<void> carregarUsuarios() async {
    final db = await _abrirBanco();
    final resultado = await db.query('usuarios'); // nome da tabela
    setState(() {
      usuarios = resultado;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista de Usuários'),
      ),
      body: usuarios.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
        itemCount: usuarios.length,
        itemBuilder: (context, index) {
          final usuario = usuarios[index];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            child: ListTile(
              title: Text(usuario['name'] ?? 'Sem nome'),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Email: ${usuario['email'] ?? 'Não informado'}'),
                  Text('Senha: ${usuario['password']?.toString() ?? 'Desconhecida'}'),
                ],
              ),
              leading: CircleAvatar(child: Text(usuario['id'].toString())),
            ),
          );
        },
      ),
    );
  }
}
