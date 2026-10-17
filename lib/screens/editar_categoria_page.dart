
import 'package:flutter/material.dart';

import '../models/categoria.dart';
import '../services/categoria_service.dart';

class EditarCategoriaPage extends StatefulWidget {
  final Categoria categoria;

  const EditarCategoriaPage({
    super.key,
    required this.categoria,
  });

  @override
  State<EditarCategoriaPage> createState() =>
      _EditarCategoriaPageState();
}

class _EditarCategoriaPageState extends State<EditarCategoriaPage> {
  final _formKey = GlobalKey<FormState>();
  final _servicio = CategoriaService();

  late final TextEditingController _nombreController;
  late String _estado;

  bool _guardando = false;

  @override
  void initState() {
    super.initState();

    _nombreController = TextEditingController(
      text: widget.categoria.nombre,
    );

    _estado = widget.categoria.estado == 'Inactiva'
        ? 'Inactiva'
        : 'Activa';
  }

  @override
  void dispose() {
    _nombreController.dispose();
    super.dispose();
  }

  Future<void> _guardarCambios() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _guardando = true);

    try {
      final categoriaActualizada = Categoria(
        id: widget.categoria.id,
        nombre: _nombreController.text.trim(),
        estado: _estado,
      );

      await _servicio.editarCategoria(categoriaActualizada);

      if (!mounted) return;

      Navigator.pop(context, true);
    } catch (error) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al editar categoría: $error')),
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
        title: const Text('Editar categoría'),
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
                labelText: 'Nombre de la categoría',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.category_outlined),
              ),
              validator: (valor) {
                if (valor == null || valor.trim().isEmpty) {
                  return 'Ingresa el nombre de la categoría';
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
                  value: 'Activa',
                  child: Text('Activa'),
                ),
                DropdownMenuItem(
                  value: 'Inactiva',
                  child: Text('Inactiva'),
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
