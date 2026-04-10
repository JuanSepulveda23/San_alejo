import 'package:sqflite/sqflite.dart';
import '../database/database_helper.dart';
import '../models/objeto.dart';

class ObjetoRepository {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  // Create
  Future<int> insertObjeto(Objeto objeto) async {
    try {
      Database db = await _dbHelper.database;
      return await db.insert(
        DatabaseHelper.tableObjeto,
        objeto.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (e) {
      throw Exception('Error al insertar objeto: $e');
    }
  }

  // Read all by container ID
  Future<List<Objeto>> getObjetosByContenedorId(int idContenedor) async {
    try {
      Database db = await _dbHelper.database;
      List<Map<String, dynamic>> maps = await db.query(
        DatabaseHelper.tableObjeto,
        where: '${DatabaseHelper.columnObjetoIdContenedor} = ?',
        whereArgs: [idContenedor],
        orderBy: '${DatabaseHelper.columnObjetoNombre} ASC',
      );

      if (maps.isEmpty) {
        return [];
      }

      return List.generate(maps.length, (i) => Objeto.fromMap(maps[i]));
    } catch (e) {
      throw Exception('Error al obtener objetos: $e');
    }
  }

  // Read by ID
  Future<Objeto?> getObjetoById(int id) async {
    try {
      Database db = await _dbHelper.database;
      List<Map<String, dynamic>> maps = await db.query(
        DatabaseHelper.tableObjeto,
        where: '${DatabaseHelper.columnObjetoId} = ?',
        whereArgs: [id],
      );

      if (maps.isEmpty) {
        return null;
      }

      return Objeto.fromMap(maps.first);
    } catch (e) {
      throw Exception('Error al obtener objeto: $e');
    }
  }

  // Update
  Future<int> updateObjeto(Objeto objeto) async {
    try {
      Database db = await _dbHelper.database;
      return await db.update(
        DatabaseHelper.tableObjeto,
        objeto.toMap(),
        where: '${DatabaseHelper.columnObjetoId} = ?',
        whereArgs: [objeto.id],
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (e) {
      throw Exception('Error al actualizar objeto: $e');
    }
  }

  // Delete
  Future<int> deleteObjeto(int id) async {
    try {
      Database db = await _dbHelper.database;
      return await db.delete(
        DatabaseHelper.tableObjeto,
        where: '${DatabaseHelper.columnObjetoId} = ?',
        whereArgs: [id],
      );
    } catch (e) {
      throw Exception('Error al eliminar objeto: $e');
    }
  }

  // Count objects in container
  Future<int> countObjetosByContenedorId(int idContenedor) async {
    try {
      Database db = await _dbHelper.database;
      final result = await db.rawQuery(
        'SELECT COUNT(*) as count FROM ${DatabaseHelper.tableObjeto} WHERE ${DatabaseHelper.columnObjetoIdContenedor} = ?',
        [idContenedor],
      );
      return Sqflite.firstIntValue(result) ?? 0;
    } catch (e) {
      throw Exception('Error al contar objetos: $e');
    }
  }
}
