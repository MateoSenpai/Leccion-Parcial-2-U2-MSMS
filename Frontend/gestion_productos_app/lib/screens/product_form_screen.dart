import 'package:flutter/material.dart';
import '../models/producto.dart';
import '../models/categoria.dart';
import '../services/api_service.dart';

class ProductFormScreen extends StatefulWidget {
  final Producto? producto;

  ProductFormScreen({this.producto});

  @override
  _ProductFormScreenState createState() => _ProductFormScreenState();
}

class _ProductFormScreenState extends State<ProductFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nombreController;
  late TextEditingController _descripcionController;
  late TextEditingController _precioController;
  int? _selectedCategoriaId;
  List<Categoria> _categorias = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _nombreController = TextEditingController(
      text: widget.producto?.nombre ?? '',
    );
    _descripcionController = TextEditingController(
      text: widget.producto?.descripcion ?? '',
    );
    _precioController = TextEditingController(
      text: widget.producto?.precio.toString() ?? '',
    );
    _selectedCategoriaId = widget.producto?.categoriaId;
    _loadCategorias();
  }

  Future<void> _loadCategorias() async {
    try {
      final categorias = await ApiService.getCategorias();
      print('Categorías cargadas: ${categorias.length}'); // DEBUG

      // SI NO HAY CATEGORÍAS, CREA ALGUNAS DE PRUEBA TEMPORALMENTE
      if (categorias.isEmpty) {
        print('No hay categorías, creando datos de prueba...'); // DEBUG
        categorias.add(
          Categoria(
            id: 1,
            nombre: "Electrónicos",
            descripcion: "Productos electrónicos",
            createdAt: "",
          ),
        );
        categorias.add(
          Categoria(
            id: 2,
            nombre: "Ropa",
            descripcion: "Ropa y accesorios",
            createdAt: "",
          ),
        );
        categorias.add(
          Categoria(
            id: 3,
            nombre: "Hogar",
            descripcion: "Productos para el hogar",
            createdAt: "",
          ),
        );
      }

      setState(() {
        _categorias = categorias;
      });
    } catch (e) {
      print('Error cargando categorías: $e'); // DEBUG

      // Añade categorías de prueba incluso si hay error
      setState(() {
        _categorias = [
          Categoria(
            id: 1,
            nombre: "Electrónicos",
            descripcion: "Productos electrónicos",
            createdAt: "",
          ),
          Categoria(
            id: 2,
            nombre: "Ropa",
            descripcion: "Ropa y accesorios",
            createdAt: "",
          ),
          Categoria(
            id: 3,
            nombre: "Hogar",
            descripcion: "Productos para el hogar",
            createdAt: "",
          ),
        ];
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error al cargar categorías: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate() && _selectedCategoriaId != null) {
      setState(() {
        _isLoading = true;
      });

      try {
        final producto = Producto(
          id: widget.producto?.id ?? 0,
          nombre: _nombreController.text,
          descripcion: _descripcionController.text,
          precio: double.parse(_precioController.text),
          categoriaId: _selectedCategoriaId!,
          categoriaNombre: '', // Se llenará desde el backend
          imagen: '', // Por ahora vacío
          createdAt: '', // Se llenará desde el backend
        );

        bool success;
        if (widget.producto == null) {
          success = await ApiService.createProducto(producto);
        } else {
          success = await ApiService.updateProducto(producto);
        }

        setState(() {
          _isLoading = false;
        });

        if (success) {
          Navigator.pop(context, true);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error al guardar el producto'),
              backgroundColor: Colors.red,
            ),
          );
        }
      } catch (e) {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Por favor complete todos los campos obligatorios'),
          backgroundColor: Colors.orange,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.producto == null ? 'Crear Producto' : 'Editar Producto',
        ),
        backgroundColor: Colors.blue,
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: ListView(
                  children: [
                    TextFormField(
                      controller: _nombreController,
                      decoration: InputDecoration(
                        labelText: 'Nombre del producto',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor ingrese un nombre';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16),
                    TextFormField(
                      controller: _descripcionController,
                      decoration: InputDecoration(
                        labelText: 'Descripción',
                        border: OutlineInputBorder(),
                      ),
                      maxLines: 3,
                    ),
                    SizedBox(height: 16),
                    TextFormField(
                      controller: _precioController,
                      decoration: InputDecoration(
                        labelText: 'Precio',
                        border: OutlineInputBorder(),
                        prefixText: '\$',
                      ),
                      keyboardType: TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor ingrese un precio';
                        }
                        if (double.tryParse(value) == null) {
                          return 'Por favor ingrese un precio válido';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16),
                    DropdownButtonFormField<int>(
                      value: _selectedCategoriaId,
                      decoration: InputDecoration(
                        labelText: 'Categoría',
                        border: OutlineInputBorder(),
                      ),
                      items: _categorias.map((Categoria categoria) {
                        return DropdownMenuItem<int>(
                          value: categoria.id,
                          child: Text(categoria.nombre),
                        );
                      }).toList(),
                      onChanged: (int? value) {
                        setState(() {
                          _selectedCategoriaId = value;
                        });
                      },
                      validator: (value) {
                        if (value == null) {
                          return 'Por favor seleccione una categoría';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: _submitForm,
                      child: Text(
                        widget.producto == null
                            ? 'Crear Producto'
                            : 'Actualizar Producto',
                        style: TextStyle(fontSize: 16),
                      ),
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 16),
                        backgroundColor: Colors.blue,
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
