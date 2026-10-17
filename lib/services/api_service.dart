
import 'dart:convert';

import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl =
      'http://143.198.118.203:8100/ejemplos/';

  static const String usuario = 'test';
  static const String contrasena = 'test2023';

  Map<String, String> get _headers {
    final credenciales = base64Encode(
      utf8.encode('$usuario:$contrasena'),
    );

    return {
      'Authorization': 'Basic $credenciales',
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
  }

  Future<dynamic> obtener(String endpoint) async {
    final url = Uri.parse('$baseUrl$endpoint');

    final respuesta = await http.get(
      url,
      headers: _headers,
    );

    if (respuesta.statusCode == 200) {
      return jsonDecode(utf8.decode(respuesta.bodyBytes));
    }

    throw Exception(
      'Error al consultar la API: ${respuesta.statusCode}',
    );
  }

  Future<dynamic> enviar(
    String endpoint,
    Map<String, dynamic> datos,
  ) async {
    final url = Uri.parse('$baseUrl$endpoint');

    final respuesta = await http.post(
      url,
      headers: _headers,
      body: jsonEncode(datos),
    );

    if (respuesta.statusCode >= 200 &&
        respuesta.statusCode < 300) {
      return jsonDecode(utf8.decode(respuesta.bodyBytes));
    }

    throw Exception(
      'Error al enviar datos: ${respuesta.statusCode}',
    );
  }
}
