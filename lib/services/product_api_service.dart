
import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/product_model.dart';

class ProductApiService {
  // Dirección de la API REST pública.
  static const String _url =
      'https://dummyjson.com/products/category/skin-care';

  // Obtener los productos desde Internet.
  Future<List<ProductModel>> fetchProducts() async {
    try {
      final response = await http
          .get(Uri.parse(_url))
          .timeout(const Duration(seconds: 15));

      // Comprobar si la solicitud fue exitosa.
      if (response.statusCode == 200) {
        final Map<String, dynamic> data =
            jsonDecode(response.body);

        final List<dynamic> productsJson = data['products'];

        return productsJson.map((product) {
          return ProductModel.fromJson(
            product as Map<String, dynamic>,
          );
        }).toList();
      } else {
        throw Exception(
          'Error del servidor: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception(
        'No se pudieron cargar los productos. Verifica tu conexión a Internet. Detalle: $e',
      );
    }
  }
}
