import 'package:flutter/material.dart';
import 'package:teste/screens/AppDatabase.dart';

class EditarPropriedadePage extends StatefulWidget {
  final Map<String, dynamic> propriedade;

  const EditarPropriedadePage({Key? key, required this.propriedade}) : super(key: key);

  @override
  State<EditarPropriedadePage> createState() => _EditarPropriedadePageState();
}

class _EditarPropriedadePageState extends State<EditarPropriedadePage> {
  late TextEditingController nomeController;
  late TextEditingController entrevistadoController;
  late TextEditingController localidadeController;
  late TextEditingController produtoController;
  late TextEditingController sistemaController;
  late TextEditingController localizacaoController;

  @override
  void initState() {
    super.initState();
    nomeController = TextEditingController(text: widget.propriedade['nome_propriedade'] ?? '');
    entrevistadoController = TextEditingController(text: widget.propriedade['nome_entrevistado'] ?? '');
    localidadeController = TextEditingController(text: widget.propriedade['localidade'] ?? '');
    produtoController = TextEditingController(text: widget.propriedade['produto'] ?? '');
    sistemaController = TextEditingController(text: widget.propriedade['sistema_cultivo'] ?? '');
    localizacaoController = TextEditingController(text: widget.propriedade['localizacao'] ?? '');
  }

  Future<void> salvarAlteracoes() async {
    final db = await AppDatabase().database;

    await db.update(
      'propriedades',
      {
        'nome_propriedade': nomeController.text,
        'nome_entrevistado': entrevistadoController.text,
        'localidade': localidadeController.text,
        'produto': produtoController.text,
        'sistema_cultivo': sistemaController.text,
        'localizacao': localizacaoController.text,
      },
      where: 'id = ?',
      whereArgs: [widget.propriedade['id']],
    );

    Navigator.pop(context, true); // Retorna true para recarregar a lista
  }

  @override
  void dispose() {
    nomeController.dispose();
    entrevistadoController.dispose();
    localidadeController.dispose();
    produtoController.dispose();
    sistemaController.dispose();
    localizacaoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Editar Propriedade')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            TextField(controller: nomeController, decoration: const InputDecoration(labelText: 'Nome da Propriedade')),
            TextField(controller: entrevistadoController, decoration: const InputDecoration(labelText: 'Entrevistado')),
            TextField(controller: localidadeController, decoration: const InputDecoration(labelText: 'Localidade')),
            TextField(controller: produtoController, decoration: const InputDecoration(labelText: 'Produto')),
            TextField(controller: sistemaController, decoration: const InputDecoration(labelText: 'Sistema de Cultivo')),
            TextField(controller: localizacaoController, decoration: const InputDecoration(labelText: 'Localização')),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: salvarAlteracoes,
              child: const Text('Salvar'),
            ),
          ],
        ),
      ),
    );
  }
}
