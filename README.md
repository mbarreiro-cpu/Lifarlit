
# Lifarlit 💊

## Descripción del proyecto

Lifarlit es una aplicación móvil desarrollada con Flutter y Dart, orientada a la consulta de productos de farmacia. Su propósito es ofrecer una interfaz sencilla y agradable para visualizar productos, consultar sus características y utilizar diferentes funciones del dispositivo móvil.

Este proyecto forma parte de una actividad académica de desarrollo de software móvil.

## Objetivo

Desarrollar una aplicación móvil que integre una interfaz organizada, navegación entre pantallas y servicios nativos del dispositivo, aplicando buenas prácticas de programación y almacenamiento local de información.

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
- Actualización del estado de conexión en tiempo real.
- Visualización de un aviso cuando no hay conexión de red.

### 5. Notificaciones locales
- Integración de notificaciones locales.
- Solicitud del permiso para mostrar notificaciones.
- Canal de notificaciones de Android.
- Botón para probar el funcionamiento de las notificaciones.

## Tecnologías utilizadas

- **Flutter:** framework para el desarrollo de aplicaciones móviles.
- **Dart:** lenguaje de programación.
- **Visual Studio Code:** entorno de desarrollo.
- **Android Studio:** herramientas para el desarrollo y ejecución en Android.
- **Git y GitHub:** control de versiones y alojamiento del código.

## Dependencias principales

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
├── screens/
│   ├── home_screen.dart
│   ├── detail_screen.dart
│   └── welcome_screen.dart
├── widgets/
│   └── product_card.dart
├── services/
│   ├── connectivity_service.dart
│   └── notification_service.dart
└── theme/
    └── app_theme.dart

assets/
└── icon/
    └── lifarlit_icon.png
```

## Arquitectura y gestión del estado

La aplicación está organizada por módulos para facilitar su mantenimiento:

- **Screens:** contienen las pantallas principales.
- **Widgets:** contienen componentes reutilizables.
- **Services:** gestionan servicios como conectividad y notificaciones.
- **Theme:** centraliza los estilos y colores de la aplicación.

Se utiliza StatefulWidget y setState para actualizar la interfaz cuando cambian los datos. SharedPreferences permite conservar la ruta de la fotografía guardada.

## Requisitos para ejecutar el proyecto

- Flutter instalado.
- Dart incluido con Flutter.
- Android Studio o Visual Studio Code.
- Un dispositivo Android o emulador configurado.

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

## Repositorio

Código fuente disponible en GitHub:

https://github.com/mbarreiro-cpu/Lifarlit

### Ramas de trabajo

- `main`: rama principal.
- `develop`: rama de desarrollo.

## Autor

**Meily Milena Barreiro González**

Proyecto académico desarrollado como parte de la actividad integradora de Desarrollo de Software Móvil con Flutter.
