import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class DetalhesPage extends StatefulWidget {
  // Recebe os dados da propriedade da tela anterior
  final Map<String, dynamic> propriedade;

  const DetalhesPage({Key? key, required this.propriedade}) : super(key: key);

  @override
  _DetalhesPageState createState() => _DetalhesPageState();
}

class _DetalhesPageState extends State<DetalhesPage> {
  LatLng? _localizacaoPropriedade;
  final Set<Marker> _markers = {};

  @override
  void initState() {
    super.initState();
    _parseCoordenadas();
  }

  // extrair Lat e Lon da string de localização
  void _parseCoordenadas() {
    final String localizacaoString = widget.propriedade['localizacao'] ?? '';
    // Exemplo de string: 'Lat: -29.6841, Lon: -53.8069'

    try {
      final parts = localizacaoString.split(',');
      final latString = parts[0].split(':')[1].trim();
      final lonString = parts[1].split(':')[1].trim();

      final double lat = double.parse(latString);
      final double lon = double.parse(lonString);

      setState(() {
        _localizacaoPropriedade = LatLng(lat, lon);
        // pino no mapa
        _markers.add(
          Marker(
            markerId: MarkerId(widget.propriedade['id'].toString()),
            position: _localizacaoPropriedade!,
            infoWindow: InfoWindow(
              title: widget.propriedade['propriedade'] ?? 'Propriedade',
              snippet: widget.propriedade['produto'] ?? '',
            ),
          ),
        );
      });
    } catch (e) {
      // Se der erro ao extrair, o mapa não mostrará o pino
      print('Erro ao passar coordenadas: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final String? fotoPath = widget.propriedade['foto_path'];

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.propriedade['propriedade'] ?? 'Detalhes'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Exibição da Foto em Destaque
            if (fotoPath != null && fotoPath.isNotEmpty)
              Image.file(
                File(fotoPath),
                width: double.infinity,
                height: 250,
                fit: BoxFit.cover,
              )
            else
              Container(
                width: double.infinity,
                height: 250,
                color: Colors.grey[300],
                child: const Icon(Icons.image_not_supported, size: 100, color: Colors.grey),
              ),

            // Informações da Propriedade
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.propriedade['propriedade'] ?? 'nome_propriedade',
                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text('Produto: ${widget.propriedade['produto'] ?? 'Não informado'}', style: const TextStyle(fontSize: 18)),
                  const SizedBox(height: 8),
                  Text('Entrevistado: ${widget.propriedade['nome_entrevistado'] ?? 'Não informado'}', style: const TextStyle(fontSize: 16)),
                  const SizedBox(height: 8),
                  Text('Sistema de Cultivo: ${widget.propriedade['sistema_cultivo'] ?? 'Não informado'}', style: const TextStyle(fontSize: 16)),
                  const SizedBox(height: 8),
                  Text('Localidade: ${widget.propriedade['localidade'] ?? 'Não informada'}', style: const TextStyle(fontSize: 16)),
                ],
              ),
            ),

            // Mapa
            const Divider(height: 32, thickness: 2),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Text('Localização no Mapa', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            ),
            const SizedBox(height: 16),
            if (_localizacaoPropriedade != null)
              Container(
                height: 300,
                child: GoogleMap(
                  mapType: MapType.hybrid,
                  initialCameraPosition: CameraPosition(
                    target: _localizacaoPropriedade!,
                    zoom: 15,
                  ),
                  markers: _markers,
                ),
              )
            else
              const Center(
                child: Text('Coordenadas de localização não disponíveis.'),
              ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}