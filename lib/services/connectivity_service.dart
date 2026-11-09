import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectivityService {
  final Connectivity _connectivity = Connectivity();

  // Escucha los cambios en la conexión del dispositivo.
  Stream<bool> get connectionStream {
    return _connectivity.onConnectivityChanged.map((results) {
      return results.any(
        (result) => result != ConnectivityResult.none,
      );
    });
  }

  // Comprueba el estado actual de la conexión.
  Future<bool> checkConnection() async {
    final results = await _connectivity.checkConnectivity();

    return results.any(
      (result) => result != ConnectivityResult.none,
    );
  }
}