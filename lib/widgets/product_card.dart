import 'package:flutter/material.dart';

class ProductCard extends StatelessWidget {
  final String nombre;
  final String descripcion;
  final String precio;
  final VoidCallback onTap;

  const ProductCard({
    super.key,
    required this.nombre,
    required this.descripcion,
    required this.precio,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: const CircleAvatar(
          child: Icon(Icons.medical_services_outlined),
        ),
        title: Text(nombre),
        subtitle: Text(descripcion),
        trailing: Text(
          precio,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.blue,
          ),
        ),
        onTap: onTap,
      ),
    );
  }
}
