import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';


class DataScreen extends StatefulWidget {
  @override
  _DataScreenState createState() => _DataScreenState();
}

class _DataScreenState extends State<DataScreen> {
  List<Map<String, dynamic>> data = [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    final response = await http.get(Uri.parse('http://192.168.43.74/Backend/recupPedido.php'));
    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      setState(() {
        data = List<Map<String, dynamic>>.from(jsonData);
      });
    } else {
      throw Exception('Failed to retrieve data');
    }
  }

  Future<void> deleteData(int id) async {
    final response = await http.delete(Uri.parse('http://192.168.43.74/sis104/elimPedidos.php?id=$id'));
    if (response.statusCode == 200) {
      setState(() {
        data.removeWhere((element) => element['id'] == id);
      });
    } else {
      throw Exception('Failed to delete data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Productos Solicitados'),
        backgroundColor: Colors.deepPurple,
      ),
      body: ListView.builder(
        itemCount: data.length + 1,
        itemBuilder: (context, index) {
          if (index == data.length) {
            double totalPrice = 0;
            for (var item in data) {
              totalPrice += double.parse(item['precio']) * int.parse(item['cantidad']);
            }
            return Padding(
              padding: EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Precio Total a Cobrar:',
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
          final item = data[index];
          final id = item['id'];
          final productName = item['listProd'];
          final quantity = item['cantidad'];
          final price = double.parse(item['precio']) * int.parse(quantity);
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
                        productName,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        'Unidades Solicitadas: $quantity',
                        style: TextStyle(color: Colors.grey),
                      ),
                      Text(
                        'Usuario: Rodrigo Basilio',
                        style: TextStyle(color: Colors.grey),
                      ),
                      Text(
                        'Dir: Calle Guido Villagomez',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                  Text(
                    'Precio: ${price.toStringAsFixed(2)} Bs.',
                    style: TextStyle(color: Colors.grey),
                  ),
                  
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => deleteAllData(),
        backgroundColor: Colors.deepPurple,
        child: Icon(Icons.delete),
      ),
    );
  }

  Future<void> deleteAllData() async {
    final response = await http.delete(Uri.parse('http://192.168.43.74/sis104/elimPedidos.php'));
    if (response.statusCode == 200) {
      setState(() {
        data.clear();
      });
    } else {
      throw Exception('Failed to delete data');
    }
  }
}
