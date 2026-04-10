class Contenedor {
  final int? id;
  final String nombre;
  final String descripcion;
  final String ubicacion;

  Contenedor({
    this.id,
    required this.nombre,
    required this.descripcion,
    required this.ubicacion,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nombre': nombre,
      'descripcion': descripcion,
      'ubicacion': ubicacion,
    };
  }

  factory Contenedor.fromMap(Map<String, dynamic> map) {
    return Contenedor(
      id: map['id'] as int?,
      nombre: map['nombre'] as String,
      descripcion: map['descripcion'] as String,
      ubicacion: map['ubicacion'] as String,
    );
  }

  Contenedor copyWith({
    int? id,
    String? nombre,
    String? descripcion,
    String? ubicacion,
  }) {
    return Contenedor(
      id: id ?? this.id,
      nombre: nombre ?? this.nombre,
      descripcion: descripcion ?? this.descripcion,
      ubicacion: ubicacion ?? this.ubicacion,
    );
  }

  @override
  String toString() =>
      'Contenedor(id: $id, nombre: $nombre, descripcion: $descripcion, ubicacion: $ubicacion)';
}
