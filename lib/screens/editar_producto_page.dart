
import 'package:flutter/material.dart';

import '../models/producto.dart';
import '../services/producto_service.dart';

class EditarProductoPage extends StatefulWidget {
  final Producto producto;

  const EditarProductoPage({
    super.key,
    required this.producto,
  });

  @override
  State<EditarProductoPage> createState() => _EditarProductoPageState();
}

class _EditarProductoPageState extends State<EditarProductoPage> {
  final _formKey = GlobalKey<FormState>();
  final _servicio = ProductoService();

  late final TextEditingController _nombreController;
  late final TextEditingController _precioController;
  late final TextEditingController _imagenController;
  late String _estado;

  bool _guardando = false;

  @override
  void initState() {
    super.initState();

    _nombreController = TextEditingController(
      text: widget.producto.nombre,
    );

    _precioController = TextEditingController(
      text: widget.producto.precio.toString(),
    );

    _imagenController = TextEditingController(
      text: widget.producto.imagen,
    );

    _estado = widget.producto.estado == 'Inactivo'
        ? 'Inactivo'
        : 'Activo';
  }

  Future<void> _guardarCambios() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _guardando = true);

    try {
      final productoActualizado = Producto(
        id: widget.producto.id,
        nombre: _nombreController.text.trim(),
        precio: num.parse(_precioController.text.trim()),
        imagen: _imagenController.text.trim(),
        estado: _estado,
      );

      await _servicio.editarProducto(productoActualizado);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Solicitud de edición enviada correctamente'),
        ),
      );

      Navigator.pop(context, true);
    } catch (error) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al editar: $error')),
      );
    } finally {
      if (mounted) {
        setState(() => _guardando = false);
      }
    }
  }

  @override
  void dispose() {
    _nombreController.dispose();
    _precioController.dispose();
    _imagenController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar producto'),
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
              validator: (valor) =>
                  valor == null || valor.trim().isEmpty
                      ? 'Ingresa un nombre'
                      : null,
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
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              initialValue: _estado,
              decoration: const InputDecoration(
                labelText: 'Estado',
                border: OutlineInputBorder(),
              ),
              items: const [
                DropdownMenuItem(
                  value: 'Activo',
                  child: Text('Activo'),
                ),
                DropdownMenuItem(
                  value: 'Inactivo',
                  child: Text('Inactivo'),
                ),
              ],
              onChanged: (valor) {
                if (valor != null) {
                  setState(() => _estado = valor);
                }
              },
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: _guardando ? null : _guardarCambios,
              icon: const Icon(Icons.save),
              label: Text(
                _guardando ? 'Guardando...' : 'Guardar cambios',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
