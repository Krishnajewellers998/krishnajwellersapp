import 'dart:convert';
import 'package:http/http.dart' as http;
import '../constants/app_constants.dart';
import '../models/jewellery_models.dart';

class JewelleryRepository {
  // Exclusively calls actual live backend API - ZERO dummy or local data
  static Future<GoldRatesModel> fetchGoldRates() async {
    final response = await http
        .get(Uri.parse(AppConstants.apiGoldRates))
        .timeout(const Duration(seconds: 10));

    if (response.statusCode == 200) {
      return GoldRatesModel.fromJson(json.decode(response.body));
    }
    throw Exception('Failed to load live gold rates: ${response.statusCode}');
  }

  static Future<List<CategoryModel>> fetchCategories() async {
    final response = await http
        .get(Uri.parse(AppConstants.apiCategories))
        .timeout(const Duration(seconds: 10));

    if (response.statusCode == 200) {
      final decoded = json.decode(response.body);
      if (decoded['categories'] is List) {
        return (decoded['categories'] as List)
            .map((c) => CategoryModel.fromJson(c))
            .toList();
      }
    }
    throw Exception('Failed to load categories from backend: ${response.statusCode}');
  }

  static Future<List<JewelleryItem>> fetchJewellery() async {
    final response = await http
        .get(Uri.parse(AppConstants.apiJewellery))
        .timeout(const Duration(seconds: 10));

    if (response.statusCode == 200) {
      final decoded = json.decode(response.body);
      final list = decoded['jewellery'] ?? decoded;
      if (list is List) {
        return list.map((i) => JewelleryItem.fromJson(i)).toList();
      }
    }
    throw Exception('Failed to load jewellery from backend: ${response.statusCode}');
  }
}
