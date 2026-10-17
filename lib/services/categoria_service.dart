
import '../models/categoria.dart';
import 'api_service.dart';

class CategoriaService {
  final ApiService _api = ApiService();

  // Obtener las categorías desde la API.
  Future<List<Categoria>> listarCategorias() async {
    final respuesta = await _api.obtener(
      'category_list_rest/',
    );

    if (respuesta is! Map<String, dynamic>) {
      throw const FormatException(
        'La API no devolvió un objeto JSON válido.',
      );
    }

    final lista = respuesta['Listado Categorias'];

    if (lista is! List) {
      throw const FormatException(
        'No se encontró el listado de categorías.',
      );
    }

    return lista.map((item) {
      return Categoria.fromJson(
        Map<String, dynamic>.from(item as Map),
      );
    }).toList();
  }

  // Crear una nueva categoría.
  Future<void> crearCategoria(String nombre) async {
    await _api.enviar(
      'category_add_rest/',
      {
        'category_name': nombre,
      },
    );
  }

  // Editar una categoría existente.
  Future<void> editarCategoria(Categoria categoria) async {
    await _api.enviar(
      'category_edit_rest/',
      {
        'category_id': categoria.id,
        'category_name': categoria.nombre,
        'category_state': categoria.estado,
      },
    );
  }

  // Eliminar una categoría por su identificador.
  Future<void> eliminarCategoria(int id) async {
    await _api.enviar(
      'category_del_rest/',
      {
        'category_id': id,
      },
    );
  }
}
    