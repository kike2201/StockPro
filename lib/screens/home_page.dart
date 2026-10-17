
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../widgets/tarjeta_modulo.dart';
import 'productos_page.dart';
import 'categorias_page.dart';
import 'proveedores_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  static const Color azul = Color(0xFF17324D);
  static const Color naranja = Color(0xFFED8618);

  Future<void> _cerrarSesion(BuildContext context) async {
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Cerrar sesión'),
        content: const Text('¿Deseas salir de StockPro?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Salir'),
          ),
        ],
      ),
    );

    if (confirmar != true || !context.mounted) return;

    try {
      await FirebaseAuth.instance.signOut();
    } catch (error) {
      if (!context.mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('No fue posible cerrar sesión: $error'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('StockPro'),
        backgroundColor: azul,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            tooltip: 'Cerrar sesión',
            icon: const Icon(Icons.logout),
            onPressed: () => _cerrarSesion(context),
          ),
        ],
      ),

      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // Encabezado
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: azul,
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.inventory_2_outlined,
                  color: naranja,
                  size: 48,
                ),
                SizedBox(height: 16),
                Text(
                  'Bienvenido a StockPro',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Administra tus productos, categorías '
                  'y proveedores desde un solo lugar.',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 15,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 28),

          const Text(
            'Panel de administración',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: azul,
            ),
          ),

          const SizedBox(height: 16),

          // Widget reutilizable: Productos
          const TarjetaModulo(
            titulo: 'Productos',
            descripcion: 'Consultar y administrar el inventario',
            icono: Icons.inventory_2_outlined,
            destino: ProductosPage(),
          ),

          // Widget reutilizable: Categorías
          const TarjetaModulo(
            titulo: 'Categorías',
            descripcion: 'Organizar los tipos de productos',
            icono: Icons.category_outlined,
            destino: CategoriasPage(),
          ),

          // Widget reutilizable: Proveedores
          const TarjetaModulo(
            titulo: 'Proveedores',
            descripcion: 'Gestionar la información de proveedores',
            icono: Icons.local_shipping_outlined,
            destino: ProveedoresPage(),
          ),

          const SizedBox(height: 24),

          const Center(
            child: Text(
              'StockPro | Gestión de inventario',
              style: TextStyle(
                color: Colors.black54,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
