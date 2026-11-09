
import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../widgets/product_card.dart';
import '../services/connectivity_service.dart';
import '../services/notification_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ConnectivityService _connectivityService =
      ConnectivityService();

  final ImagePicker _imagePicker = ImagePicker();

  StreamSubscription<bool>? _connectionSubscription;

  bool _isConnected = true;
  bool _isSendingNotification = false;

  File? _selectedImage;

  static const String _imageKey = 'saved_product_image';

  @override
  void initState() {
    super.initState();

    _loadSavedImage();
    _checkInitialConnection();

    _connectionSubscription =
        _connectivityService.connectionStream.listen((connected) {
      if (!mounted) return;

      setState(() {
        _isConnected = connected;
      });
    });
  }

  // Comprobar la conexión inicial.
  Future<void> _checkInitialConnection() async {
    final connected =
        await _connectivityService.checkConnection();

    if (!mounted) return;

    setState(() {
      _isConnected = connected;
    });
  }

  // Recuperar la fotografía guardada.
  Future<void> _loadSavedImage() async {
    try {
      final preferences = await SharedPreferences.getInstance();
      final imagePath = preferences.getString(_imageKey);

      if (imagePath == null) return;

      final imageFile = File(imagePath);

      if (await imageFile.exists() && mounted) {
        setState(() {
          _selectedImage = imageFile;
        });
      } else {
        await preferences.remove(_imageKey);
      }
    } catch (e) {
      debugPrint('Error al recuperar la fotografía: $e');
    }
  }

  // Guardar la fotografía en el almacenamiento privado.
  Future<void> _saveImage(File image) async {
    final directory = await getApplicationDocumentsDirectory();

    final savedFile = File(
      '${directory.path}${Platform.pathSeparator}lifarlit_product_image.jpg',
    );

    await image.copy(savedFile.path);

    final preferences = await SharedPreferences.getInstance();
    await preferences.setString(_imageKey, savedFile.path);

    if (!mounted) return;

    setState(() {
      _selectedImage = savedFile;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Fotografía guardada correctamente.'),
      ),
    );
  }

  // Eliminar la fotografía guardada.
  Future<void> _removeSavedImage() async {
    try {
      final preferences = await SharedPreferences.getInstance();
      final imagePath = preferences.getString(_imageKey);

      if (imagePath != null) {
        final imageFile = File(imagePath);

        if (await imageFile.exists()) {
          await imageFile.delete();
        }
      }

      await preferences.remove(_imageKey);

      if (!mounted) return;

      setState(() {
        _selectedImage = null;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Fotografía eliminada correctamente.'),
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error al eliminar la fotografía: $e'),
        ),
      );
    }
  }

  // Seleccionar una imagen desde la cámara o galería.
  Future<void> _selectImage(ImageSource source) async {
    try {
      if (source == ImageSource.camera) {
        final permission = await Permission.camera.request();

        if (!permission.isGranted) {
          if (!mounted) return;

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'Necesitas permitir el acceso a la cámara.',
              ),
            ),
          );

          return;
        }
      }

      final XFile? image = await _imagePicker.pickImage(
        source: source,
        imageQuality: 85,
        maxWidth: 1600,
      );

      if (image == null) return;

      final CroppedFile? croppedImage =
          await ImageCropper().cropImage(
        sourcePath: image.path,
        compressQuality: 85,
        uiSettings: [
          AndroidUiSettings(
            toolbarTitle: 'Recortar imagen',
            toolbarColor: const Color(0xFF1565C0),
            toolbarWidgetColor: Colors.white,
            activeControlsWidgetColor:
                const Color(0xFF1565C0),
          ),
          IOSUiSettings(
            title: 'Recortar imagen',
          ),
        ],
      );

      if (croppedImage == null || !mounted) return;

      await _saveImage(File(croppedImage.path));
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error al seleccionar la imagen: $e'),
        ),
      );
    }
  }

  // Mostrar las opciones de cámara y galería.
  void _showImageOptions() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(
                  Icons.camera_alt,
                  color: Color(0xFF1565C0),
                ),
                title: const Text('Tomar fotografía'),
                onTap: () {
                  Navigator.pop(context);
                  _selectImage(ImageSource.camera);
                },
              ),
              ListTile(
                leading: const Icon(
                  Icons.photo_library,
                  color: Color(0xFF1565C0),
                ),
                title: const Text('Seleccionar de la galería'),
                onTap: () {
                  Navigator.pop(context);
                  _selectImage(ImageSource.gallery);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  // Solicitar permiso y enviar una notificación de prueba.
  Future<void> _sendTestNotification() async {
    if (_isSendingNotification) return;

    setState(() {
      _isSendingNotification = true;
    });

    try {
      final permissionGranted =
          await NotificationService.requestPermission();

      if (!mounted) return;

      if (!permissionGranted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'No se concedió el permiso para las notificaciones.',
            ),
          ),
        );
        return;
      }

      await NotificationService.showTestNotification();

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Notificación enviada correctamente.',
          ),
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error al enviar la notificación: $e'),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isSendingNotification = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _connectionSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FB),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1565C0),
        foregroundColor: Colors.white,
        title: const Text(
          'Lifarlit',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Aviso de conexión a Internet.
          if (!_isConnected)
            Container(
              width: double.infinity,
              color: Colors.red.shade700,
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
              child: const Row(
                children: [
                  Icon(
                    Icons.wifi_off,
                    color: Colors.white,
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Sin conexión a Internet. Algunas funciones pueden no estar disponibles.',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),

          Expanded(
            child: SingleChildScrollView(
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

                  // Banner de bienvenida.
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

                  // Sección de cámara y galería.
                  const Text(
                    'Fotografía de producto',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF17365D),
                    ),
                  ),

                  const SizedBox(height: 12),

                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(
                        color: const Color(0xFFDCE5F0),
                      ),
                    ),
                    child: Column(
                      children: [
                        if (_selectedImage != null)
                          ClipRRect(
                            borderRadius: BorderRadius.circular(14),
                            child: Image.file(
                              _selectedImage!,
                              width: double.infinity,
                              height: 190,
                              fit: BoxFit.cover,
                            ),
                          )
                        else
                          Container(
                            width: double.infinity,
                            height: 150,
                            decoration: BoxDecoration(
                              color: const Color(0xFFEAF2FB),
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: const Column(
                              mainAxisAlignment:
                                  MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.add_a_photo,
                                  size: 48,
                                  color: Color(0xFF1565C0),
                                ),
                                SizedBox(height: 10),
                                Text(
                                  'No hay fotografías seleccionadas',
                                  style: TextStyle(
                                    color: Colors.black54,
                                  ),
                                ),
                              ],
                            ),
                          ),

                        const SizedBox(height: 16),

                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: _showImageOptions,
                            icon: const Icon(Icons.add_a_photo),
                            label: const Text(
                              'Seleccionar fotografía',
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  const Color(0xFF1565C0),
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                vertical: 14,
                              ),
                            ),
                          ),
                        ),

                        if (_selectedImage != null) ...[
                          const SizedBox(height: 8),
                          TextButton.icon(
                            onPressed: _removeSavedImage,
                            icon: const Icon(Icons.delete_outline),
                            label: const Text('Eliminar fotografía'),
                          ),
                        ],
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Categorías.
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

                  // Productos destacados.
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

                  // Botón de consulta general.
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

                 
const SizedBox(height: 12),

// Acceso a los productos obtenidos desde la API REST.
SizedBox(
  width: double.infinity,
  child: ElevatedButton.icon(
    onPressed: () {
      Navigator.pushNamed(
        context,
        '/productos-online',
      );
    },
    icon: const Icon(Icons.cloud_download),
    label: const Text('Consultar productos en línea'),
    style: ElevatedButton.styleFrom(
      backgroundColor: const Color(0xFF00897B),
      foregroundColor: Colors.white,
      padding: const EdgeInsets.symmetric(
        vertical: 15,
      ),
    ),
  ),
),

                  const SizedBox(height: 24),

                  // Sección de notificaciones locales.
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(
                        color: const Color(0xFFDCE5F0),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Row(
                          children: [
                            Icon(
                              Icons.notifications_active,
                              color: Color(0xFF1565C0),
                              size: 28,
                            ),
                            SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                'Notificaciones',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF17365D),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Prueba los avisos locales de la aplicación Lifarlit.',
                          style: TextStyle(
                            color: Colors.black54,
                          ),
                        ),
                        const SizedBox(height: 14),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: _isSendingNotification
                                ? null
                                : _sendTestNotification,
                            icon: _isSendingNotification
                                ? const SizedBox(
                                    width: 18,
                                    height: 18,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Colors.white,
                                    ),
                                  )
                                : const Icon(Icons.notifications),
                            label: Text(
                              _isSendingNotification
                                  ? 'Enviando...'
                                  : 'Probar notificación',
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  const Color(0xFF00897B),
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                vertical: 14,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
