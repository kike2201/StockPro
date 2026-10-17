import 'package:flutter/material.dart';

import 'productos_page.dart';
import 'categorias_page.dart';
import 'proveedores_page.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  static const Color azul = Color(0xFF17324D);
  static const Color naranja = Color(0xFFED8618);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
appBar: AppBar(
  title: const Text('StockPro'),
  backgroundColor: azul,
  foregroundColor: Colors.white,
  centerTitle: false,
  actions: [
    IconButton(
      tooltip: 'Cerrar sesión',
      icon: const Icon(Icons.logout),
      onPressed: () async {
        final confirmar = await showDialog<bool>(
          context: context,
          builder: (dialogContext) => AlertDialog(
            title: const Text('Cerrar sesión'),
            content: const Text(
              '¿Deseas salir de StockPro?',
            ),
            actions: [
              TextButton(
                onPressed: () =>
                    Navigator.pop(dialogContext, false),
                child: const Text('Cancelar'),
              ),
              FilledButton(
                onPressed: () =>
                    Navigator.pop(dialogContext, true),
                child: const Text('Salir'),
              ),
            ],
          ),
        );

        if (confirmar != true) return;

        if (!context.mounted) return;

        try {
          await FirebaseAuth.instance.signOut();
        } catch (error) {
          if (!context.mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'No fue posible cerrar sesión: $error',
              ),
            ),
          );
        }
      },
    ),
  ],
),

      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // Encabezado de bienvenida
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

          // Módulo Productos
          _tarjetaModulo(
            context: context,
            titulo: 'Productos',
            descripcion: 'Consultar y administrar el inventario',
            icono: Icons.inventory_2_outlined,
            destino: const ProductosPage(),
          ),

          // Módulo Categorías
          _tarjetaModulo(
            context: context,
            titulo: 'Categorías',
            descripcion: 'Organizar los tipos de productos',
            icono: Icons.category_outlined,
            destino: const CategoriasPage(),
          ),

          // Módulo Proveedores
          _tarjetaModulo(
            context: context,
            titulo: 'Proveedores',
            descripcion: 'Gestionar la información de proveedores',
            icono: Icons.local_shipping_outlined,
            destino: const ProveedoresPage(),
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

  Widget _tarjetaModulo({
    required BuildContext context,
    required String titulo,
    required String descripcion,
    required IconData icono,
    required Widget destino,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 14),
      elevation: 2,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => destino,
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFE6CC),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icono,
                  color: naranja,
                  size: 30,
                ),
              ),

              const SizedBox(width: 16),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      titulo,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: azul,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      descripcion,
                      style: const TextStyle(
                        color: Colors.black54,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),

              const Icon(
                Icons.chevron_right,
                color: azul,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
