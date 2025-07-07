import 'dart:io';
import 'package:image_picker/image_picker.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:teste/screens/service/LocationService.dart';
import 'package:teste/screens/AppDatabase.dart';
import 'home_page.dart';

class CadastroPage extends StatefulWidget {
  const CadastroPage({super.key});

  @override
  State<CadastroPage> createState() => _CadastroState();
}

class _CadastroState extends State<CadastroPage> {
  final LocationService _locationService = LocationService();
  final _formKey = GlobalKey<FormState>();


  final TextEditingController nomeController = TextEditingController();
  final TextEditingController propriedadeController = TextEditingController();
  final TextEditingController localidadeController = TextEditingController();
  final TextEditingController produtoController = TextEditingController();
  final TextEditingController localizacaoController = TextEditingController();


  String? _selectedOption;
  final List<String> _options = [
    'Convencional',
    'Orgânico',
    'Agroecológico',
    'Sistemas Integrados'
  ];


  File? _imageFile;
  final ImagePicker _picker = ImagePicker();

  bool _isLoadingLocation = false;
  String _locationError = '';

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    setState(() => _isLoadingLocation = true);

    final locationData = await _locationService.getCurrentLocation();

    if (locationData != null) {
      localizacaoController.text =
      'Lat: ${locationData.latitude!.toStringAsFixed(4)}, '
          'Lon: ${locationData.longitude!.toStringAsFixed(4)}';
    } else {
      setState(() => _locationError = 'Falha ao obter localização');
    }

    setState(() => _isLoadingLocation = false);
  }


  Future<void> _tirarFoto() async {
    final pickedFile = await _picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 80,
      maxWidth: 800,
    );

    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }


  void _salvarPropriedade() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }


    if (_selectedOption == null || _imageFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, preencha todos os campos e adicione uma foto.')),
      );
      return;
    }

    try {

      await AppDatabase().inserirPropriedade(
        nomeController.text,
        propriedadeController.text,
        localidadeController.text,
        produtoController.text,
        _selectedOption!,
        localizacaoController.text,
        _imageFile!.path,
      );


      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Propriedade cadastrada com sucesso!')),
      );


      nomeController.clear();
      propriedadeController.clear();
      localidadeController.clear();
      produtoController.clear();
      localizacaoController.clear();
      setState(() {
        _selectedOption = null;
        _imageFile = null;
      });


      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HomePage()),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro no cadastro: ${e.toString()}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cadastro de Propriedade')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  controller: nomeController,
                  decoration: const InputDecoration(labelText: 'Nome do entrevistado', border: OutlineInputBorder()),
                  validator: (value) => (value == null || value.isEmpty) ? 'Campo obrigatório' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: propriedadeController,
                  decoration: const InputDecoration(labelText: 'Nome da propriedade', border: OutlineInputBorder()),
                  validator: (value) => (value == null || value.isEmpty) ? 'Campo obrigatório' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: localidadeController,
                  decoration: const InputDecoration(labelText: 'Cidade', border: OutlineInputBorder()),
                  validator: (value) => (value == null || value.isEmpty) ? 'Campo obrigatório' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: produtoController,
                  decoration: const InputDecoration(labelText: 'Produto', border: OutlineInputBorder()),
                  validator: (value) => (value == null || value.isEmpty) ? 'Campo obrigatório' : null,
                ),
                const SizedBox(height: 16),

                // Sistema de cultivo
                const Text('Sistema de cultivo:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ..._options.map((option) => RadioListTile<String>(
                  title: Text(option),
                  value: option,
                  groupValue: _selectedOption,
                  onChanged: (value) => setState(() => _selectedOption = value),
                )),
                const SizedBox(height: 16),

                // Localização
                TextFormField(
                  controller: localizacaoController,
                  readOnly: true,
                  decoration: InputDecoration(
                    labelText: 'Localização',
                    border: const OutlineInputBorder(),
                    suffixIcon: _isLoadingLocation
                        ? const CircularProgressIndicator()
                        : IconButton(icon: const Icon(Icons.refresh), onPressed: _getCurrentLocation),
                  ),
                  validator: (value) => (value == null || value.isEmpty) ? 'Clique no ícone para obter a localização' : null,
                ),
                const SizedBox(height: 24), // Espaçamento maior

                Container(
                  width: double.infinity,
                  height: 250,
                  decoration: BoxDecoration(
                    border: Border.all(color: Theme.of(context).colorScheme.onSurface.withOpacity(0.4)),
                    borderRadius: BorderRadius.circular(4.0),
                  ),
                  child: _imageFile != null
                      ? ClipRRect(
                    borderRadius: BorderRadius.circular(4.0),
                    child: Image.file(_imageFile!, fit: BoxFit.cover),
                  )
                      : const Center(child: Text('Foto da propriedade aparecerá aqui')),
                ),
                const SizedBox(height: 8),
                OutlinedButton.icon(
                  onPressed: _tirarFoto,
                  icon: const Icon(Icons.camera_alt_outlined),
                  label: const Text('TIRAR FOTO DA PROPRIEDADE'),
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 50),
                  ),
                ),
                const SizedBox(height: 24),


                // Botão de cadastro
                ElevatedButton(
                  onPressed: _salvarPropriedade,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text('CADASTRAR PROPRIEDADE', style: TextStyle(fontSize: 18)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}