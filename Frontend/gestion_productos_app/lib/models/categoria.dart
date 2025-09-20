class Categoria {
  int id;
  String nombre;
  String descripcion;
  String createdAt;

  Categoria({
    required this.id,
    required this.nombre,
    required this.descripcion,
    required this.createdAt,
  });

  factory Categoria.fromJson(Map<String, dynamic> json) {
    return Categoria(
      id: json['id'],
      nombre: json['nombre'],
      descripcion: json['descripcion'],
      createdAt: json['created_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nombre': nombre,
      'descripcion': descripcion,
      'created_at': createdAt,
    };
  }
}
