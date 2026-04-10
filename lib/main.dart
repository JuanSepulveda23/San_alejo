import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'screens/contenedores_list_screen.dart';
import 'database/database_helper.dart';
import 'models/contenedor.dart';
import 'models/objeto.dart';
import 'repositories/contenedor_repository.dart';
import 'repositories/objeto_repository.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  if (!kIsWeb) {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  }
  
  await DatabaseHelper.instance.database;
  await _loadTestDataIfNeeded();
  
  runApp(const MyApp());
}

Future<void> _loadTestDataIfNeeded() async {
  final conRepository = ContenedorRepository();
  final objRepository = ObjetoRepository();
  
  try {
    final existingContenedores = await conRepository.getAllContenedores();
    
    if (existingContenedores.isNotEmpty) {
      return;
    }
    
    final contenedor1 = Contenedor(
      nombre: 'Caja cocina',
      descripcion: 'Electrodomésticos y utensilios que no uso seguido',
      ubicacion: 'Alacena superior cocina',
    );
    final id1 = await conRepository.insertContenedor(contenedor1);
    
    await objRepository.insertObjeto(Objeto(
      nombre: 'Waflera',
      descripcion: 'Waflera eléctrica marca Oster, funciona bien',
      idContenedor: id1,
    ));
    
    await objRepository.insertObjeto(Objeto(
      nombre: 'Moldes navideños',
      descripcion: 'Moldes de galletas en forma de estrella y árbol',
      idContenedor: id1,
    ));
    
    await objRepository.insertObjeto(Objeto(
      nombre: 'Exprimidor',
      descripcion: 'Exprimidor de naranjas manual, color verde',
      idContenedor: id1,
    ));
    
    final contenedor2 = Contenedor(
      nombre: 'Maleta ropa invierno',
      descripcion: 'Ropa de clima frío que solo uso en viajes',
      ubicacion: 'Closet cuarto principal, parte de arriba',
    );
    final id2 = await conRepository.insertContenedor(contenedor2);
    
    await objRepository.insertObjeto(Objeto(
      nombre: 'Chaqueta negra',
      descripcion: 'Chaqueta North Face talla M',
      idContenedor: id2,
    ));
    
    await objRepository.insertObjeto(Objeto(
      nombre: 'Bufanda gris',
      descripcion: 'Bufanda de lana tejida',
      idContenedor: id2,
    ));
    
    await objRepository.insertObjeto(Objeto(
      nombre: 'Guantes',
      descripcion: 'Guantes térmicos negros',
      idContenedor: id2,
    ));
    
    await objRepository.insertObjeto(Objeto(
      nombre: 'Gorro de lana',
      descripcion: 'Gorro azul oscuro con pompón',
      idContenedor: id2,
    ));
    
    final contenedor3 = Contenedor(
      nombre: 'Cajón cables',
      descripcion: 'Cables, cargadores y adaptadores varios',
      ubicacion: 'Escritorio, segundo cajón',
    );
    final id3 = await conRepository.insertContenedor(contenedor3);
    
    await objRepository.insertObjeto(Objeto(
      nombre: 'Cable HDMI',
      descripcion: 'Cable HDMI 2 metros, negro',
      idContenedor: id3,
    ));
    
    await objRepository.insertObjeto(Objeto(
      nombre: 'Cargador Samsung viejo',
      descripcion: 'Cargador micro USB, funciona',
      idContenedor: id3,
    ));
    
    await objRepository.insertObjeto(Objeto(
      nombre: 'Adaptador USB-C',
      descripcion: 'Adaptador USB-C a USB-A',
      idContenedor: id3,
    ));
  } catch (e) {
    // Silently fail if data loading has issues
  }
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'San Alejo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
        appBarTheme: const AppBarTheme(
          centerTitle: true,
          elevation: 0,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
      ),
      home: const ContenedoresListScreen(),
    );
  }
}
