
import 'package:flutter/material.dart';

import '../models/producto.dart';
import '../services/producto_service.dart';
import 'editar_producto_page.dart';

class DetalleProductoPage extends StatelessWidget {
  final Producto producto;

  const DetalleProductoPage({
    super.key,
    required this.producto,
  });

  @override
  Widget build(BuildContext context) {
    final precio = producto.precio.toStringAsFixed(0);
    final precioFormateado = precio.replaceAllMapped(
      RegExp(r'\B(?=(\d{3})+(?!\d))'),
      (match) => '.',
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalle del producto'),
        backgroundColor: const Color(0xFF17324D),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Fotografía del producto
            Container(
              width: double.infinity,
              height: 220,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: producto.imagen.isNotEmpty
                  ? Image.network(
                      producto.imagen,
                      fit: BoxFit.contain,
                      errorBuilder: (_, _, _) => const Icon(
                        Icons.inventory_2_outlined,
                        size: 90,
                        color: Color(0xFFED8618),
                      ),
                    )
                  : const Icon(
                      Icons.inventory_2_outlined,
                      size: 90,
                      color: Color(0xFFED8618),
                    ),
            ),

            const SizedBox(height: 24),

            // Nombre
            Text(
              producto.nombre,
              style: const TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 14),

            // Precio
            Text(
              '\$$precioFormateado',
              style: const TextStyle(
                fontSize: 27,
                fontWeight: FontWeight.bold,
                color: Color(0xFFED8618),
              ),
            ),

            const SizedBox(height: 20),
            const Divider(),

            // Código
            ListTile(
              leading: const Icon(Icons.tag),
              title: const Text('Código del producto'),
              subtitle: Text('${producto.id}'),
            ),

            // Estado
            ListTile(
              leading: const Icon(Icons.info_outline),
              title: const Text('Estado'),
              subtitle: Text(producto.estado),
            ),

            const SizedBox(height: 24),

            // BOTÓN EDITAR
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: () async {
                  final actualizado = await Navigator.push<bool>(
                    context,
                    MaterialPageRoute(
                      builder: (_) => EditarProductoPage(
                        producto: producto,
                      ),
                    ),
                  );

                  if (actualizado == true && context.mounted) {
                    Navigator.pop(context, true);
                  }
                },
                icon: const Icon(Icons.edit),
                label: const Text('Editar producto'),
                style: FilledButton.styleFrom(
                  backgroundColor: const Color(0xFF17324D),
                  padding: const EdgeInsets.symmetric(
                    vertical: 16,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 12),

            // BOTÓN ELIMINAR
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () async {
                  // Pedir confirmación antes de eliminar
                  final confirmar = await showDialog<bool>(
                    context: context,
                    builder: (dialogContext) => AlertDialog(
                      title: const Text('Eliminar producto'),
                      content: Text(
                        '¿Estás seguro de que deseas eliminar '
                        '"${producto.nombre}"?\n\n'
                        'Esta acción no se puede deshacer.',
                      ),
                      actions: [
                        TextButton(
                          onPressed: () =>
                              Navigator.pop(dialogContext, false),
                          child: const Text('Cancelar'),
                        ),
                        FilledButton(
                          onPressed: () =>
                              Navigator.pop(dialogContext, true),
                          style: FilledButton.styleFrom(
                            backgroundColor: Colors.red,
                          ),
                          child: const Text('Eliminar'),
                        ),
                      ],
                    ),
                  );

                  if (confirmar != true || !context.mounted) {
                    return;
                  }

                  try {
                    // Solicitar la eliminación a la API
                    await ProductoService().eliminarProducto(
                      producto.id,
                    );

                    if (!context.mounted) return;

                    // Volver al listado después de eliminar
                    Navigator.pop(context, true);
                  } catch (error) {
                    if (!context.mounted) return;

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Error al eliminar: $error'),
                      ),
                    );
                  }
                },
                icon: const Icon(Icons.delete_outline),
                label: const Text('Eliminar producto'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.red,
                  padding: const EdgeInsets.symmetric(
                    vertical: 16,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
