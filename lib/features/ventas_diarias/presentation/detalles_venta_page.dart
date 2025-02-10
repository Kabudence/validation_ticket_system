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
  Map<String, dynamic>? currentPhoto;
  bool isLoading = true;
  int currentIndex = 0;
  bool hasNext = false;
  final int paginationLimit = 2; // Solicitamos 2 fotos para detectar si hay siguiente

  @override
  void initState() {
    super.initState();
    loadPhoto();
  }

  Future<void> loadPhoto() async {
    setState(() {
      isLoading = true;
    });
    try {
      // Solicitamos 2 fotos; si la respuesta tiene 2 elementos, entonces existe una siguiente.
      final List<dynamic> photos = await _ventasDiariasService
          .getFotosByIdCabWithPagination(widget.idcab, currentIndex, paginationLimit);
      if (photos.isNotEmpty) {
        setState(() {
          currentPhoto = photos[0] as Map<String, dynamic>;
          hasNext = photos.length > 1;
        });
      } else {
        setState(() {
          currentPhoto = null;
          hasNext = false;
        });
      }
    } catch (e) {
      print("Error al cargar la foto: $e");
    }
    setState(() {
      isLoading = false;
    });
  }

  void nextPhoto() {
    if (!hasNext) return;
    setState(() {
      currentIndex++;
    });
    loadPhoto();
  }

  void previousPhoto() {
    if (currentIndex <= 0) return;
    setState(() {
      currentIndex--;
      // Al retroceder asumimos que seguramente habrá un siguiente (o se recarga la foto correspondiente).
      hasNext = true;
    });
    loadPhoto();
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
              "Ventas Diarias",
              style: TextStyle(color: Colors.white),
            ),
            centerTitle: true,
            backgroundColor: Colors.transparent, // Fondo transparente para mostrar el gradiente
            elevation: 0, // Eliminar la sombra
            iconTheme: const IconThemeData(color: Colors.white), // Íconos en blanco
          ),
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : currentPhoto == null
          ? const Center(child: Text("Sin foto disponible"))
          : SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Título con el nombre del producto

              const SizedBox(height: 16),
              // Imagen más grande
              Center(
                child: Image.memory(
                  base64Decode(currentPhoto!['foto_codigo']),
                  height: 300,
                  width: 300,
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                currentPhoto!['nombre_producto'] ?? "Producto sin nombre",
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              // Información de precio vendido y cantidad en una fila
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Precio vendido: ${currentPhoto!['precio_vendido']}",
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(width: 16),
                  Text(
                    "Cantidad: ${currentPhoto!['cantidad']}",
                    style: const TextStyle(fontSize: 16),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // Fecha al final
              Text(
                "Fecha: ${currentPhoto!['fecha']}",
                style: const TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              // Botones de navegación
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: currentIndex > 0 ? previousPhoto : null,
                    child: const Text("Anterior"),
                  ),
                  ElevatedButton(
                    onPressed: hasNext ? nextPhoto : null,
                    child: const Text("Siguiente")
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text("Foto ${currentIndex + 1}"),
            ],
          ),
        ),
      ),
    );
  }
}
