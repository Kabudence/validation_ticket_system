import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../data/bolestas_service.dart';
class BoletasPage extends StatelessWidget {
  final BoletasService boletasService = BoletasService();

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
          gradient: AppColors.customGradient, // Usamos el gradiente de tu tema
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: FutureBuilder<List<dynamic>>(
              future: boletasService.getBoletasEnProceso(),
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
                        margin: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 10),
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
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
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
                                    onPressed: () {
                                      // Acción al completar la venta
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          content: Text('Venta completada para ${boleta['num_docum']}'),
                                        ),
                                      );
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: AppColors.secondBlue,
                                      foregroundColor: Colors.white, // Cambiamos el color del texto a blanco
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
