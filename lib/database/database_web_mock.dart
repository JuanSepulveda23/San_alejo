import 'package:sqflite/sqflite.dart';

class MockQueryCursor implements QueryCursor {
  final List<Map<String, dynamic>> _rows;
  int _currentIndex = 0;

  MockQueryCursor(this._rows);

  @override
  Future<bool> moveNext() async {
    if (_currentIndex < _rows.length) {
      _currentIndex++;
      return true;
    }
    return false;
  }

  @override
  Map<String, dynamic> get current =>
      _currentIndex > 0 && _currentIndex <= _rows.length
          ? _rows[_currentIndex - 1]
          : {};

  @override
  Future<void> close() async {}
}

class MockBatch implements Batch {
  late WebDatabase _db;
  final List<Future<dynamic> Function()> _operations = [];

  MockBatch(this._db);

  @override
  void insert(String table, Map<String, dynamic> values,
      {String? nullColumnHack, ConflictAlgorithm? conflictAlgorithm}) {
    _operations.add(() =>
        _db.insert(table, values, nullColumnHack: nullColumnHack));
  }

  @override
  void update(String table, Map<String, Object?> values,
      {String? where, List<Object?>? whereArgs, ConflictAlgorithm? conflictAlgorithm}) {
    _operations.add(() => _db.update(table, values as Map<String, dynamic>,
        where: where, whereArgs: whereArgs));
  }

  @override
  void delete(String table, {String? where, List<Object?>? whereArgs}) {
    _operations.add(() => _db.delete(table, where: where, whereArgs: whereArgs));
  }

  @override
  void rawInsert(String sql, [List<Object?>? arguments]) {
    _operations.add(() => Future.value(0));
  }

  @override
  void rawUpdate(String sql, [List<Object?>? arguments]) {
    _operations.add(() => Future.value(0));
  }

  @override
  void rawDelete(String sql, [List<Object?>? arguments]) {
    _operations.add(() => Future.value(0));
  }

  @override
  void query(String table,
      {bool? distinct,
      List<String>? columns,
      String? where,
      List<Object?>? whereArgs,
      String? groupBy,
      String? having,
      String? orderBy,
      int? limit,
      int? offset}) {
    _operations.add(() => _db.query(table,
        distinct: distinct,
        columns: columns,
        where: where,
        whereArgs: whereArgs,
        groupBy: groupBy,
        having: having,
        orderBy: orderBy,
        limit: limit,
        offset: offset));
  }

  @override
  void rawQuery(String sql, [List<Object?>? arguments]) {
    _operations.add(() => _db.rawQuery(sql, arguments));
  }

  @override
  Future<List<Object?>> commit(
      {bool? exclusive, bool? noResult, bool? continueOnError}) async {
    final results = <Object?>[];
    for (var op in _operations) {
      results.add(await op());
    }
    _operations.clear();
    return results;
  }

  @override
  void execute(String sql, [List<Object?>? arguments]) {
    // DatabaseExecutor.execute - ignored in batch mode
  }

  @override
  Future<List<Object?>> apply(
      {bool? noResult, bool? continueOnError}) async {
    return commit(noResult: noResult, continueOnError: continueOnError);
  }

  @override
  int get length => _operations.length;
}

/// Mock Database implementation for web platform
class WebDatabase implements Database {
  static final WebDatabase _instance = WebDatabase._();

  factory WebDatabase() {
    return _instance;
  }

  WebDatabase._() {
    _initialized = false;
    _tables = {};
  }

  late bool _initialized;
  late Map<String, List<Map<String, dynamic>>> _tables;
  int _nextId = 1;

  Future<void> initialize() async {
    if (_initialized) return;
    _tables = {
      'contenedor': [],
      'objeto': [],
    };
    _initialized = true;
  }

  @override
  Future<int> insert(String table, Map<String, dynamic> values,
      {String? nullColumnHack, ConflictAlgorithm? conflictAlgorithm}) async {
    if (!_initialized) await initialize();
    final id = _nextId++;
    final record = Map<String, dynamic>.from(values);
    record['id'] = id;
    _tables[table]?.add(record);
    return id;
  }

  @override
  Future<List<Map<String, dynamic>>> query(String table,
      {bool? distinct,
      List<String>? columns,
      String? where,
      List<Object?>? whereArgs,
      String? groupBy,
      String? having,
      String? orderBy,
      int? limit,
      int? offset}) async {
    if (!_initialized) await initialize();
    var results = List<Map<String, dynamic>>.from(_tables[table] ?? []);
    if (where != null && whereArgs != null) {
      results = results.where((record) {
        return _evaluateWhere(record, where, whereArgs);
      }).toList();
    }
    if (orderBy != null) {
      final parts = orderBy.split(' ');
      final columnName = parts[0];
      final ascending = parts.length < 2 || parts[1].toUpperCase() != 'DESC';
      results.sort((a, b) {
        final aVal = a[columnName];
        final bVal = b[columnName];
        if (aVal == null && bVal == null) return 0;
        if (aVal == null) return ascending ? -1 : 1;
        if (bVal == null) return ascending ? 1 : -1;
        return ascending
            ? (aVal as Comparable).compareTo(bVal)
            : (bVal as Comparable).compareTo(aVal);
      });
    }
    if (offset != null) {
      results = results.skip(offset).toList();
    }
    if (limit != null) {
      results = results.take(limit).toList();
    }
    return results;
  }

  @override
  Future<int> update(String table, Map<String, dynamic> values,
      {String? where,
      List<Object?>? whereArgs,
      ConflictAlgorithm? conflictAlgorithm}) async {
    if (!_initialized) await initialize();
    int count = 0;
    final records = _tables[table] ?? [];
    for (var record in records) {
      if (where == null || _evaluateWhere(record, where, whereArgs ?? [])) {
        record.addAll(values);
        count++;
      }
    }
    return count;
  }

  @override
  Future<int> delete(String table,
      {String? where, List<Object?>? whereArgs}) async {
    if (!_initialized) await initialize();
    final records = _tables[table] ?? [];
    final originalLength = records.length;
    records.removeWhere((record) {
      if (where == null) return true;
      return _evaluateWhere(record, where, whereArgs ?? []);
    });
    return originalLength - records.length;
  }

  @override
  Future<List<Map<String, dynamic>>> rawQuery(String sql,
      [List<Object?>? arguments]) async {
    if (!_initialized) await initialize();
    if (sql.contains('COUNT(*)')) {
      final table = sql.split('FROM')[1].split('WHERE')[0].trim();
      final records = _tables[table] ?? [];
      if (sql.contains('WHERE')) {
        var filtered = records;
        if (arguments != null && arguments.isNotEmpty) {
          filtered = records
              .where((r) => r['id_contenedor'] == arguments[0])
              .toList();
        }
        return [{'count': filtered.length}];
      }
      return [{'count': records.length}];
    }
    return [];
  }

  @override
  Future<int> rawInsert(String sql, [List<Object?>? arguments]) async =>
      throw UnimplementedError();

  @override
  Future<int> rawUpdate(String sql, [List<Object?>? arguments]) async =>
      throw UnimplementedError();

  @override
  Future<int> rawDelete(String sql, [List<Object?>? arguments]) async =>
      throw UnimplementedError();

  @override
  Future<T> transaction<T>(Future<T> Function(Transaction txn) action,
      {bool? exclusive}) async =>
      action(this as Transaction);

  @override
  Future<int> execute(String sql, [List<Object?>? arguments]) async => 0;

  @override
  Future<void> close() async {}

  @override
  int getVersion() => 1;

  @override
  Future<void> setVersion(int version) async {}

  @override
  String get path => ':memory:';

  @override
  bool get isOpen => true;

  @override
  Database get database => this;

  @override
  Batch batch() => MockBatch(this);

  @override
  Future<QueryCursor> queryCursor(String table,
      {bool? distinct,
      List<String>? columns,
      String? where,
      List<Object?>? whereArgs,
      String? groupBy,
      String? having,
      String? orderBy,
      int? limit,
      int? offset,
      int? bufferSize}) async {
    final rows = await query(table,
        distinct: distinct,
        columns: columns,
        where: where,
        whereArgs: whereArgs,
        groupBy: groupBy,
        having: having,
        orderBy: orderBy,
        limit: limit,
        offset: offset);
    return MockQueryCursor(rows);
  }

  @override
  Future<QueryCursor> rawQueryCursor(String sql, List<Object?>? arguments,
      {int? bufferSize}) async {
    final rows = await rawQuery(sql, arguments);
    return MockQueryCursor(rows);
  }

  @override
  Future<T> readTransaction<T>(Future<T> Function(Transaction txn) action,
      {bool? exclusive}) async =>
      action(this as Transaction);

  @override
  Future<T> devInvokeMethod<T>(String method, [dynamic arguments]) async =>
      throw UnimplementedError();

  @override
  Future<T> devInvokeSqlMethod<T>(String method, String sql,
      [List<Object?>? arguments]) async =>
      throw UnimplementedError();

  bool _evaluateWhere(
      Map<String, dynamic> record, String where, List<Object?> whereArgs) {
    if (where.contains('=')) {
      final parts = where.split('=');
      final column = parts[0].trim();
      final value = whereArgs.isNotEmpty ? whereArgs[0] : null;
      return record[column] == value;
    }
    return true;
  }
}
