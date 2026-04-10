# Taller Práctico — App "San Alejo" (Inventario de Objetos Guardados)

## Información General

| Campo | Detalle |
|-------|---------|
| Materia | Diseño Móvil |
| Tipo | Taller práctico individual (sin docente presente) |
| Duración | 2 horas |
| Tecnología | Libre (Kotlin/Jetpack Compose, Flutter, React Native, etc.) |
| Persistencia | SQLite (local, sin backend) |
| Entrega | Repositorio Git o APK funcional |

---

## Contexto — ¿Qué es un "San Alejo"?

En muchas casas hay un rincón, un closet o un cuarto donde se guardan cosas que casi nunca se usan: cajas con cables viejos, maletas con ropa de otra temporada, cajones con herramientas, bolsas con decoraciones navideñas...

El problema es que nadie recuerda qué hay dentro de cada caja. Cuando necesitas algo, terminas abriendo 5 cajas antes de encontrarlo.

**San Alejo** es una app que resuelve eso: te permite registrar tus contenedores (cajas, maletas, cajones, bolsas) y los objetos que hay dentro de cada uno, para que siempre sepas dónde está todo sin tener que abrir nada.

---

## Modelo de Datos

La app maneja dos entidades con una relación de uno a muchos: un contenedor tiene muchos objetos.

### CONTENEDOR

| Campo | Tipo | Descripción | Obligatorio |
|-------|------|-------------|-------------|
| `id` | INTEGER | Identificador único, autoincremental (PK) | Sí (auto) |
| `nombre` | TEXT | Nombre del contenedor (ej: "Caja cocina", "Maleta ropa invierno") | Sí |
| `descripcion` | TEXT | Descripción general de lo que contiene | Sí |
| `ubicacion` | TEXT | Dónde está físicamente (ej: "Closet cuarto principal", "Garaje estante 2") | Sí |

### OBJETO

| Campo | Tipo | Descripción | Obligatorio |
|-------|------|-------------|-------------|
| `id` | INTEGER | Identificador único, autoincremental (PK) | Sí (auto) |
| `nombre` | TEXT | Nombre del objeto (ej: "Cable HDMI", "Camisa azul") | Sí |
| `descripcion` | TEXT | Descripción o detalle adicional | Sí |
| `id_contenedor` | INTEGER | FK al contenedor donde está guardado | Sí |

### Relación

```
CONTENEDOR (1) ──────── (N) OBJETO
Un contenedor tiene muchos objetos.
Un objeto pertenece a un solo contenedor.
```

### Script SQL para crear las tablas

```sql
CREATE TABLE IF NOT EXISTS contenedor (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    nombre TEXT NOT NULL,
    descripcion TEXT NOT NULL,
    ubicacion TEXT NOT NULL
);

CREATE TABLE IF NOT EXISTS objeto (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    nombre TEXT NOT NULL,
    descripcion TEXT NOT NULL,
    id_contenedor INTEGER NOT NULL,
    FOREIGN KEY (id_contenedor) REFERENCES contenedor(id) ON DELETE CASCADE
);
```

---

## Qué hacer — Paso a paso

### Paso 1 — Crear el proyecto (10 min)

1. Crear un nuevo proyecto móvil con el nombre "SanAlejo".
2. Configurar la dependencia de SQLite según la tecnología elegida.
3. Crear la clase o helper de base de datos que ejecute los scripts de creación de tablas al iniciar la app.

---

### Paso 2 — Pantalla de lista de contenedores (30 min)

4. Crear una pantalla principal que muestre la lista de contenedores registrados.
5. Cada elemento de la lista debe mostrar: `nombre`, `descripcion` y `ubicacion`.
6. Incluir un botón flotante o un botón visible para "Agregar contenedor".
7. Si no hay contenedores registrados, mostrar un mensaje como: "No hay contenedores. Agrega tu primera caja, maleta o cajón."
8. Al tocar un contenedor de la lista, navegar a la pantalla de detalle de ese contenedor (Paso 4).

---

### Paso 3 — Formulario para crear/editar contenedor (20 min)

9. Crear un formulario (pantalla nueva o modal) con los campos: `nombre`, `descripcion`, `ubicacion`.
10. Al guardar, insertar el contenedor en la tabla `contenedor` de SQLite.
11. Después de guardar, volver a la lista de contenedores y que aparezca el nuevo registro.
12. Validar que los 3 campos no estén vacíos antes de guardar. Mostrar un mensaje si falta alguno.

---

### Paso 4 — Pantalla de detalle del contenedor (30 min)

13. Crear una pantalla que muestre el nombre, descripción y ubicación del contenedor seleccionado.
14. Debajo, mostrar la lista de objetos que pertenecen a ese contenedor (consulta: `SELECT * FROM objeto WHERE id_contenedor = ?`).
15. Cada objeto de la lista debe mostrar: `nombre` y `descripcion`.
16. Incluir un botón para "Agregar objeto" a este contenedor.
17. Si el contenedor no tiene objetos, mostrar: "Este contenedor está vacío. Agrega los objetos que hay dentro."

---

### Paso 5 — Formulario para crear/editar objeto (20 min)

18. Crear un formulario con los campos: `nombre` y `descripcion`.
19. Al guardar, insertar el objeto en la tabla `objeto` con el `id_contenedor` correspondiente.
20. Después de guardar, volver al detalle del contenedor y que aparezca el nuevo objeto en la lista.
21. Validar que ambos campos no estén vacíos.

---

### Paso 6 — Eliminar contenedores y objetos (10 min)

22. Permitir eliminar un objeto de la lista (puede ser con un botón, swipe o long press).
23. Permitir eliminar un contenedor completo desde la lista principal. Al eliminar un contenedor, se deben eliminar también todos sus objetos (`ON DELETE CASCADE`).
24. Mostrar una confirmación antes de eliminar.

---

## Ejemplo de Datos para Probar

Una vez terminada la app, registrar los siguientes datos para verificar que todo funciona:

**Contenedor 1:**
- Nombre: "Caja cocina"
- Descripción: "Electrodomésticos y utensilios que no uso seguido"
- Ubicación: "Alacena superior cocina"
- Objetos:
  - "Waflera" — "Waflera eléctrica marca Oster, funciona bien"
  - "Moldes navideños" — "Moldes de galletas en forma de estrella y árbol"
  - "Exprimidor" — "Exprimidor de naranjas manual, color verde"

**Contenedor 2:**
- Nombre: "Maleta ropa invierno"
- Descripción: "Ropa de clima frío que solo uso en viajes"
- Ubicación: "Closet cuarto principal, parte de arriba"
- Objetos:
  - "Chaqueta negra" — "Chaqueta North Face talla M"
  - "Bufanda gris" — "Bufanda de lana tejida"
  - "Guantes" — "Guantes térmicos negros"
  - "Gorro de lana" — "Gorro azul oscuro con pompón"

**Contenedor 3:**
- Nombre: "Cajón cables"
- Descripción: "Cables, cargadores y adaptadores varios"
- Ubicación: "Escritorio, segundo cajón"
- Objetos:
  - "Cable HDMI" — "Cable HDMI 2 metros, negro"
  - "Cargador Samsung viejo" — "Cargador micro USB, funciona"
  - "Adaptador USB-C" — "Adaptador USB-C a USB-A"

---

## Flujo de Navegación Esperado

```
┌─────────────────────────┐
│  Lista de Contenedores  │
│                         │
│  📦 Caja cocina         │
│     Alacena superior    │
│                         │
│  🧳 Maleta ropa invierno│
│     Closet cuarto...    │
│                         │
│  🗄️ Cajón cables        │
│     Escritorio, segundo │
│                         │
│              [+ Agregar]│
└────────┬────────────────┘
         │ tap en contenedor
         ▼
┌─────────────────────────┐
│  Detalle: Caja cocina   │
│  📍 Alacena superior    │
│                         │
│  Objetos:               │
│  • Waflera              │
│    Waflera eléctrica... │
│  • Moldes navideños     │
│    Moldes de galletas...│
│  • Exprimidor           │
│    Exprimidor manual... │
│                         │
│           [+ Agregar obj]│
└─────────────────────────┘
```

---

## Criterios de Evaluación

| Criterio | Puntos |
|----------|--------|
| Base de datos SQLite creada correctamente con las 2 tablas y la FK | 0.5 |
| Pantalla de lista de contenedores funcional (muestra datos de SQLite) | 0.5 |
| Formulario de crear contenedor funcional (inserta en SQLite) | 0.5 |
| Pantalla de detalle del contenedor con lista de objetos | 0.5 |
| Formulario de crear objeto funcional (inserta con FK correcta) | 0.5 |
| Eliminar objetos y contenedores con confirmación | 0.5 |
| Validación de campos vacíos en formularios | 0.5 |
| Navegación fluida entre pantallas (lista → detalle → formularios → volver) | 0.5 |
| Datos de prueba cargados correctamente (los 3 contenedores con sus objetos) | 0.5 |
| Código organizado y legible | 0.5 |
| **Total** | **5.0** |

---

## Restricciones

- Usar SQLite como persistencia local. No usar SharedPreferences, archivos JSON ni backend remoto.
- La app debe funcionar completamente offline.
- No usar IA generativa para escribir el código completo. Se revisará comprensión del código en la siguiente clase.
- Entregar en repositorio Git con README que indique: tecnología usada, cómo compilar y ejecutar.

---

## Recursos de Ayuda

### Si usas Kotlin (Android nativo)
- Clase `SQLiteOpenHelper` para crear y manejar la base de datos
- `ContentValues` para insertar datos
- `Cursor` para leer datos de las consultas

### Si usas Flutter
- Paquete `sqflite` para manejar SQLite
- `openDatabase()` para crear/abrir la base de datos
- `db.insert()`, `db.query()`, `db.delete()` para las operaciones

### Si usas React Native
- Paquete `expo-sqlite` o `react-native-sqlite-storage`
- `db.executeSql()` para ejecutar consultas

---

## Checklist Final (verificar antes de entregar)

```
[ ] La app compila y corre sin errores
[ ] Puedo crear un contenedor nuevo y aparece en la lista
[ ] Puedo tocar un contenedor y ver su detalle con los objetos
[ ] Puedo agregar objetos a un contenedor
[ ] Puedo eliminar un objeto
[ ] Puedo eliminar un contenedor y sus objetos se eliminan también
[ ] Si un campo está vacío, la app me avisa y no guarda
[ ] Los datos persisten al cerrar y abrir la app (SQLite)
[ ] Cargué los 3 contenedores de prueba con sus objetos
[ ] El README indica cómo ejecutar el proyecto