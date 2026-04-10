# Guía de Instalación - San Alejo

## Requisitos Previos

Necesitas tener Flutter instalado en tu computadora.

```bash
flutter --version
```

Si no lo tienes, descárgalo desde: https://flutter.dev/docs/get-started/install

## Pasos para Ejecutar

### 1. Entra a la carpeta del proyecto

```bash
cd /home/sebastiansc/Desktop/san_alejo
```

### 2. Instala las dependencias

```bash
flutter pub get
```

### 3. Ejecuta la app

**En Chrome (web):**
```bash
flutter run -d chrome
```

**En Android:**
```bash
flutter run
```

**En iPhone (Mac):**
```bash
flutter run -d ios
```

## ¿Qué debería ver?

Cuando abras la app, deberías ver:
- 3 contenedores pre-cargados (Caja cocina, Maleta ropa invierno, Cajón cables)
- Un listado de objetos dentro de cada contenedor
- Botones para crear, editar y eliminar

## Acceso desde iPhone

Si quieres ver la app desde tu iPhone en la misma red:

```bash
flutter run -d chrome --web-hostname=0.0.0.0 --web-port=8080
```

Luego abre en Safari: `http://TU_IP_LOCAL:8080`

(Tu IP local: `ifconfig | grep inet`)

## Problemas Comunes

**"flutter: command not found"**
- Asegúrate de tener Flutter en el PATH
- O usa la ruta completa donde lo instalaste

**"No se ve nada"**
- Espera a que compile (puede tardar 30 segundos)
- Refresca la página en el navegador

**"Puerto 8080 en uso"**
- Usa otro puerto: `--web-port=8081`

¡Eso es! Ya está. 🎉

