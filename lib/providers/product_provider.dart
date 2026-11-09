
import 'package:flutter/foundation.dart';

import '../models/product_model.dart';
import '../services/product_api_service.dart';

// Estados posibles de la consulta.
enum ProductStatus {
  initial,
  loading,
  success,
  error,
}

class ProductProvider extends ChangeNotifier {
  final ProductApiService _apiService = ProductApiService();

  // Lista de productos recibidos de la API.
  List<ProductModel> _products = [];

  // Estado actual de la consulta.
  ProductStatus _status = ProductStatus.initial;

  // Mensaje para mostrar cuando ocurre un error.
  String? _errorMessage;

  // Obtener la lista de productos.
  List<ProductModel> get products => _products;

  // Obtener el estado actual.
  ProductStatus get status => _status;

  // Obtener el mensaje de error.
  String? get errorMessage => _errorMessage;

  // Consultar los productos de la API.
  Future<void> fetchProducts() async {
    _status = ProductStatus.loading;
    _errorMessage = null;

    notifyListeners();

    try {
      _products = await _apiService.fetchProducts();

      _status = ProductStatus.success;
    } catch (e) {
      _errorMessage = e.toString().replaceFirst(
        'Exception: ',
        '',
      );

      _status = ProductStatus.error;
    }

    notifyListeners();
  }
}
