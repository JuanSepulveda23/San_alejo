import 'package:sqflite/sqflite.dart';
import '../database/database_helper.dart';
import '../models/contenedor.dart';

class ContenedorRepository {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  // Create
  Future<int> insertContenedor(Contenedor contenedor) async {
    try {
      Database db = await _dbHelper.database;
      return await db.insert(
        DatabaseHelper.tableContenedor,
        contenedor.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (e) {
      throw Exception('Error al insertar contenedor: $e');
    }
  }

  // Read all
  Future<List<Contenedor>> getAllContenedores() async {
    try {
      Database db = await _dbHelper.database;
      List<Map<String, dynamic>> maps = await db.query(
        DatabaseHelper.tableContenedor,
        orderBy: '${DatabaseHelper.columnContenedorNombre} ASC',
      );

      if (maps.isEmpty) {
        return [];
      }

      return List.generate(maps.length, (i) => Contenedor.fromMap(maps[i]));
    } catch (e) {
      throw Exception('Error al obtener contenedores: $e');
    }
  }

  // Read by ID
  Future<Contenedor?> getContenedorById(int id) async {
    try {
      Database db = await _dbHelper.database;
      List<Map<String, dynamic>> maps = await db.query(
        DatabaseHelper.tableContenedor,
        where: '${DatabaseHelper.columnContenedorId} = ?',
        whereArgs: [id],
      );

      if (maps.isEmpty) {
        return null;
      }

      return Contenedor.fromMap(maps.first);
    } catch (e) {
      throw Exception('Error al obtener contenedor: $e');
    }
  }

  // Update
  Future<int> updateContenedor(Contenedor contenedor) async {
    try {
      Database db = await _dbHelper.database;
      return await db.update(
        DatabaseHelper.tableContenedor,
        contenedor.toMap(),
        where: '${DatabaseHelper.columnContenedorId} = ?',
        whereArgs: [contenedor.id],
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (e) {
      throw Exception('Error al actualizar contenedor: $e');
    }
  }

  // Delete
  Future<int> deleteContenedor(int id) async {
    try {
      Database db = await _dbHelper.database;
      return await db.delete(
        DatabaseHelper.tableContenedor,
        where: '${DatabaseHelper.columnContenedorId} = ?',
        whereArgs: [id],
      );
    } catch (e) {
      throw Exception('Error al eliminar contenedor: $e');
    }
  }
}
