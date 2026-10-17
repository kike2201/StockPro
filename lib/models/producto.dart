
class Producto {
  final int id;
  final String nombre;
  final num precio;
  final String imagen;
  final String estado;

  const Producto({
    required this.id,
    required this.nombre,
    required this.precio,
    required this.imagen,
    required this.estado,
  });

  factory Producto.fromJson(Map<String, dynamic> json) {
    return Producto(
      id: int.tryParse('${json['product_id']}') ?? 0,
      nombre: (json['product_name'] ?? '').toString(),
      precio: num.tryParse('${json['product_price']}') ?? 0,
      imagen: (json['product_image'] ?? '').toString(),
      estado: (json['product_state'] ?? '').toString(),
    );
  }
}
