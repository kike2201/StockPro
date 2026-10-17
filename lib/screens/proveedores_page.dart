
import 'package:flutter/material.dart';
import 'detalle_proveedor_page.dart';
import '../models/proveedor.dart';
import '../services/proveedor_service.dart';
import 'agregar_proveedor_page.dart';


class ProveedoresPage extends StatefulWidget {
  const ProveedoresPage({super.key});

  @override
  State<ProveedoresPage> createState() => _ProveedoresPageState();
}

class _ProveedoresPageState extends State<ProveedoresPage> {
  final ProveedorService _servicio = ProveedorService();

  late Future<List<Proveedor>> _proveedores;

  @override
  void initState() {
    super.initState();
    _actualizar();
  }

  void _actualizar() {
    setState(() {
      _proveedores = _servicio.listarProveedores();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        
    floatingActionButton: FloatingActionButton.extended(
    onPressed: () async {
        final creado = await Navigator.push<bool>(
        context,
        MaterialPageRoute(
            builder: (_) => const AgregarProveedorPage(),
        ),
        );

        if (creado == true && mounted) {
        _actualizar();
        }
    },
    backgroundColor: const Color(0xFFED8618),
    foregroundColor: Colors.white,
    icon: const Icon(Icons.add),
    label: const Text('Agregar'),
    ),

      appBar: AppBar(
        title: const Text('StockPro | Proveedores'),
        backgroundColor: const Color(0xFF17324D),
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            onPressed: _actualizar,
            icon: const Icon(Icons.refresh),
            tooltip: 'Actualizar proveedores',
          ),
        ],
      ),
      body: FutureBuilder<List<Proveedor>>(
        future: _proveedores,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text(
                  'No fue posible cargar los proveedores.\n'
                  '${snapshot.error}',
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }

          final proveedores = snapshot.data ?? [];

          if (proveedores.isEmpty) {
            return const Center(
              child: Text('No hay proveedores disponibles.'),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: proveedores.length,
            itemBuilder: (context, index) {
              final proveedor = proveedores[index];

              return Card(
                margin: const EdgeInsets.only(bottom: 10),
                child: ListTile(
                onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                    builder: (_) => DetalleProveedorPage(
                        proveedor: proveedor,
                    ),
                    ),
                );
                },
                  leading: const CircleAvatar(
                    backgroundColor: Color(0xFFFFE6CC),
                    child: Icon(
                      Icons.local_shipping_outlined,
                      color: Color(0xFFED8618),
                    ),
                  ),
                  title: Text(
                    '${proveedor.nombre} ${proveedor.apellido}',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        proveedor.correo,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        'Código: ${proveedor.id} · ${proveedor.estado}',
                      ),
                    ],
                  ),
                  trailing: const Icon(Icons.chevron_right),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
