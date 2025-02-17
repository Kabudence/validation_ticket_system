import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../data/bolestas_service.dart';
import 'completar_venta_page.dart';

class BoletasPage extends StatefulWidget {
  const BoletasPage({Key? key}) : super(key: key);

  @override
  _BoletasPageState createState() => _BoletasPageState();
}

class _BoletasPageState extends State<BoletasPage> {
  final BoletasService boletasService = BoletasService();
  late Future<List<dynamic>> _futureBoletas;

  @override
  void initState() {
    super.initState();
    _loadBoletas();
  }

  /// Método para cargar o recargar la lista de boletas
  void _loadBoletas() {
    _futureBoletas = boletasService.getBoletasTodayInProcessPeru(
      limit: 10,
      offset: 0,
    );

    // Asegurar que `setState()` solo se llame si el widget sigue montado
    _futureBoletas.then((_) {
      if (mounted) {
        setState(() {}); // Solo actualizar si el widget sigue en pantalla
      }
    }).catchError((error) {
      if (mounted) {
        setState(() {}); // Manejar el error solo si el widget sigue activo
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Boletas',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: _loadBoletas, // Botón para actualizar manualmente
            tooltip: 'Actualizar',
          ),
        ],
      ),
      extendBodyBehindAppBar: true,
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppColors.customGradient,
        ),
        child: SafeArea(
          child: RefreshIndicator(
            onRefresh: () async {
              _loadBoletas();
              await _futureBoletas;
            },
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: FutureBuilder<List<dynamic>>(
                future: _futureBoletas,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text(
                        'Error: ${snapshot.error}',
                        style: const TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    );
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(
                      child: Text(
                        'No hay boletas disponibles',
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                    );
                  } else {
                    final boletas = snapshot.data!;
                    return ListView.builder(
                      itemCount: boletas.length,
                      itemBuilder: (context, index) {
                        final boleta = boletas[index];

                        return Card(
                          margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                          color: Colors.white.withOpacity(0.9),
                          elevation: 6,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Número: ${boleta['num_docum']}',
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Cliente: ${boleta['cliente']}',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    color: Colors.black54,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Estado: ${boleta['estado']}',
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: boleta['estado'] == 'EN PROCESO'
                                            ? Colors.red
                                            : Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    ElevatedButton(
                                      onPressed: () async {
                                        final int idmov = boleta['idmov'] ?? 0;
                                        final String numDocum = boleta['num_docum'] ?? "Sin doc";

                                        final result = await Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => CompletarVentaPage(
                                              idmov: idmov,
                                              numDocum: numDocum,
                                            ),
                                          ),
                                        );

                                        // Si se completó la venta, recargamos boletas manualmente
                                        if (result == true) {
                                          _loadBoletas();
                                        }
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: AppColors.secondBlue,
                                        foregroundColor: Colors.white,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                      ),
                                      child: const Text('Completar venta'),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  }
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
