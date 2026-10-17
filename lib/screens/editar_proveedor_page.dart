
import 'package:flutter/material.dart';

import '../models/proveedor.dart';
import '../services/proveedor_service.dart';

class EditarProveedorPage extends StatefulWidget {
  final Proveedor proveedor;

  const EditarProveedorPage({
    super.key,
    required this.proveedor,
  });

  @override
  State<EditarProveedorPage> createState() =>
      _EditarProveedorPageState();
}

class _EditarProveedorPageState extends State<EditarProveedorPage> {
  final _formKey = GlobalKey<FormState>();
  final _servicio = ProveedorService();

  late final TextEditingController _nombreController;
  late final TextEditingController _apellidoController;
  late final TextEditingController _correoController;
  late String _estado;

  bool _guardando = false;

  @override
  void initState() {
    super.initState();

    _nombreController =
        TextEditingController(text: widget.proveedor.nombre);
    _apellidoController =
        TextEditingController(text: widget.proveedor.apellido);
    _correoController =
        TextEditingController(text: widget.proveedor.correo);

    _estado = widget.proveedor.estado == 'Inactivo'
        ? 'Inactivo'
        : 'Activo';
  }

  @override
  void dispose() {
    _nombreController.dispose();
    _apellidoController.dispose();
    _correoController.dispose();
    super.dispose();
  }

  Future<void> _guardarCambios() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _guardando = true);

    try {
      final actualizado = Proveedor(
        id: widget.proveedor.id,
        nombre: _nombreController.text.trim(),
        apellido: _apellidoController.text.trim(),
        correo: _correoController.text.trim(),
        estado: _estado,
      );

      await _servicio.editarProveedor(actualizado);

      if (!mounted) return;

      Navigator.pop(context, true);
    } catch (error) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error al editar proveedor: $error'),
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _guardando = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar proveedor'),
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
                labelText: 'Nombre',
                prefixIcon: Icon(Icons.person_outline),
                border: OutlineInputBorder(),
              ),
              validator: (valor) =>
                  valor == null || valor.trim().isEmpty
                      ? 'Ingresa el nombre'
                      : null,
            ),

            const SizedBox(height: 16),

            TextFormField(
              controller: _apellidoController,
              decoration: const InputDecoration(
                labelText: 'Apellido',
                prefixIcon: Icon(Icons.badge_outlined),
                border: OutlineInputBorder(),
              ),
              validator: (valor) =>
                  valor == null || valor.trim().isEmpty
                      ? 'Ingresa el apellido'
                      : null,
            ),

            const SizedBox(height: 16),

            TextFormField(
              controller: _correoController,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                labelText: 'Correo electrónico',
                prefixIcon: Icon(Icons.email_outlined),
                border: OutlineInputBorder(),
              ),
              validator: (valor) {
                if (valor == null || valor.trim().isEmpty) {
                  return 'Ingresa el correo';
                }

                if (!RegExp(
                  r'^[^@\s]+@[^@\s]+\.[^@\s]+$',
                ).hasMatch(valor.trim())) {
                  return 'Ingresa un correo válido';
                }

                return null;
              },
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
                _guardando
                    ? 'Guardando...'
                    : 'Guardar cambios',
              ),
              style: FilledButton.styleFrom(
                backgroundColor: const Color(0xFF17324D),
                padding: const EdgeInsets.symmetric(
                  vertical: 16,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
