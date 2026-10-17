
import 'package:flutter_test/flutter_test.dart';
import 'package:stockpro/services/producto_service.dart';

void main() {
  test('Consultar productos desde la API del profesor', () async {
    final servicio = ProductoService();

    final productos = await servicio.listarProductos();

    expect(productos, isA<List>());
    print('Conexión exitosa. Productos recibidos: ${productos.length}');

    if (productos.isNotEmpty) {
      print('Primer producto: ${productos.first.nombre}');
    }
  });
}
