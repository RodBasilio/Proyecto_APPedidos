import 'package:flutter/material.dart';
import 'Productos.dart';
import 'UserScreen.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class SelectedProductsScreen extends StatelessWidget {
  final List<Product> selectedProducts;

  SelectedProductsScreen({required this.selectedProducts});

  double get totalPrice {
    double total = 0.0;
    for (var product in selectedProducts) {
      total += double.parse(product.precio) * product.cantidad;
    }
    return total;
  }

  Future<void> _uploadProducts(BuildContext context) async {
    final url = 'http://192.168.43.74/Backend/pedidos.php';
    final headers = {'Content-Type': 'application/json'};
    final jsonData = selectedProducts.map((product) => product.toJson()).toList();
    final body = json.encode(jsonData);

    try {
      final response = await http.post(Uri.parse(url), headers: headers, body: body);

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Productos enviados exitosamente')),
        );
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => UserScreen()),
          (Route<dynamic> route) => false,
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al enviar los productos')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error en la conexión')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Productos seleccionados'),
        backgroundColor: Colors.deepPurple,
      ),
      body: ListView.builder(
        itemCount: selectedProducts.length + 1, 
        itemBuilder: (context, index) {
          if (index == selectedProducts.length) {
            return Padding(
              padding: EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Precio Total:',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Bs. ${totalPrice.toStringAsFixed(2)}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            );
          }
          return Card(
            margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        selectedProducts[index].listProd,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        'Unidades seleccionadas: ${selectedProducts[index].cantidad}',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                  Text(
                    'Precio: ${(double.parse(selectedProducts[index].precio) * selectedProducts[index].cantidad).toStringAsFixed(2)}',
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _uploadProducts(context),
        backgroundColor: Colors.deepPurple,
        child: Icon(Icons.cloud_upload),
      ),
    );
  }
}
