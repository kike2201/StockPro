
import '../models/producto.dart';
import 'api_service.dart';

class ProductoService {
  final ApiService _api = ApiService();

  // Obtener productos desde la API del profesor.
  Future<List<Producto>> listarProductos() async {
    final respuesta = await _api.obtener(
      'product_list_rest/',
    );

    // Busca la lista de productos dentro de la respuesta.
    if (respuesta is! Map<String, dynamic>) {
      throw const FormatException(
        'La API no devolvió un objeto JSON válido.',
      );
    }

    final lista = respuesta['Listado'];

    if (lista is! List) {
      throw const FormatException(
        'No se encontró el listado seleccionado.',
      );
    }

    return lista
        .map(
          (item) => Producto.fromJson(
            Map<String, dynamic>.from(item as Map),
          ),
        )
        .toList();
  }
      
       Future<void> editarProducto(Producto producto) async {
        await _api.enviar(
       'product_edit_rest/',
        {
        'product_id': producto.id,
        'product_name': producto.nombre,
        'product_price': producto.precio,
        'product_image': producto.imagen,
        'product_state': producto.estado,
         },
             );
         }

          Future<void> crearProducto({
            required String nombre,
            required num precio,
            required String imagen,
          }) async {
            await _api.enviar(
              'product_add_rest/',
              {
                'product_name': nombre,
                'product_price': precio,
                'product_image': imagen,
              },
            );
          }


          Future<void> eliminarProducto(int id) async {
            await _api.enviar(
              'product_del_rest/',
              {
                'product_id': id,
              },
            );
          }
    }
