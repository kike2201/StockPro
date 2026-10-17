
import 'package:flutter/material.dart';

import '../models/categoria.dart';
import '../services/categoria_service.dart';
import 'editar_categoria_page.dart';

class DetalleCategoriaPage extends StatelessWidget {
  final Categoria categoria;

  const DetalleCategoriaPage({
    super.key,
    required this.categoria,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalle de categoría'),
        backgroundColor: const Color(0xFF17324D),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Ícono de categoría
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(28),
              decoration: BoxDecoration(
                color: const Color(0xFFFFE6CC),
                borderRadius: BorderRadius.circular(18),
              ),
              child: const Icon(
                Icons.category_outlined,
                size: 90,
                color: Color(0xFFED8618),
              ),
            ),

            const SizedBox(height: 28),

            // Nombre de la categoría
            Text(
              categoria.nombre,
              style: const TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 20),
            const Divider(),

            // Identificador
            ListTile(
              leading: const Icon(Icons.tag),
              title: const Text('Código de categoría'),
              subtitle: Text('${categoria.id}'),
            ),

            // Estado
            ListTile(
              leading: const Icon(Icons.info_outline),
              title: const Text('Estado'),
              subtitle: Text(categoria.estado),
            ),

            const SizedBox(height: 24),

            // BOTÓN EDITAR CATEGORÍA
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: () async {
                  final actualizado = await Navigator.push<bool>(
                    context,
                    MaterialPageRoute(
                      builder: (_) => EditarCategoriaPage(
                        categoria: categoria,
                      ),
                    ),
                  );

                  if (actualizado == true && context.mounted) {
                    Navigator.pop(context, true);
                  }
                },
                icon: const Icon(Icons.edit),
                label: const Text('Editar categoría'),
                style: FilledButton.styleFrom(
                  backgroundColor: const Color(0xFF17324D),
                  padding: const EdgeInsets.symmetric(
                    vertical: 16,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 12),

            // BOTÓN ELIMINAR CATEGORÍA
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () async {
                  // Solicitar confirmación
                  final confirmar = await showDialog<bool>(
                    context: context,
                    builder: (dialogContext) => AlertDialog(
                      title: const Text('Eliminar categoría'),
                      content: Text(
                        '¿Deseas eliminar la categoría '
                        '"${categoria.nombre}"?\n\n'
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
                    // Eliminar mediante la API del profesor
                    await CategoriaService().eliminarCategoria(
                      categoria.id,
                    );

                    if (!context.mounted) return;

                    // Volver al listado de categorías
                    Navigator.pop(context, true);
                  } catch (error) {
                    if (!context.mounted) return;

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Error al eliminar categoría: $error',
                        ),
                      ),
                    );
                  }
                },
                icon: const Icon(Icons.delete_outline),
                label: const Text('Eliminar categoría'),
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
