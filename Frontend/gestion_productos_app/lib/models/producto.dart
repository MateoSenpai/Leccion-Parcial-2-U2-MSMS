class Producto {
  int id;
  String nombre;
  String descripcion;
  double precio;
  int categoriaId;
  String categoriaNombre;
  String imagen;
  String createdAt;

  Producto({
    required this.id,
    required this.nombre,
    required this.descripcion,
    required this.precio,
    required this.categoriaId,
    required this.categoriaNombre,
    required this.imagen,
    required this.createdAt,
  });

  factory Producto.fromJson(Map<String, dynamic> json) {
    return Producto(
      id: json['id'],
      nombre: json['nombre'],
      descripcion: json['descripcion'],
      precio: double.parse(json['precio'].toString()),
      categoriaId: json['categoria_id'],
      categoriaNombre: json['categoria_nombre'],
      imagen: json['imagen'],
      createdAt: json['created_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nombre': nombre,
      'descripcion': descripcion,
      'precio': precio,
      'categoria_id': categoriaId,
      'imagen': imagen,
      'created_at': createdAt,
    };
  }
}
