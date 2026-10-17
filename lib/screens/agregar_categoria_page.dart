
import 'package:flutter/material.dart';

import '../services/categoria_service.dart';

class AgregarCategoriaPage extends StatefulWidget {
  const AgregarCategoriaPage({super.key});

  @override
  State<AgregarCategoriaPage> createState() =>
      _AgregarCategoriaPageState();
}

class _AgregarCategoriaPageState extends State<AgregarCategoriaPage> {
  final _formKey = GlobalKey<FormState>();
  final _nombreController = TextEditingController();
  final _servicio = CategoriaService();

  bool _guardando = false;

  @override
  void dispose() {
    _nombreController.dispose();
    super.dispose();
  }

  Future<void> _guardar() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _guardando = true);

    try {
      await _servicio.crearCategoria(
        _nombreController.text.trim(),
      );

      if (!mounted) return;

      Navigator.pop(context, true);
    } catch (error) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al crear categoría: $error')),
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
        title: const Text('Agregar categoría'),
        backgroundColor: const Color(0xFF17324D),
        foregroundColor: Colors.white,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            const Icon(
              Icons.category_outlined,
              size: 72,
              color: Color(0xFFED8618),
            ),
            const SizedBox(height: 24),
            TextFormField(
              controller: _nombreController,
              decoration: const InputDecoration(
                labelText: 'Nombre de la categoría',
                hintText: 'Ejemplo: Herramientas eléctricas',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.edit_outlined),
              ),
              validator: (valor) {
                if (valor == null || valor.trim().isEmpty) {
                  return 'Ingresa un nombre';
                }
                return null;
              },
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: _guardando ? null : _guardar,
              icon: const Icon(Icons.add),
              label: Text(
                _guardando ? 'Guardando...' : 'Agregar categoría',
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
