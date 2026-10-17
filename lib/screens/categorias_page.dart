
import 'package:flutter/material.dart';
import 'detalle_categoria_page.dart';
import '../models/categoria.dart';
import '../services/categoria_service.dart';
import 'agregar_categoria_page.dart';

class CategoriasPage extends StatefulWidget {
  const CategoriasPage({super.key});

  @override
  State<CategoriasPage> createState() => _CategoriasPageState();
}

class _CategoriasPageState extends State<CategoriasPage> {
  final CategoriaService _servicio = CategoriaService();

  late Future<List<Categoria>> _categorias;

  @override
  void initState() {
    super.initState();
    _actualizar();
  }

  void _actualizar() {
    setState(() {
      _categorias = _servicio.listarCategorias();
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
            builder: (_) => const AgregarCategoriaPage(),
        ),
        );

        if (creado == true && mounted) {
        _actualizar();
        }
    },
    ),
    
      appBar: AppBar(
        title: const Text('StockPro | Categorías'),
        backgroundColor: const Color(0xFF17324D),
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            onPressed: _actualizar,
            icon: const Icon(Icons.refresh),
            tooltip: 'Actualizar categorías',
          ),
        ],
      ),
      body: FutureBuilder<List<Categoria>>(
        future: _categorias,
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
                  'No fue posible cargar las categorías.\n'
                  '${snapshot.error}',
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }

          final categorias = snapshot.data ?? [];

          if (categorias.isEmpty) {
            return const Center(
              child: Text('No hay categorías disponibles.'),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: categorias.length,
            itemBuilder: (context, index) {
              final categoria = categorias[index];

              return Card(
                margin: const EdgeInsets.only(bottom: 10),
                child: ListTile(
                    onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                        builder: (_) => DetalleCategoriaPage(
                            categoria: categoria,
                        ),
                        ),
                    );
                    },                 
                    leading: const CircleAvatar(
                    backgroundColor: Color(0xFFFFE6CC),
                    child: Icon(
                      Icons.category_outlined,
                      color: Color(0xFFED8618),
                    ),
                  ),
                  title: Text(
                    categoria.nombre,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  subtitle: Text(
                    'Código: ${categoria.id} · ${categoria.estado}',
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
