import 'dart:convert';
import 'package:flutter/material.dart';

import '../data/ventas_diarias_service.dart';

class DetallesVentaPage extends StatefulWidget {
  final int idcab;

  const DetallesVentaPage({Key? key, required this.idcab}) : super(key: key);

  @override
  _DetallesVentaPageState createState() => _DetallesVentaPageState();
}

class _DetallesVentaPageState extends State<DetallesVentaPage> {
  final VentasDiariasService _ventasDiariasService = VentasDiariasService();
  List<dynamic> _detalles = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchDetalles();
  }

  Future<void> _fetchDetalles() async {
    try {
      final detalles = await _ventasDiariasService.getFotosByIdCab(widget.idcab);
      setState(() {
        _detalles = detalles;
        _isLoading = false;
      });
    } catch (e) {
      print('Error al obtener los detalles: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(56.0), // Altura estándar del AppBar
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFF2E1C9C), // Azul más oscuro
                Color(0xFFA16EFF), // Lavanda claro
              ],
            ),
          ),
          child: AppBar(
            title: const Text(
              "Detalles de la venta",
              style: TextStyle(color: Colors.white),
            ),
            centerTitle: true,
            backgroundColor: Colors.transparent,
            elevation: 0,
            iconTheme: const IconThemeData(color: Colors.white),
          ),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _detalles.isEmpty
          ? const Center(
        child: Text(
          "No se encontraron detalles para esta venta.",
          style: TextStyle(fontSize: 16, color: Colors.black54),
        ),
      )
          : ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: _detalles.length,
        itemBuilder: (context, index) {
          final detalle = _detalles[index];
          // Dentro del itemBuilder o en el FutureBuilder:
          return FutureBuilder(
            future: _ventasDiariasService.getFotosByIdCab(detalle['idcab']),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return const Text("Error al cargar la imagen");
              } else {
                // snapshot.data debe ser List<dynamic>
                final fotosList = snapshot.data as List<dynamic>;
                String? fotoBase64;
                if (fotosList.isNotEmpty) {
                  // Se asume que cada elemento es un Map con la clave 'foto_codigo'
                  final Map<String, dynamic> primeraFoto = fotosList[0] as Map<String, dynamic>;
                  fotoBase64 = primeraFoto['foto_codigo'] as String?;
                }
                return Container(
                  margin: const EdgeInsets.symmetric(vertical: 8.0),
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "Producto: ${detalle['nombre_producto']}",
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 4),
                      fotoBase64 != null
                          ? Image.memory(
                        base64Decode(fotoBase64),
                        height: 100,
                        width: 100,
                        fit: BoxFit.cover,
                      )
                          : const Text("Sin foto disponible"),
                      const SizedBox(height: 8),
                      Text("Fecha: ${detalle['fecha']}"),
                    ],
                  ),
                );
              }
            },
          );
        },
      ),
    );
  }
}
