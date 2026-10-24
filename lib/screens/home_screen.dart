
import 'package:flutter/material.dart';
import '../widgets/product_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FB),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1565C0),
        foregroundColor: Colors.white,
        title: const Text(
          'Lifarlit',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '¡Bienvenido a Lifarlit!',
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
                color: Color(0xFF17365D),
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Tu espacio para consultar productos de farmacia.',
              style: TextStyle(
                fontSize: 15,
                color: Colors.black54,
              ),
            ),
            const SizedBox(height: 20),

            // Banner de bienvenida
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFF1565C0),
                borderRadius: BorderRadius.circular(18),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.local_pharmacy,
                    color: Colors.white,
                    size: 42,
                  ),
                  SizedBox(height: 12),
                  Text(
                    'Cuidamos de ti',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 6),
                  Text(
                    'Encuentra información de nuestros productos.',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Categorías
            const Text(
              'Categorías',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF17365D),
              ),
            ),
            const SizedBox(height: 12),

            Row(
              children: [
                Expanded(
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 16,
                      ),
                      child: Column(
                        children: const [
                          Icon(
                            Icons.medication,
                            color: Color(0xFF1565C0),
                            size: 30,
                          ),
                          SizedBox(height: 8),
                          Text('Vitaminas'),
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 16,
                      ),
                      child: Column(
                        children: const [
                          Icon(
                            Icons.sanitizer,
                            color: Color(0xFF1565C0),
                            size: 30,
                          ),
                          SizedBox(height: 8),
                          Text('Higiene'),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Productos destacados
            const Text(
              'Productos destacados',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF17365D),
              ),
            ),
            const SizedBox(height: 12),

            ProductCard(
              nombre: 'Vitamina C',
              descripcion: 'Suplemento vitamínico',
              precio: '\$5.50',
              onTap: () {
                Navigator.pushNamed(
                  context,
                  '/detalle',
                  arguments: {
                    'nombre': 'Vitamina C',
                    'descripcion':
                        'Suplemento vitamínico de consulta.',
                    'precio': 5.50,
                  },
                );
              },
            ),

            ProductCard(
              nombre: 'Alcohol antiséptico',
              descripcion: 'Producto para uso externo',
              precio: '\$2.25',
              onTap: () {
                Navigator.pushNamed(
                  context,
                  '/detalle',
                  arguments: {
                    'nombre': 'Alcohol antiséptico',
                    'descripcion':
                        'Producto para limpieza externa.',
                    'precio': 2.25,
                  },
                );
              },
            ),

            const SizedBox(height: 20),

            // Botón de consulta general
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.pushNamed(
                    context,
                    '/detalle',
                    arguments: {
                      'nombre': 'Consulta de productos',
                      'descripcion':
                          'Revisa la información y envía una consulta.',
                      'precio': 0.0,
                    },
                  );
                },
                icon: const Icon(Icons.search),
                label: const Text('Consultar productos'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1565C0),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    vertical: 15,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
