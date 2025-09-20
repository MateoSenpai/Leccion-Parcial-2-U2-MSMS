import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/categoria.dart';
import '../models/producto.dart';

class ApiService {
  static const String baseUrl =
      "http://10.0.2.2/backend"; // Para emulador Android
  // static const String baseUrl = "http://localhost/backend"; // Para iOS o web

  // Headers para las peticiones
  static Map<String, String> get headers => {
    "Content-Type": "application/json",
    "Accept": "application/json",
  };

  // Manejo de errores
  static dynamic handleResponse(http.Response response) {
    switch (response.statusCode) {
      case 200:
      case 201:
        return json.decode(response.body);
      case 400:
        throw Exception('Bad Request: ${response.body}');
      case 401:
      case 403:
        throw Exception('Unauthorized: ${response.body}');
      case 404:
        throw Exception('Not Found: ${response.body}');
      case 500:
      default:
        throw Exception(
          'Error occurred while communicating with server. StatusCode: ${response.statusCode}',
        );
    }
  }

  // CATEGORÍAS

  // Obtener todas las categorías
  static Future<List<Categoria>> getCategorias() async {
    final response = await http.get(
      Uri.parse('$baseUrl/api/categoria/read.php'),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      List<Categoria> categorias = (data['records'] as List)
          .map((categoria) => Categoria.fromJson(categoria))
          .toList();
      return categorias;
    } else {
      throw Exception('Failed to load categories');
    }
  }

  // Crear categoría
  static Future<bool> createCategoria(Categoria categoria) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/categoria/create.php'),
      headers: headers,
      body: json.encode(categoria.toJson()),
    );

    if (response.statusCode == 201) {
      return true;
    } else {
      throw Exception('Failed to create category');
    }
  }

  // Actualizar categoría
  static Future<bool> updateCategoria(Categoria categoria) async {
    final response = await http.put(
      Uri.parse('$baseUrl/api/categoria/update.php'),
      headers: headers,
      body: json.encode(categoria.toJson()),
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      throw Exception('Failed to update category');
    }
  }

  // Eliminar categoría
  static Future<bool> deleteCategoria(int id) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/api/categoria/delete.php'),
      headers: headers,
      body: json.encode({'id': id}),
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      throw Exception('Failed to delete category');
    }
  }

  // PRODUCTOS

  // Obtener todos los productos
  static Future<List<Producto>> getProductos() async {
    final response = await http.get(
      Uri.parse('$baseUrl/api/producto/read.php'),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      List<Producto> productos = (data['records'] as List)
          .map((producto) => Producto.fromJson(producto))
          .toList();
      return productos;
    } else {
      throw Exception('Failed to load products');
    }
  }

  // Crear producto
  static Future<bool> createProducto(Producto producto) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/producto/create.php'),
      headers: headers,
      body: json.encode(producto.toJson()),
    );

    if (response.statusCode == 201) {
      return true;
    } else {
      throw Exception('Failed to create product');
    }
  }

  // Actualizar producto
  static Future<bool> updateProducto(Producto producto) async {
    final response = await http.put(
      Uri.parse('$baseUrl/api/producto/update.php'),
      headers: headers,
      body: json.encode(producto.toJson()),
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      throw Exception('Failed to update product');
    }
  }

  // Eliminar producto
  static Future<bool> deleteProducto(int id) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/api/producto/delete.php'),
      headers: headers,
      body: json.encode({'id': id}),
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      throw Exception('Failed to delete product');
    }
  }
}
