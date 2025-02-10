import 'package:flutter/material.dart';
import 'package:movil_validation_app/core/constants/app_colors.dart';
import '../data/ventas_diarias_service.dart';
import 'detalles_venta_page.dart';

class VentasDiariasPage extends StatefulWidget {
  const VentasDiariasPage({Key? key}) : super(key: key);

  @override
  _VentasDiariasPageState createState() => _VentasDiariasPageState();
}

class _VentasDiariasPageState extends State<VentasDiariasPage> {
  final VentasDiariasService _ventasDiariasService = VentasDiariasService();
  List<dynamic> _ventas = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchVentasDiarias();
  }

  Future<void> _fetchVentasDiarias() async {
    try {
      final ventas = await _ventasDiariasService.getBoletasCompletadasHoy();
      setState(() {
        _ventas = ventas;
        _isLoading = false;
      });
    } catch (e) {
      print('Error al obtener ventas diarias: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFDBE8FF),
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
      body: SafeArea(
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : _ventas.isEmpty
            ? const Center(
          child: Text(
            "No hay ventas registradas hoy.",
            style: TextStyle(fontSize: 16, color: Colors.black54),
          ),
        )
            : ListView.builder(
          padding: const EdgeInsets.all(16.0),
          itemCount: _ventas.length,
          itemBuilder: (context, index) {
            final venta = _ventas[index];

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
                  Center(
                    child: Text(
                      venta['num_docum'] ?? "Sin número de documento",
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text(
                        "Cliente:",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      Text(
                        venta['cliente'] ?? 'Sin cliente',
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.black87,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "Estado: ${venta['estado'] ?? 'Sin estado'}",
                    style: const TextStyle(fontSize: 16, color: AppColors.primaryBlue),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "IGV: ${venta['igv'] ?? '0.00'}",
                    style: const TextStyle(fontSize: 16, color: Colors.black87),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "Valor de venta: ${venta['vvta'] ?? '0.00'}",
                    style: const TextStyle(fontSize: 16, color: Colors.black87),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "Total: ${venta['total'] ?? '0.00'}",
                    style: const TextStyle(fontSize: 16, color: Colors.black87),
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DetallesVentaPage(
                            idcab: venta['idmov'],
                          ),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryBlue, // Cambia el color del fondo a rojo
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8), // Esquinas redondeadas
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    ),
                    child: const Text(
                      "Más Información",
                      style: TextStyle(
                        color: Colors.white, // Asegúrate de que el texto sea visible
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                ],
              ),


            );
          },
        ),
      ),
    );
  }
}
