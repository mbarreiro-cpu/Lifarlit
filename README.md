# Lifarlit 💊

## Descripción del proyecto

Lifarlit es una aplicación móvil desarrollada con Flutter y Dart, orientada a la consulta de productos de farmacia y cuidado personal. Su propósito es ofrecer una interfaz sencilla y agradable para visualizar productos, consultar sus características y utilizar diferentes funciones del dispositivo móvil.

Este proyecto forma parte de las actividades académicas de Desarrollo de Software Móvil.

## Objetivo

Desarrollar una aplicación móvil que integre una interfaz organizada, navegación entre pantallas, servicios nativos del dispositivo, almacenamiento local y consumo de una API REST pública, aplicando buenas prácticas de programación y gestión de estados.

## Funcionalidades principales

### 1. Catálogo de productos
- Pantalla principal con mensaje de bienvenida.
- Categorías de Vitaminas e Higiene.
- Visualización de productos destacados.
- Información de nombre, descripción y precio.
- Navegación hacia la pantalla de detalle.

### 2. Cámara y galería
- Selección de fotografías desde la cámara.
- Selección de imágenes desde la galería.
- Solicitud de permisos necesarios.
- Recorte de fotografías antes de guardarlas.
- Vista previa de la imagen seleccionada.

### 3. Almacenamiento local
- Guardado de fotografías en el almacenamiento interno de la aplicación.
- Conservación de la ruta de la imagen mediante SharedPreferences.
- Recuperación de la fotografía al volver a abrir la aplicación.
- Opción para eliminar la fotografía guardada.

### 4. Conectividad
- Detección de cambios en el estado de conectividad.
- Actualización del estado de conexión.
- Visualización de un aviso cuando no hay conexión de red.

### 5. Notificaciones locales
- Integración de notificaciones locales.
- Solicitud del permiso para mostrar notificaciones.
- Canal de notificaciones de Android.
- Botón para probar el funcionamiento de las notificaciones.

### 6. Integración de API REST
- Consulta de productos mediante una API REST pública.
- Solicitudes HTTP GET utilizando el paquete `http`.
- Obtención de productos de la categoría Skin Care.
- Conversión de datos JSON a objetos Dart mediante el modelo ProductModel.
- Visualización de imágenes, nombres, descripciones, precios y calificaciones.
- Actualización manual de los productos mediante Pull-to-Refresh.
- Manejo de los estados Loading, Success y Error.
- Gestión del estado mediante Provider.

## API REST utilizada

**Nombre:** DummyJSON.

**Documentación:** https://dummyjson.com/docs/products

**Endpoint utilizado:**

https://dummyjson.com/products/category/skin-care

Esta API proporciona datos de ejemplo de productos para realizar pruebas de consumo de servicios REST. No representa un inventario real de productos farmacéuticos ni precios comerciales.

## Arquitectura y gestión del estado

La aplicación está organizada por módulos para facilitar su mantenimiento y comprensión.

Para la integración de la API REST se utiliza Provider mediante ChangeNotifier.

El funcionamiento de la consulta sigue este proceso:

1. La pantalla solicita los productos.
2. ProductProvider cambia el estado a Loading.
3. ProductApiService realiza una petición HTTP GET.
4. La respuesta JSON se convierte en objetos ProductModel.
5. Provider actualiza el estado a Success cuando los datos se reciben correctamente.
6. Si ocurre un problema de conexión o servidor, se establece el estado Error y se muestra un mensaje al usuario.

Los estados implementados son:

- **Loading:** indica que los productos se están cargando.
- **Success:** muestra los productos obtenidos desde la API.
- **Error:** informa que ocurrió un problema y permite volver a intentar la consulta.

También se utiliza StatefulWidget y setState para actualizar determinadas funciones locales de la aplicación. SharedPreferences permite conservar la ruta de la fotografía guardada.

## Tecnologías utilizadas

- **Flutter:** framework para el desarrollo de aplicaciones móviles.
- **Dart:** lenguaje de programación.
- **Visual Studio Code:** entorno de desarrollo.
- **Android Studio:** herramientas para el desarrollo y ejecución en Android.
- **Git y GitHub:** control de versiones y alojamiento del código.
- **DummyJSON:** API REST pública para obtener datos de prueba.

## Dependencias principales

- `http`: realización de solicitudes HTTP.
- `provider`: gestión del estado de la aplicación.
- `connectivity_plus`: detección de conectividad.
- `image_picker`: selección de imágenes desde cámara o galería.
- `image_cropper`: recorte de fotografías.
- `permission_handler`: gestión de permisos.
- `path_provider`: acceso a directorios de almacenamiento.
- `shared_preferences`: almacenamiento de preferencias locales.
- `flutter_local_notifications`: notificaciones locales.

También se utilizan herramientas para generar el icono y la pantalla de inicio de la aplicación.

## Estructura del proyecto

```text
lib/
├── main.dart
├── models/
│   └── product_model.dart
├── providers/
│   └── product_provider.dart
├── screens/
│   ├── home_screen.dart
│   ├── detail_screen.dart
│   ├── welcome_screen.dart
│   └── online_products_screen.dart
├── widgets/
│   └── product_card.dart
├── services/
│   ├── connectivity_service.dart
│   ├── notification_service.dart
│   └── product_api_service.dart
└── theme/
    └── app_theme.dart

assets/
└── icon/
    └── lifarlit_icon.png
```

## Requisitos para ejecutar el proyecto

- Flutter instalado.
- Dart incluido con Flutter.
- Android Studio o Visual Studio Code.
- Un dispositivo Android o emulador configurado.
- Conexión a Internet para consultar la API REST.

## Instalación y ejecución

Clonar el repositorio:

```bash
git clone https://github.com/mbarreiro-cpu/Lifarlit.git
```

Ingresar a la carpeta:

```bash
cd Lifarlit
```

Instalar las dependencias:

```bash
flutter pub get
```

Verificar el proyecto:

```bash
flutter analyze
```

Ejecutar la aplicación en un dispositivo Android conectado:

```bash
flutter run
```

## Consideraciones

- El formulario de consulta muestra una confirmación en pantalla, pero no envía información a un servidor.
- Las fotografías se guardan localmente en el dispositivo.
- Las notificaciones implementadas son locales; no requieren un servidor de notificaciones.
- La detección de conectividad identifica el estado de la conexión de red, pero no garantiza por sí sola el acceso a Internet.
- Los productos obtenidos mediante DummyJSON son datos de ejemplo.
- La consulta a la API requiere conexión a Internet.

## Repositorio

Código fuente disponible en GitHub:

https://github.com/mbarreiro-cpu/Lifarlit

### Ramas de trabajo

- `main`: rama principal.
- `develop`: rama de desarrollo.
- `feature/api-integration`: rama con la integración de API REST y Provider.

## Autor

**Meily Milena Barreiro González**

Proyecto académico desarrollado como parte de las actividades integradoras de Desarrollo de Software Móvil con Flutter.