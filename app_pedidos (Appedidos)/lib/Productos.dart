import 'dart:convert';

class Movie {
  final int id;
  final String imagen;
  final String nombre;
  final String precio;

  Movie({
    required this.id,
    required this.imagen,
    required this.nombre,
    required this.precio,
  });

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      id: json['id'],
      imagen: json['imagen'],
      nombre: json['nombre'],
      precio: json['precio'],
    );
  }
}

class Product {
  final int id;
  final String listProd;
  int cantidad;
  String precio;

  Product({
    required this.id,
    required this.listProd,
    required this.precio,
    required this.cantidad,
  });

   Map<String, dynamic> toJson() {
    return {
      'id': id,
      'listProd': listProd,
      'cantidad': cantidad,
      'precio': precio
    };
  }
}
