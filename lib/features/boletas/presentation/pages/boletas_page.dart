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

  // Guardamos el future para reusarlo en el FutureBuilder
  late Future<List<dynamic>> _futureBoletas;

  @override
  void initState() {
    super.initState();
    // Cargar la lista de boletas inicialmente
    _loadBoletas();
  }

  // Método para cargar o recargar las boletas
  void _loadBoletas() {
    // Llama a tu endpoint /ventas/today-inprocess-peru con limit y offset
    _futureBoletas = boletasService.getBoletasTodayInProcessPeru(
      limit: 10,
      offset: 0,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Boletas',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      extendBodyBehindAppBar: true, // Para que el AppBar quede sobre el gradiente
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppColors.customGradient, // Gradiente de tu tema
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: FutureBuilder<List<dynamic>>(
              // Usamos el future que tenemos en la variable
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

                      // Opcional: Imprimir para depurar
                      // print("---- boleta (index=$index): $boleta");

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
                                      // Tomamos idmov y num_docum
                                      final int idmov = boleta['idmov'] ?? 0;
                                      final String numDocum = boleta['num_docum'] ?? "Sin doc";

                                      // Navegamos a CompletarVentaPage y esperamos el resultado
                                      final result = await Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => CompletarVentaPage(
                                            idmov: idmov,
                                            numDocum: numDocum,
                                          ),
                                        ),
                                      );

                                      // Si la página de completar venta devolvió true, recargamos boletas
                                      if (result == true) {
                                        setState(() {
                                          _loadBoletas();
                                        });
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
    );
  }
}
