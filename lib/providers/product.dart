import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart';

import '../models/http_exception.dart';

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavorite;

  Product({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.imageUrl,
    this.isFavorite = false,
  });

  factory Product.fromJson(Map<String, dynamic> json) => Product(
        id: json['id'],
        title: json['title'],
        description: json['description'],
        price: json['price'],
        imageUrl: json['image_url'],
        isFavorite: json['is_favorite'],
      );

  Future<void> toggleFavoriteStatus(String token, String userId) async {
    final newStatus = !isFavorite;

    isFavorite = !isFavorite;
    notifyListeners();

    final response = await put(
      Uri.parse(
        'https://shop-app-e0796-default-rtdb.europe-west1.firebasedatabase.app/userFavorites/$userId/$id.json?auth=$token',
      ),
      body: json.encode(newStatus),
    );

    if (response.statusCode >= 400) {
      isFavorite = !newStatus;
      notifyListeners();

      throw HttpException('Could not update favorite status');
    }
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'description': description,
        'price': price,
        'image_url': imageUrl,
      };
}
