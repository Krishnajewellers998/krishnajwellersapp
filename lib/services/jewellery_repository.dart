import 'dart:convert';
import 'package:http/http.dart' as http;
import '../constants/app_constants.dart';
import '../models/jewellery_models.dart';

class JewelleryRepository {
  // Fetch live broadcast stream with fallback to backend API
  static Future<GoldRatesModel> fetchGoldRates() async {
    try {
      final url = '${AppConstants.liveGoldStreamUrl}?_=${DateTime.now().millisecondsSinceEpoch}';
      final response = await http
          .get(Uri.parse(url), headers: {'Accept': 'text/plain, */*; q=0.01'})
          .timeout(const Duration(seconds: 4));

      if (response.statusCode == 200) {
        final text = response.body;
        final regExp = RegExp(r'6335\s+GOLD\s+99\.50\s+CASH\s+BHAV\s+(\d+)\s+(\d+)\s+(\d+)\s+(\d+)', caseSensitive: false);
        final match = regExp.firstMatch(text);

        if (match != null) {
          final sell = int.tryParse(match.group(2) ?? '') ?? 0;
          final r24 = sell;
          final r22 = ((r24 * 22) / 24).round();
          final r18 = ((r24 * 18) / 24).round();

          return GoldRatesModel(
            rate24K: r24,
            rate22K: r22,
            rate18K: r18,
            updatedAt: DateTime.now().toIso8601String(),
          );
        }
      }
    } catch (_) {
      // Ignore stream failure and fallback below
    }

    // Fallback to backend API
    try {
      final response = await http
          .get(Uri.parse(AppConstants.apiGoldRates))
          .timeout(const Duration(seconds: 8));

      if (response.statusCode == 200) {
        final decoded = json.decode(response.body);
        if (decoded['success'] == true && decoded['goldRates'] != null) {
          return GoldRatesModel.fromJson(decoded['goldRates']);
        }
      }
      throw Exception('Backend gold rates returned status: ${response.statusCode}');
    } catch (e) {
      throw Exception('Failed to load live gold stream and backend API: $e');
    }
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
