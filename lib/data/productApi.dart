import 'dart:convert';
import 'package:fake_store/data/model/product.dart';
import 'package:http/http.dart' as http;

class ProductApi {
  final String apiUrl = "https://fakestoreapi.com/products";

  Future<List<Product>> fetchProducts() async {
    final response = await http.get(Uri.parse(apiUrl));

    if(response.statusCode == 200){
      final List<dynamic> data = json.decode(response.body);
      return data.map((item) => Product.fromJson(item)).toList();
    }
    else{
      throw Exception("Failed to fetch data");
    }
  }
}