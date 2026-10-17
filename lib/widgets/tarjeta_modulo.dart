

import 'package:flutter/material.dart';

class TarjetaModulo extends StatelessWidget {
  final String titulo;
  final String descripcion;
  final IconData icono;
  final Widget destino;

  const TarjetaModulo({
    super.key,
    required this.titulo,
    required this.descripcion,
    required this.icono,
    required this.destino,
  });

  @override
  Widget build(BuildContext context) {
    const azul = Color(0xFF17324D);
    const naranja = Color(0xFFED8618);

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
