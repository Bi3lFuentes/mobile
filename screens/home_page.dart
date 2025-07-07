import 'package:flutter/material.dart';
import 'package:teste/screens/AppDatabase.dart'; // Importe o AppDatabase
import 'package:teste/screens/listar_propriedade.dart';
import 'package:teste/screens/tabelas_db_page.dart';
import 'cadastrar_user.dart';
import 'cadastro_page.dart';
import 'listar_user.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // criar variáveis para armazenar as estatísticas e o estado de carregamento
  bool _isLoading = true;
  int _totalPropriedades = 0;
  int _totalUsuarios = 0;
  String _produtoMaisComum = 'N/A';

  @override
  void initState() {
    super.initState();
    // chamar a função para carregar os dados quando a tela iniciar
    _carregarEstatisticas();
  }

  // criar a função assíncrona para buscar os dados do banco
  Future<void> _carregarEstatisticas() async {
    final db = AppDatabase();
    // chama os novos métodos que criamos no AppDatabase
    final totalProp = await db.getTotalPropriedades();
    final totalUsers = await db.getTotalUsuarios();
    final produtoComum = await db.getProdutoMaisComum();

    // atualiza o estado com os dados recebidos
    setState(() {
      _totalPropriedades = totalProp;
      _totalUsuarios = totalUsers;
      _produtoMaisComum = produtoComum;
      _isLoading = false;
    });
  }


  Widget _buildStatCard(String title, String value, IconData icon) {
    return Expanded(
      child: Card(
        elevation: 4,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Icon(icon, size: 40, color: Theme.of(context).primaryColor),
              const SizedBox(height: 10),
              Text(
                value,
                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              Text(title),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Dashboard"),
        actions: [
          // botao para recarregar os dados
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _isLoading ? null : _carregarEstatisticas,
          ),
        ],
      ),
      // mostrar um indicador de progresso enquanto os dados carregam
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // seção de estatísticas com os Cards
            const Text(
              'Resumo Geral',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                _buildStatCard('Propriedades', _totalPropriedades.toString(), Icons.home_work),
                const SizedBox(width: 10),
                _buildStatCard('Usuários', _totalUsuarios.toString(), Icons.people),
              ],
            ),
            const SizedBox(height: 10),
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Icon(Icons.spa, size: 40, color: Theme.of(context).primaryColor),
                    const SizedBox(height: 10),
                    Text(_produtoMaisComum, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    const Text('Produto Mais Comum')
                  ],
                ),
              ),
            ),

            const Divider(height: 40, thickness: 1),

            const Text(
              'Ações Rápidas',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),

            ElevatedButton(
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const CadastrarUserPage())),
              child: const Text('Cadastrar usuário'),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const CadastroPage())),
              child: const Text('Cadastrar propriedade'),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const ListarUserPage())),
              child: const Text('Listar usuários'),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const ListarPropriedadesPage())),
              child: const Text('Listar propriedades'),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const TabelasDBPage())),
              child: const Text('Ver Tabelas do Banco'),
            ),
          ],
        ),
      ),
    );
  }
}