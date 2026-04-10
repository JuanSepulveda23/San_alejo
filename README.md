# San Alejo - Inventory Management App

Una aplicación móvil para inventariar objetos guardados en contenedores (cajas, maletas, cajones, bolsas). ¡Nunca más abras 5 cajas para encontrar lo que buscas!

## 📋 Descripción

San Alejo resuelve un problema cotidiano: cuando guardamos cosas en un contenedor, frecuentemente olvidamos qué hay dentro. Esta app te permite:

- 📦 Registrar contenedores (cajas, maletas, cajones, bolsas)
- 📝 Listar los objetos que hay dentro de cada contenedor
- 🔍 Buscar rápidamente dónde está cada cosa
- 📍 Registrar la ubicación física de cada contenedor
- 🗑️ Eliminar contenedores y objetos cuando sea necesario

## 🛠️ Tecnología

- **Framework**: Flutter 3.0+
- **Lenguaje**: Dart
- **Base de Datos**: SQLite (local, sin internet)
- **Persistencia**: Datos guardados en el dispositivo

## 📦 Requisitos Previos

Antes de empezar, asegúrate de tener instalado:

1. **Flutter SDK** (versión 3.0 o superior)
   - Descarga desde: https://flutter.dev/docs/get-started/install
   - Verifica: `flutter --version`

2. **Dart SDK** (incluido con Flutter)
   - Verifica: `dart --version`

3. **Un dispositivo o emulador Android/iOS**
   - Emulador de Android: `flutter emulators --launch <emulator_id>`
   - Emulador de iOS: Xcode es necesario en Mac

## 🚀 Instalación y Ejecución

### 1. Clonar el repositorio

```bash
git clone <url-del-repositorio>
cd "App san alejo"
```

### 2. Instalar dependencias

```bash
flutter pub get
```

### 3. Ejecutar la app

**En emulador/dispositivo Android:**
```bash
flutter run
```

**En emulador iOS (solo Mac):**
```bash
flutter run -d iOS
```

**Com especificar un dispositivo:**
```bash
flutter run -d <device_id>
# Lista dispositivos disponibles:
flutter devices
```

### 4. Compilar APK (Android)

```bash
flutter build apk --release
# El APK se genera en: build/app/outputs/flutter-apk/app-release.apk
```

### 5. Compilar IPA (iOS, solo Mac)

```bash
flutter build ios --release
```

## 📱 Estructura de la Aplicación

```
san_alejo/
├── lib/
│   ├── main.dart                          # Punto de entrada
│   ├── models/
│   │   ├── contenedor.dart                # Modelo de contenedor
│   │   └── objeto.dart                    # Modelo de objeto
│   ├── database/
│   │   └── database_helper.dart           # Inicialización de SQLite
│   ├── repositories/
│   │   ├── contenedor_repository.dart     # CRUD de contenedores
│   │   └── objeto_repository.dart         # CRUD de objetos
│   └── screens/
│       ├── contenedores_list_screen.dart  # Lista principal
│       ├── contenedor_detail_screen.dart  # Detalles y objetos
│       ├── contenedor_form_screen.dart    # Formulario de contenedor
│       └── objeto_form_screen.dart        # Formulario de objeto
├── pubspec.yaml                           # Dependencias
└── README.md                              # Este archivo
```

## 📊 Modelo de Datos

### Tabla: CONTENEDOR
| Campo | Tipo | Descripción |
|-------|------|-------------|
| id | INTEGER | ID único (PK) |
| nombre | TEXT | Nombre del contenedor |
| descripcion | TEXT | Qué contiene |
| ubicacion | TEXT | Dónde está guardado |

### Tabla: OBJETO
| Campo | Tipo | Descripción |
|-------|------|-------------|
| id | INTEGER | ID único (PK) |
| nombre | TEXT | Nombre del objeto |
| descripcion | TEXT | Detalles del objeto |
| id_contenedor | INTEGER | FK a contenedor |

## 🔄 Flujo de Navegación

```
Lista de Contenedores
    ├── Ver detalles (tap en contenedor)
    │   ├── Lista de objetos
    │   ├── Agregar objeto (formulario)
    │   └── Eliminar objeto
    ├── Agregar contenedor (botón FAB)
    │   └── Formulario
    └── Eliminar contenedor (menú)
```

## ✨ Características Principales

- ✅ Crear, leer, actualizar y eliminar contenedores
- ✅ Crear, leer y eliminar objetos dentro de contenedores
- ✅ Validación de campos obligatorios
- ✅ Confirmación antes de eliminar
- ✅ Datos persisten en SQLite
- ✅ Interfaz intuitiva con Material Design 3
- ✅ Datos de prueba precargados en primer inicio

## 🧪 Datos de Prueba

La app carga automáticamente 3 contenedores de ejemplo en el primer inicio:

1. **Caja cocina** - Electrodomésticos sin usar
2. **Maleta ropa invierno** - Ropa de clima frío
3. **Cajón cables** - Cables y adaptadores diversos

Para resetear los datos: Elimina la base de datos en:
- Android: `Sistema > Aplicaciones > San Alejo > Almacenamiento > Borrar datos`
- iOS: Desinstala y reinstala la app

## 🔧 Comandos Útiles

```bash
# Ver logs
flutter logs

# Ejecutar en modo debug
flutter run --debug

# Ejecutar en modo release
flutter run --release

# Limpiar y reconstruir
flutter clean
flutter pub get
flutter run

# Generar APK para distribución
flutter build apk --release --split-per-abi

# Analizar code coverage
flutter test --coverage

# Formatear código
dart format lib/

# Analizar problemas de código
flutter analyze
```

## 📝 Checklist de Funcionamiento

Antes de entregar, verifica que:

- [ ] La app compila sin errores
- [ ] Los 3 contenedores de prueba aparecen al iniciar
- [ ] Puedo crear un nuevo contenedor
- [ ] Puedo ver los detalles y objetos de un contenedor
- [ ] Puedo agregar objetos a un contenedor
- [ ] Puedo eliminar un objeto (con confirmación)
- [ ] Puedo eliminar un contenedor (con confirmación)
- [ ] Los datos persisten al cerrar y abrir la app
- [ ] Las validaciones funcionan (no permite campos vacíos)
- [ ] La navegación es fluida

## 🐛 Solución de Problemas

### "flutter: command not found"
```bash
# Asegúrate de agregar Flutter al PATH
export PATH="$PATH:/ruta/a/flutter/bin"
```

### "Emulator not found"
```bash
# Lista emuladores disponibles
flutter emulators

# Ejecuta uno
flutter emulators --launch <nombre>
```

### "Error al acceder a la base de datos"
- Verifica permisos de almacenamiento en el dispositivo
- Limpia la caché: `flutter clean`
- Reinstala la app

### "Errores de compilación"
```bash
flutter clean
flutter pub get
flutter run
```

## 📚 Recursos Útiles

- [Documentación oficial de Flutter](https://flutter.dev/docs)
- [SQLite en Flutter (sqflite)](https://pub.dev/packages/sqflite)
- [Material Design 3](https://m3.material.io/)
- [Dart Documentation](https://dart.dev/guides)

## 👨‍💻 Autor

Taller Práctico - Diseño Móvil
Materia: Diseño Móvil
Tipo: Taller práctico individual

## 📄 Licencia

Este proyecto es un taller educativo. Puedes usarlo libremente.

---

**¿Preguntas?** Revisa la documentación oficial de Flutter o consulta a tu instructor.

**Happy Coding! 🚀**
