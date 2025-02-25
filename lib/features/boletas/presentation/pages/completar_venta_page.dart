import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../data/bolestas_service.dart';
import '../../../../core/constants/app_colors.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';

class CompletarVentaPage extends StatefulWidget {
  final int idmov;       // El ID de la boleta (regmovcab)
  final String numDocum; // Número de documento de la boleta

  const CompletarVentaPage({
    Key? key,
    required this.idmov,
    required this.numDocum,
  }) : super(key: key);

  @override
  _CompletarVentaPageState createState() => _CompletarVentaPageState();

}


class _CompletarVentaPageState extends State<CompletarVentaPage> {
  final BoletasService boletasService = BoletasService();
  final TextEditingController vendedorController = TextEditingController();

  List<dynamic> items = [];
  Map<int, String> fotosSubidas = {}; // iddet -> foto_id

  bool isLoading = false;




  @override
  void initState() {
    super.initState();
    print("LOG: initState CompletarVentaPage => idmov=${widget.idmov}, numDocum=${widget.numDocum}");
    loadItems();
  }

  Future<void> loadItems() async {
    setState(() {
      isLoading = true;
    });
    try {


      var result = await boletasService.getRegmovdetByIdcab(widget.idmov);

      // Aplicar la conversión del precio al 100%
      setState(() {
        items = result.map((item) {
          double precioOriginal = (item['precio'] as num).toDouble() / 0.82; // Ajuste del precio
          return {...item, 'precio': precioOriginal}; // Crear nuevo mapa con el precio ajustado
        }).toList();
      });

    } catch (e) {
      print("Error al cargar detalles: $e");
    }
    setState(() {
      isLoading = false;
    });
  }

  Future<void> tomarFotoParaItem(dynamic item) async {
    final picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.camera);

    if (image != null) {
      // Comprimir la imagen usando flutter_image_compress
      final compressedBytes = await FlutterImageCompress.compressWithFile(
        image.path,
        quality: 30, // Ajusta la calidad según lo necesites (valor entre 0 y 100)
        // Opcional: puedes definir targetWidth o targetHeight para redimensionar
        // targetWidth: 800,
        // targetHeight: 600,
      );

      if (compressedBytes == null) {
        print("Error: No se pudo comprimir la imagen.");
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Error al comprimir la imagen")),
        );
        return;
      }

      String base64Image = base64Encode(compressedBytes);

      try {
        print("LOG: Subiendo foto para iddet=${item['iddet']}...");
        var response = await boletasService.uploadPhoto(item['iddet'].toString(), base64Image);
        print("LOG: Respuesta uploadPhoto => $response");

        setState(() {
          fotosSubidas[item['iddet']] = response['foto_id'].toString();
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Foto subida para ${item['nomproducto'] ?? item['producto']}")),
        );
      } catch (e) {
        print("Error al subir la foto para item ${item['iddet']}: $e");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error al subir la foto para ${item['nomproducto'] ?? item['producto']}")),
        );
      }
    }
  }

  Future<void> completarVenta() async {
    String vendedor = vendedorController.text.trim();
    if (vendedor.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Ingrese el DNI del vendedor")),
      );
      return;
    }
    try {
      print("LOG: Cambiando estado a completo => idmov=${widget.idmov}, vendedor=$vendedor");
      var response = await boletasService.changeStateToComplete(widget.idmov, vendedor);
      print("LOG: Respuesta changeStateToComplete => $response");

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Venta completada con éxito")),
      );
      Navigator.pop(context,true);
    } catch (e) {
      print("Error completando venta: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Error completando la venta")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Completar Venta"),
        backgroundColor: AppColors.secondBlue,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppColors.customGradient,
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Boleta: ${widget.numDocum}",
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: vendedorController,
                  decoration: InputDecoration(
                    labelText: "DNI del vendedor",
                    labelStyle: const TextStyle(color: Colors.white),
                    enabledBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: AppColors.primaryBlue),
                    ),
                  ),
                  style: const TextStyle(color: Colors.white),
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: ListView.builder(
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      final item = items[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        color: Colors.white.withOpacity(0.9),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ListTile(
                          title: Text(item['nomproducto'] ?? item['producto'] ?? "Producto sin nombre"),
                          subtitle: Text("Cantidad: ${item['cantidad']}\nPrecio: ${item['precio']}"),
                          trailing: ElevatedButton(
                            onPressed: () => tomarFotoParaItem(item),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.secondBlue,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: const Text("Tomar Foto"),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 16),
                Center(
                  child: ElevatedButton(
                    onPressed: completarVenta,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.secondBlue,
                      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      "COMPLETAR VENTA",
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
