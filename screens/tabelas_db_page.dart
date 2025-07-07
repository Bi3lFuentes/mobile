import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class TabelasDBPage extends StatefulWidget {
  const TabelasDBPage({Key? key}) : super(key: key);

  @override
  _TabelasDBPageState createState() => _TabelasDBPageState();
}

class _TabelasDBPageState extends State<TabelasDBPage> {
  List<String> tabelas = [];

  @override
  void initState() {
    super.initState();
    carregarTabelas();
  }

  Future<Database> _abrirBanco() async {
    final caminhoBanco = await getDatabasesPath();
    final caminho = join(caminhoBanco, 'student_database.db'); // nome do seu banco
    return openDatabase(caminho);
  }

  Future<void> carregarTabelas() async {
    final db = await _abrirBanco();
    final resultado = await db.rawQuery("SELECT name FROM sqlite_master WHERE type='table'");
    setState(() {
      tabelas = resultado.map((row) => row['name'] as String).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tabelas do Banco'),
      ),
      body: tabelas.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
        itemCount: tabelas.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(tabelas[index]),
          );
        },
      ),
    );
  }
}
