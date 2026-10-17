
import 'package:flutter/material.dart';

import '../models/proveedor.dart';
import '../services/proveedor_service.dart';
import 'editar_proveedor_page.dart';

class DetalleProveedorPage extends StatelessWidget {
  final Proveedor proveedor;

  const DetalleProveedorPage({
    super.key,
    required this.proveedor,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalle del proveedor'),
        backgroundColor: const Color(0xFF17324D),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Imagen representativa del proveedor
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(28),
              decoration: BoxDecoration(
                color: const Color(0xFFFFE6CC),
                borderRadius: BorderRadius.circular(18),
              ),
              child: const Icon(
                Icons.local_shipping_outlined,
                size: 90,
                color: Color(0xFFED8618),
              ),
            ),

            const SizedBox(height: 24),

            // Nombre completo
            Text(
              '${proveedor.nombre} ${proveedor.apellido}',
              style: const TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 20),
            const Divider(),

            // Información del proveedor
            ListTile(
              leading: const Icon(Icons.tag),
              title: const Text('Código del proveedor'),
              subtitle: Text('${proveedor.id}'),
            ),

            ListTile(
              leading: const Icon(Icons.person_outline),
              title: const Text('Nombre'),
              subtitle: Text(proveedor.nombre),
            ),

            ListTile(
              leading: const Icon(Icons.badge_outlined),
              title: const Text('Apellido'),
              subtitle: Text(proveedor.apellido),
            ),

            ListTile(
              leading: const Icon(Icons.email_outlined),
              title: const Text('Correo electrónico'),
              subtitle: Text(proveedor.correo),
            ),

            ListTile(
              leading: const Icon(Icons.info_outline),
              title: const Text('Estado'),
              subtitle: Text(proveedor.estado),
            ),

            const SizedBox(height: 24),

            // BOTÓN EDITAR PROVEEDOR
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: () async {
                  final actualizado = await Navigator.push<bool>(
                    context,
                    MaterialPageRoute(
                      builder: (_) => EditarProveedorPage(
                        proveedor: proveedor,
                      ),
                    ),
                  );

                  if (actualizado == true && context.mounted) {
                    Navigator.pop(context, true);
                  }
                },
                icon: const Icon(Icons.edit),
                label: const Text('Editar proveedor'),
                style: FilledButton.styleFrom(
                  backgroundColor: const Color(0xFF17324D),
                  padding: const EdgeInsets.symmetric(
                    vertical: 16,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 12),

            // BOTÓN ELIMINAR PROVEEDOR
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () async {
                  // Solicitar confirmación antes de eliminar
                  final confirmar = await showDialog<bool>(
                    context: context,
                    builder: (dialogContext) => AlertDialog(
                      title: const Text('Eliminar proveedor'),
                      content: Text(
                        '¿Deseas eliminar al proveedor '
                        '"${proveedor.nombre} ${proveedor.apellido}"?\n\n'
                        'Esta acción no se puede deshacer.',
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(dialogContext, false);
                          },
                          child: const Text('Cancelar'),
                        ),
                        FilledButton(
                          onPressed: () {
                            Navigator.pop(dialogContext, true);
                          },
                          style: FilledButton.styleFrom(
                            backgroundColor: Colors.red,
                          ),
                          child: const Text('Eliminar'),
                        ),
                      ],
                    ),
                  );

                  // Si cancela, no hacemos nada
                  if (confirmar != true || !context.mounted) {
                    return;
                  }

                  try {
                    // Enviar eliminación a la API
                    await ProveedorService().eliminarProveedor(
                      proveedor.id,
                    );

                    if (!context.mounted) return;

                    // Regresar al listado
                    Navigator.pop(context, true);
                  } catch (error) {
                    if (!context.mounted) return;

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Error al eliminar proveedor: $error',
                        ),
                      ),
                    );
                  }
                },
                icon: const Icon(Icons.delete_outline),
                label: const Text('Eliminar proveedor'),
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
