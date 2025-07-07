import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:teste/screens/AppDatabase.dart';
import 'package:teste/screens/login.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Apaga o banco antigo antes de abrir o app
  //final caminho = join(await getDatabasesPath(), 'student_database.db');
  //await deleteDatabase(caminho);

  // Agora inicializa o banco (irá recriar as tabelas)
  //await AppDatabase().database;

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        ),
        home: Login()
    );
  }
}
