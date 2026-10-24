
import 'package:flutter/material.dart';

class DetailScreen extends StatefulWidget {
  const DetailScreen({super.key});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  final TextEditingController nombreController = TextEditingController();
  final TextEditingController consultaController = TextEditingController();

  @override
  void dispose() {
    nombreController.dispose();
    consultaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final argumentos =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;

    final String nombre = argumentos['nombre'] as String;
    final String descripcion = argumentos['descripcion'] as String;
    final double precio = (argumentos['precio'] as num).toDouble();

    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FB),
      appBar: AppBar(
        title: const Text('Detalle del producto'),
        backgroundColor: const Color(0xFF1565C0),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 110,
                height: 110,
                decoration: BoxDecoration(
                  color: const Color(0xFFE3F2FD),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: const Icon(
                  Icons.medication,
                  size: 65,
                  color: Color(0xFF1565C0),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              nombre,
              style: const TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
                color: Color(0xFF17365D),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              descripcion,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            Card(
              child: ListTile(
                leading: const Icon(
                  Icons.payments_outlined,
                  color: Color(0xFF1565C0),
                ),
                title: const Text('Precio referencial'),
                subtitle: Text(
                  precio == 0
                      ? 'Consulta general'
                      : '\$${precio.toStringAsFixed(2)}',
                ),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Formulario de consulta',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: nombreController,
              decoration: const InputDecoration(
                labelText: 'Tu nombre',
                prefixIcon: Icon(Icons.person_outline),
                border: OutlineInputBorder(),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
            const SizedBox(height: 14),
            TextField(
              controller: consultaController,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: 'Escribe tu consulta',
                hintText: '¿Qué deseas consultar?',
                prefixIcon: Icon(Icons.message_outlined),
                border: OutlineInputBorder(),
                filled: true,
                fillColor: Colors.white,
                alignLabelWithHint: true,
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  if (nombreController.text.trim().isEmpty ||
                      consultaController.text.trim().isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Completa los dos campos, por favor.'),
                      ),
                    );
                    return;
                  }

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Consulta registrada en esta sesión.'),
                    ),
                  );
                },
                icon: const Icon(Icons.send),
                label: const Text('Enviar consulta'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1565C0),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                ),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.arrow_back),
                label: const Text('Volver al inicio'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
