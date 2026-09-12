import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../constants/app_constants.dart';
import '../../core/error/failures.dart';
import '../models/gold_rates_model.dart';
import '../models/category_model.dart';
import '../models/jewellery_item_model.dart';

abstract class JewelleryRemoteDataSource {
  Future<GoldRatesModel> getGoldRates();
  Future<List<CategoryModel>> getCategories();
  Future<List<JewelleryItemModel>> getJewellery({String? category, String? search});
}

class JewelleryRemoteDataSourceImpl implements JewelleryRemoteDataSource {
  final http.Client client;

  JewelleryRemoteDataSourceImpl({required this.client});

  @override
  Future<GoldRatesModel> getGoldRates() async {
    try {
      final url = '${AppConstants.liveGoldStreamUrl}?_=${DateTime.now().millisecondsSinceEpoch}';
      final response = await client
          .get(Uri.parse(url), headers: {'Accept': 'text/plain, */*; q=0.01'})
          .timeout(const Duration(seconds: 4)); // Short timeout for live stream

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
      // Ignore live stream failure, fallback below
    }

    // Fallback to backend API
    try {
      final response = await client
          .get(Uri.parse(AppConstants.apiGoldRates))
          .timeout(const Duration(seconds: 8));

      if (response.statusCode == 200) {
        final decoded = json.decode(response.body);
        if (decoded['success'] == true && decoded['goldRates'] != null) {
          return GoldRatesModel.fromJson(decoded['goldRates']);
        }
      }
      throw ServerFailure('Backend gold rates returned status: ${response.statusCode}');
    } catch (e) {
      throw ServerFailure('Failed to fetch gold rates from both stream and backend: $e');
    }
  }

  @override
  Future<List<CategoryModel>> getCategories() async {
    try {
      final response = await client
          .get(Uri.parse(AppConstants.apiCategories))
          .timeout(const Duration(seconds: 8));

      if (response.statusCode == 200) {
        final decoded = json.decode(response.body);
        final list = decoded['categories'] ?? decoded;
        if (list is List) {
          return list.map((c) => CategoryModel.fromJson(c)).toList();
        }
      }
      throw ServerFailure('Categories API returned status: ${response.statusCode}');
    } catch (e) {
      throw ServerFailure('Failed to fetch categories: $e');
    }
  }

  @override
  Future<List<JewelleryItemModel>> getJewellery({String? category, String? search}) async {
    try {
      final uri = Uri.parse(AppConstants.apiJewellery).replace(queryParameters: {
        if (category != null && category.isNotEmpty && category != 'All') 'category': category,
        if (search != null && search.isNotEmpty) 'search': search,
      });

      final response = await client.get(uri).timeout(const Duration(seconds: 8));

      if (response.statusCode == 200) {
        final decoded = json.decode(response.body);
        final list = decoded['jewellery'] ?? decoded;
        if (list is List) {
          return list.map((i) => JewelleryItemModel.fromJson(i)).toList();
        }
      }
      throw ServerFailure('Jewellery API returned status: ${response.statusCode}');
    } catch (e) {
      throw ServerFailure('Failed to fetch jewellery: $e');
    }
  }
}
