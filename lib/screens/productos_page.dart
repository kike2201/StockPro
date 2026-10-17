
import 'package:flutter/material.dart';
import 'detalle_producto_page.dart';
import '../models/producto.dart';
import '../services/producto_service.dart';
import 'agregar_producto_page.dart';


class ProductosPage extends StatefulWidget {
  const ProductosPage({super.key});

  @override
  State<ProductosPage> createState() => _ProductosPageState();
}

class _ProductosPageState extends State<ProductosPage> {
  final ProductoService _servicio = ProductoService();

  late Future<List<Producto>> _productos;

  @override
  void initState() {
    super.initState();
    _productos = _servicio.listarProductos();
  }

  void _actualizar() {
    setState(() {
      _productos = _servicio.listarProductos();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
       floatingActionButton: FloatingActionButton.extended(
            backgroundColor: const Color(0xFFED8618),
            foregroundColor: Colors.white,
            icon: const Icon(Icons.add),
            label: const Text('Agregar'),
            onPressed: () async {
                final creado = await Navigator.push<bool>(
                context,
                MaterialPageRoute(
                    builder: (_) => const AgregarProductoPage(),
                ),
                );

                if (creado == true && mounted) {
                _actualizar();
                }
            },
            ), 
      appBar: AppBar(
        title: const Text('StockPro | Productos'),
        backgroundColor: const Color(0xFF17324D),
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            onPressed: _actualizar,
            icon: const Icon(Icons.refresh),
            tooltip: 'Actualizar productos',
          ),
        ],
      ),
      body: FutureBuilder<List<Producto>>(
        future: _productos,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text(
                  'No fue posible cargar los productos.\n'
                  '${snapshot.error}',
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }

          final productos = snapshot.data ?? [];

          if (productos.isEmpty) {
            return const Center(
              child: Text('No hay productos disponibles.'),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: productos.length,
            itemBuilder: (context, index) {
              final producto = productos[index];

              return Card(
                margin: const EdgeInsets.only(bottom: 10),
                child: ListTile(
                    onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                        builder: (context) => DetalleProductoPage(
                            producto: producto,
                        ),
                        ),
                    );
                    },
                  leading: const Icon(
                    Icons.inventory_2_outlined,
                    color: Color(0xFFED8618),
                  ),
                  title: Text(
                    producto.nombre,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  subtitle: Text(
                    '\$${producto.precio} · ${producto.estado}',
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
