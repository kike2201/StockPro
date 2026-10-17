
import 'package:flutter/material.dart';

import '../services/producto_service.dart';

class AgregarProductoPage extends StatefulWidget {
  const AgregarProductoPage({super.key});

  @override
  State<AgregarProductoPage> createState() =>
      _AgregarProductoPageState();
}

class _AgregarProductoPageState extends State<AgregarProductoPage> {
  final _formKey = GlobalKey<FormState>();
  final _servicio = ProductoService();

  final _nombreController = TextEditingController();
  final _precioController = TextEditingController();
  final _imagenController = TextEditingController();

  bool _guardando = false;

  @override
  void dispose() {
    _nombreController.dispose();
    _precioController.dispose();
    _imagenController.dispose();
    super.dispose();
  }

  Future<void> _guardar() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _guardando = true);

    try {
      await _servicio.crearProducto(
        nombre: _nombreController.text.trim(),
        precio: num.parse(_precioController.text.trim()),
        imagen: _imagenController.text.trim(),
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Solicitud de creación enviada'),
        ),
      );

      Navigator.pop(context, true);
    } catch (error) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al crear producto: $error')),
      );
    } finally {
      if (mounted) setState(() => _guardando = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Agregar producto'),
        backgroundColor: const Color(0xFF17324D),
        foregroundColor: Colors.white,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            TextFormField(
              controller: _nombreController,
              decoration: const InputDecoration(
                labelText: 'Nombre del producto',
                border: OutlineInputBorder(),
              ),
              validator: (valor) {
                if (valor == null || valor.trim().isEmpty) {
                  return 'Ingresa el nombre del producto';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _precioController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Precio',
                prefixText: '\$ ',
                border: OutlineInputBorder(),
              ),
              validator: (valor) {
                final precio = num.tryParse(valor?.trim() ?? '');
                if (precio == null || precio <= 0) {
                  return 'Ingresa un precio válido';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _imagenController,
              keyboardType: TextInputType.url,
              decoration: const InputDecoration(
                labelText: 'URL de la imagen',
                hintText: 'https://ejemplo.com/imagen.jpg',
                border: OutlineInputBorder(),
              ),
              validator: (valor) {
                final url = Uri.tryParse(valor?.trim() ?? '');
                if (url == null ||
                    !url.hasAuthority ||
                    !['http', 'https'].contains(url.scheme)) {
                  return 'Ingresa una URL válida';
                }
                return null;
              },
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: _guardando ? null : _guardar,
              icon: const Icon(Icons.add),
              label: Text(
                _guardando ? 'Guardando...' : 'Agregar producto',
              ),
              style: FilledButton.styleFrom(
                backgroundColor: const Color(0xFF17324D),
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
