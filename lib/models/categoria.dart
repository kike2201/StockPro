
class Categoria {
  final int id;
  final String nombre;
  final String estado;

  const Categoria({
    required this.id,
    required this.nombre,
    required this.estado,
  });

  factory Categoria.fromJson(Map<String, dynamic> json) {
    return Categoria(
      id: int.tryParse('${json['category_id']}') ?? 0,
      nombre: (json['category_name'] ?? '').toString(),
      estado: (json['category_state'] ?? '').toString(),
    );
  }
}
