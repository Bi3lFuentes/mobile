import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class AppDatabase {
  static final AppDatabase _instance = AppDatabase._internal();
  static Database? _database;

  factory AppDatabase() => _instance;

  AppDatabase._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final path = join(await getDatabasesPath(), 'student_database.db');
    return openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE usuarios(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT,
            email TEXT,
            password TEXT
          )
        ''');

        await db.execute('''
          CREATE TABLE propriedades(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            nome_entrevistado TEXT,
            nome_propriedade TEXT,
            localidade TEXT,
            produto TEXT,
            sistema_cultivo TEXT,     
            localizacao TEXT,
             foto_path TEXT   
          )
        ''');
      },
    );
  }

  Future<void> inserirUsuario(String nome, String email, String senha) async {
    final db = await database;
    await db.insert(
      'usuarios',
      {
        'name': nome,
        'email': email,
        'password': senha,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Map<String, dynamic>>> listarUsuarios() async {
    final db = await database;
    return await db.query('usuarios');
  }


  Future<void> inserirPropriedade(
      String nomeEntrevistado,
      String nomePropriedade,
      String localidade,
      String produto,
      String sistemaCultivo,
      String localizacao,
      String fotoPath,
      ) async {
    final db = await database;
    await db.insert(
      'propriedades',
      {
        'nome_entrevistado': nomeEntrevistado,
        'nome_propriedade': nomePropriedade,
        'localidade': localidade,
        'produto': produto,
        'sistema_cultivo': sistemaCultivo,
        'localizacao': localizacao,
        'foto_path': fotoPath,
      },
    );
  }
  Future<int> getTotalPropriedades() async {
    final db = await database;
    final resultado = await db.rawQuery('SELECT COUNT(*) FROM propriedades');
    return Sqflite.firstIntValue(resultado) ?? 0;
  }

  Future<int> getTotalUsuarios() async {
    final db = await database;
    final resultado = await db.rawQuery('SELECT COUNT(*) FROM usuarios');
    return Sqflite.firstIntValue(resultado) ?? 0;
  }

  Future<String> getProdutoMaisComum() async {
    final db = await database;
    final resultado = await db.rawQuery(
        'SELECT produto FROM propriedades GROUP BY produto ORDER BY COUNT(produto) DESC LIMIT 1'
    );

    if (resultado.isNotEmpty) {
      return resultado.first['produto'] as String;
    } else {

      return 'Nenhum';
    }
  }
}
