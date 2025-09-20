import 'package:flutter/material.dart';
import '../models/producto.dart';
import '../services/api_service.dart';
import 'product_form_screen.dart';
import '../widgets/product_card.dart';

class ProductListScreen extends StatefulWidget {
  @override
  _ProductListScreenState createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  late Future<List<Producto>> futureProductos;
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  @override
  void initState() {
    super.initState();
    futureProductos = ApiService.getProductos();
  }

  Future<void> _refreshProducts() async {
    setState(() {
      futureProductos = ApiService.getProductos();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Gestión de Productos'),
        backgroundColor: Colors.blue,
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ProductFormScreen()),
              ).then((value) {
                if (value == true) {
                  _refreshProducts();
                }
              });
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        key: _refreshIndicatorKey,
        onRefresh: _refreshProducts,
        child: FutureBuilder<List<Producto>>(
          future: futureProductos,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.error_outline, size: 64, color: Colors.red),
                    SizedBox(height: 16),
                    Text(
                      'Error al cargar los productos',
                      style: TextStyle(fontSize: 18),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Verifica que el servidor esté funcionando',
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _refreshProducts,
                      child: Text('Reintentar'),
                    ),
                  ],
                ),
              );
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(child: Text('No hay productos disponibles'));
            } else {
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  Producto producto = snapshot.data![index];
                  return ProductCard(
                    producto: producto,
                    onDelete: () async {
                      try {
                        await ApiService.deleteProducto(producto.id);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Producto eliminado correctamente'),
                            backgroundColor: Colors.green,
                          ),
                        );
                        _refreshProducts();
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Error al eliminar el producto: $e'),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    },
                    onEdit: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              ProductFormScreen(producto: producto),
                        ),
                      ).then((value) {
                        if (value == true) {
                          _refreshProducts();
                        }
                      });
                    },
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}
