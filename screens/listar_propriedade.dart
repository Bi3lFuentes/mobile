import 'package:teste/screens/DetalhesPage.dart';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:teste/screens/AppDatabase.dart';
import 'package:teste/screens/EditarPropriedadePage.dart';

class ListarPropriedadesPage extends StatefulWidget {
  const ListarPropriedadesPage({Key? key}) : super(key: key);

  @override
  _ListarPropriedadesPageState createState() => _ListarPropriedadesPageState();
}

class _ListarPropriedadesPageState extends State<ListarPropriedadesPage> {
  List<Map<String, dynamic>> propriedades = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    carregarPropriedades();
  }

  Future<void> excluirPropriedade(int id) async {
    final db = await AppDatabase().database;
    await db.delete('propriedades', where: 'id = ?', whereArgs: [id]);
    carregarPropriedades();
  }

  Future<void> carregarPropriedades() async {
    final db = await AppDatabase().database;
    final resultado = await db.query('propriedades');
    setState(() {
      propriedades = resultado;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista de Propriedades'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              setState(() => isLoading = true);
              carregarPropriedades();
            },
          )
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : propriedades.isEmpty
          ? const Center(child: Text('Nenhuma propriedade cadastrada.'))
          : ListView.builder(
        itemCount: propriedades.length,
        itemBuilder: (context, index) {
          final propriedade = propriedades[index];
          final String? fotoPath = propriedade['foto_path'];

          return InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DetalhesPage(propriedade: propriedade),
                ),
              );
            },
            child: Card(
              margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: ListTile(
                leading: SizedBox(
                  width: 70,
                  height: 70,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: fotoPath != null && fotoPath.isNotEmpty
                        ? Image.file(
                      File(fotoPath),
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return const Icon(Icons.broken_image, size: 40);
                      },
                    )
                        : Container(
                      color: Colors.grey[200],
                      child: const Icon(Icons.image_not_supported, size: 40),
                    ),
                  ),
                ),
                title: Text(propriedade['nome_propriedade'] ?? 'Sem nome de propriedade'),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Entrevistado: ${propriedade['nome_entrevistado'] ?? 'Não informado'}'),
                    Text('Produto: ${propriedade['produto'] ?? 'Não informado'}'),
                  ],
                ),
                trailing: PopupMenuButton<String>(
                  onSelected: (value) async {
                    if (value == 'editar') {
                      final resultado = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EditarPropriedadePage(propriedade: propriedade),
                        ),
                      );
                      if (resultado == true) {
                        carregarPropriedades();
                      }
                    } else if (value == 'excluir') {
                      excluirPropriedade(propriedade['id']);
                    }
                  },
                  itemBuilder: (context) => [
                    PopupMenuItem(value: 'editar', child: Text('Editar')),
                    PopupMenuItem(value: 'excluir', child: Text('Excluir')),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}