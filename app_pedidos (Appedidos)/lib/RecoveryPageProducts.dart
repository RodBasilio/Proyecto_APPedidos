import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'Productos.dart';
import 'SelectedProducts.dart';

class RecoveryPage2 extends StatefulWidget {
  @override
  _RecoveryPageState createState() => _RecoveryPageState();
}

class _RecoveryPageState extends State<RecoveryPage2> {
  late Future<List<Movie>> _moviesFuture;
  late List<Movie> _movies;
  List<Product> _selectedProducts = [];

  @override
  void initState() {
    super.initState();
    _moviesFuture = _fetchMovies();
  }

  Future<List<Movie>> _fetchMovies() async {
    String url = 'http://192.168.43.74/Backend/products.php';
    http.Response response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      List<dynamic> jsonData = json.decode(response.body);
      List<Movie> movies =
          jsonData.map((data) => Movie.fromJson(data)).toList();
      return movies;
    } else {
      throw Exception('Failed to fetch movies');
    }
  }

  void _handleProductSelection(int index) {
    setState(() {
      Movie movie = _movies[index];
      Product selectedProduct = _selectedProducts.firstWhere(
        (product) => product.id == movie.id,
        orElse: () => Product(
          id: movie.id,
          listProd: movie.nombre,
          cantidad: 0,
          precio: movie.precio,
        ),
      );

      if (selectedProduct.cantidad == 0) {
        _selectedProducts.add(selectedProduct);
      }

      selectedProduct.cantidad++;
    });
  }

  void _handleProductDeselection(int index) {
    setState(() {
      int productId = _movies[index].id;
      Product selectedProduct = _selectedProducts.firstWhere(
        (product) => product.id == productId,
        orElse: () => Product(id: 0, listProd: '', cantidad: 0, precio: ''),
      );
      if (selectedProduct.cantidad > 0) {
        selectedProduct.cantidad--;
        if (selectedProduct.cantidad == 0) {
          _selectedProducts.remove(selectedProduct);
        }
      }
    });
  }

  void _showSelectedProducts() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            SelectedProductsScreen(selectedProducts: _selectedProducts),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Realizar Pedido'),
        backgroundColor: Colors.deepPurple,
      ),
      body: FutureBuilder<List<Movie>>(
        future: _moviesFuture,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            _movies = snapshot.data!;
            return ListView.builder(
              itemCount: _movies.length,
              itemBuilder: (context, index) {
                int productId = _movies[index].id;
                Product selectedProduct = _selectedProducts.firstWhere(
                  (product) => product.id == productId,
                  orElse: () => Product(id: 0, listProd: '', cantidad: 0, precio: ''),
                );
                return Card(
                  margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: ListTile(
                    leading: Image.network(
                      _movies[index].imagen,
                      width: 55,
                    ),
                    title: Text(
                      _movies[index].nombre,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Precio: ${_movies[index].precio} Bs.',
                          style: TextStyle(color: Colors.grey),
                        ),
                        
                      ],
                    ),
                    trailing: Container(
                      width: 111,
                      height: 40,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: Colors.deepPurple,
                          width: 2,
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          IconButton(
                            icon: Icon(
                              Icons.add_shopping_cart,
                              color: Colors.deepPurple,
                            ),
                            onPressed: () {
                              _handleProductSelection(index);
                            },
                          ),
                          Text(
                            '${selectedProduct.cantidad}',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          IconButton(
                            icon: Icon(
                              Icons.remove_shopping_cart,
                              color: Colors.deepPurple,
                            ),
                            onPressed: () {
                              _handleProductDeselection(index);
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showSelectedProducts,
        backgroundColor: Colors.deepPurple,
        child: Icon(Icons.check),
      ),
    );
  }
}
