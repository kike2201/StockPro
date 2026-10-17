
import '../models/proveedor.dart';
import 'api_service.dart';

class ProveedorService {
  final ApiService _api = ApiService();

  // Consultar proveedores.
  Future<List<Proveedor>> listarProveedores() async {
    final respuesta = await _api.obtener(
      'provider_list_rest/',
    );

    if (respuesta is! Map<String, dynamic>) {
      throw const FormatException(
        'La API no devolvió un objeto JSON válido.',
      );
    }

    final lista = respuesta['Proveedores Listado'];

    if (lista is! List) {
      throw const FormatException(
        'No se encontró el listado de proveedores.',
      );
    }

    return lista.map((item) {
      return Proveedor.fromJson(
        Map<String, dynamic>.from(item as Map),
      );
    }).toList();
  }

  // Crear un proveedor.
  Future<void> crearProveedor({
    required String nombre,
    required String apellido,
    required String correo,
  }) async {
    await _api.enviar(
      'provider_add_rest/',
      {
        'provider_name': nombre,
        'provider_last_name': apellido,
        'provider_mail': correo,
        'provider_state': 'Activo',
      },
    );
  }

  // Editar un proveedor.
  Future<void> editarProveedor(Proveedor proveedor) async {
    await _api.enviar(
      'provider_edit_rest/',
      {
        'provider_id': proveedor.id,
        'provider_name': proveedor.nombre,
        'provider_last_name': proveedor.apellido,
        'provider_mail': proveedor.correo,
        'provider_state': proveedor.estado,
      },
    );
  }

  // Eliminar un proveedor.
  Future<void> eliminarProveedor(int id) async {
    await _api.enviar(
      'provider_del_rest/',
      {
        'provider_id': id,
      },
    );
  }
}
    