
import 'package:flutter/material.dart';

import '../services/proveedor_service.dart';

class AgregarProveedorPage extends StatefulWidget {
  const AgregarProveedorPage({super.key});

  @override
  State<AgregarProveedorPage> createState() =>
      _AgregarProveedorPageState();
}

class _AgregarProveedorPageState extends State<AgregarProveedorPage> {
  final _formKey = GlobalKey<FormState>();
  final _servicio = ProveedorService();

  final _nombreController = TextEditingController();
  final _apellidoController = TextEditingController();
  final _correoController = TextEditingController();

  bool _guardando = false;

  @override
  void dispose() {
    _nombreController.dispose();
    _apellidoController.dispose();
    _correoController.dispose();
    super.dispose();
  }

  Future<void> _guardarProveedor() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _guardando = true);

    try {
      await _servicio.crearProveedor(
        nombre: _nombreController.text.trim(),
        apellido: _apellidoController.text.trim(),
        correo: _correoController.text.trim(),
      );

      if (!mounted) return;

      Navigator.pop(context, true);
    } catch (error) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error al crear proveedor: $error'),
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
        title: const Text('Agregar proveedor'),
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
              validator: (valor) {
                if (valor == null || valor.trim().isEmpty) {
                  return 'Ingresa el nombre';
                }
                return null;
              },
            ),

            const SizedBox(height: 16),

            TextFormField(
              controller: _apellidoController,
              decoration: const InputDecoration(
                labelText: 'Apellido',
                prefixIcon: Icon(Icons.badge_outlined),
                border: OutlineInputBorder(),
              ),
              validator: (valor) {
                if (valor == null || valor.trim().isEmpty) {
                  return 'Ingresa el apellido';
                }
                return null;
              },
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

                final correo = valor.trim();

                if (!RegExp(
                  r'^[^@\s]+@[^@\s]+\.[^@\s]+$',
                ).hasMatch(correo)) {
                  return 'Ingresa un correo válido';
                }

                return null;
              },
            ),

            const SizedBox(height: 24),

            FilledButton.icon(
              onPressed: _guardando ? null : _guardarProveedor,
              icon: const Icon(Icons.save),
              label: Text(
                _guardando
                    ? 'Guardando...'
                    : 'Guardar proveedor',
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
