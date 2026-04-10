import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:flutter/foundation.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'database_web_mock.dart';

class DatabaseHelper {
  static const _databaseName = 'san_alejo.db';
  static const _databaseVersion = 1;

  static const tableContenedor = 'contenedor';
  static const tableObjeto = 'objeto';

  static const columnContenedorId = 'id';
  static const columnContenedorNombre = 'nombre';
  static const columnContenedorDescripcion = 'descripcion';
  static const columnContenedorUbicacion = 'ubicacion';

  static const columnObjetoId = 'id';
  static const columnObjetoNombre = 'nombre';
  static const columnObjetoDescripcion = 'descripcion';
  static const columnObjetoIdContenedor = 'id_contenedor';

  static Database? _database;

  DatabaseHelper._privateConstructor();

  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    if (kIsWeb) {
      final db = WebDatabase();
      await db.initialize();
      await _onCreate(db, _databaseVersion);
      return db;
    } else {
      try {
        String path = join(await getDatabasesPath(), _databaseName);
        return await openDatabase(
          path,
          version: _databaseVersion,
          onCreate: _onCreate,
        );
      } catch (e) {
        return await openDatabase(
          ':memory:',
          version: _databaseVersion,
          onCreate: _onCreate,
        );
      }
    }
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS $tableContenedor (
        $columnContenedorId INTEGER PRIMARY KEY AUTOINCREMENT,
        $columnContenedorNombre TEXT NOT NULL,
        $columnContenedorDescripcion TEXT NOT NULL,
        $columnContenedorUbicacion TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE IF NOT EXISTS $tableObjeto (
        $columnObjetoId INTEGER PRIMARY KEY AUTOINCREMENT,
        $columnObjetoNombre TEXT NOT NULL,
        $columnObjetoDescripcion TEXT NOT NULL,
        $columnObjetoIdContenedor INTEGER NOT NULL,
        FOREIGN KEY ($columnObjetoIdContenedor) REFERENCES $tableContenedor($columnContenedorId) ON DELETE CASCADE
      )
    ''');
  }

  Future<void> close() async {
    Database db = await instance.database;
    await db.close();
  }
}
