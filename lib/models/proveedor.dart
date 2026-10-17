
class Proveedor {
  final int id;
  final String nombre;
  final String apellido;
  final String correo;
  final String estado;

  const Proveedor({
    required this.id,
    required this.nombre,
    required this.apellido,
    required this.correo,
    required this.estado,
  });

  factory Proveedor.fromJson(Map<String, dynamic> json) {
    return Proveedor(
      id: int.tryParse('${json['providerid']}') ?? 0,
      nombre: (json['provider_name'] ?? '').toString(),
      apellido: (json['provider_last_name'] ?? '').toString(),
      correo: (json['provider_mail'] ?? '').toString(),
      estado: (json['provider_state'] ?? '').toString(),
    );
  }
}
