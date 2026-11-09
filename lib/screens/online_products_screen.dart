
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/product_model.dart';
import '../providers/product_provider.dart';

class OnlineProductsScreen extends StatefulWidget {
  const OnlineProductsScreen({super.key});

  @override
  State<OnlineProductsScreen> createState() =>
      _OnlineProductsScreenState();
}

class _OnlineProductsScreenState
    extends State<OnlineProductsScreen> {

  @override
  void initState() {
    super.initState();

    // Cargar los productos al abrir la pantalla.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProductProvider>().fetchProducts();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ProductProvider>();

    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FB),
      appBar: AppBar(
        title: const Text(
          'Productos en línea',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFF1565C0),
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: RefreshIndicator(
        color: const Color(0xFF1565C0),
        onRefresh: () {
          return context.read<ProductProvider>().fetchProducts();
        },
        child: _buildContent(provider),
      ),
    );
  }

  Widget _buildContent(ProductProvider provider) {
    switch (provider.status) {

      // Estado de carga.
      case ProductStatus.initial:
      case ProductStatus.loading:
        return ListView(
          physics: AlwaysScrollableScrollPhysics(),
          children: [
            SizedBox(height: 180),
            Center(
              child: CircularProgressIndicator(),
            ),
            SizedBox(height: 20),
            Center(
              child: Text('Cargando productos...'),
            ),
          ],
        );

      // Estado de éxito.
      case ProductStatus.success:
        if (provider.products.isEmpty) {
          return ListView(
            physics: AlwaysScrollableScrollPhysics(),
            children: [
              SizedBox(height: 180),
              Icon(Icons.inventory_2_outlined, size: 60),
              Center(child: Text('No hay productos disponibles.')),
            ],
          );
        }

        return ListView.builder(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16),
          itemCount: provider.products.length,
          itemBuilder: (context, index) {
            final product = provider.products[index];

            return _buildProductCard(product);
          },
        );

      // Estado de error.
      case ProductStatus.error:
        return ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(24),
          children: [
            const SizedBox(height: 120),
            const Icon(
              Icons.cloud_off,
              size: 65,
              color: Colors.red,
            ),
            const SizedBox(height: 16),
            const Center(
              child: Text(
                'No se pudieron cargar los productos',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 10),
            Center(
              child: Text(
                provider.errorMessage ?? 'Error desconocido',
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.black54),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () {
                context.read<ProductProvider>().fetchProducts();
              },
              icon: const Icon(Icons.refresh),
              label: const Text('Intentar nuevamente'),
            ),
          ],
        );
    }
  }

  // Tarjeta visual para cada producto.
  Widget _buildProductCard(ProductModel product) {
    return Card(
      color: Colors.white,
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                product.thumbnail,
                width: 105,
                height: 105,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: 105,
                    height: 105,
                    color: const Color(0xFFEAF2FB),
                    child: const Icon(
                      Icons.image_not_supported,
                      color: Color(0xFF1565C0),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF17365D),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    product.description,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.black54,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '\$${product.price.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF00897B),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(
                        Icons.star,
                        color: Colors.amber,
                        size: 17,
                      ),
                      const SizedBox(width: 4),
                      Text(product.rating.toString()),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
