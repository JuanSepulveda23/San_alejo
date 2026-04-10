class Objeto {
  final int? id;
  final String nombre;
  final String descripcion;
  final int idContenedor;

  Objeto({
    this.id,
    required this.nombre,
    required this.descripcion,
    required this.idContenedor,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nombre': nombre,
      'descripcion': descripcion,
      'id_contenedor': idContenedor,
    };
  }

  factory Objeto.fromMap(Map<String, dynamic> map) {
    return Objeto(
      id: map['id'] as int?,
      nombre: map['nombre'] as String,
      descripcion: map['descripcion'] as String,
      idContenedor: map['id_contenedor'] as int,
    );
  }

  Objeto copyWith({
    int? id,
    String? nombre,
    String? descripcion,
    int? idContenedor,
  }) {
    return Objeto(
      id: id ?? this.id,
      nombre: nombre ?? this.nombre,
      descripcion: descripcion ?? this.descripcion,
      idContenedor: idContenedor ?? this.idContenedor,
    );
  }

  @override
  String toString() =>
      'Objeto(id: $id, nombre: $nombre, descripcion: $descripcion, idContenedor: $idContenedor)';
}
