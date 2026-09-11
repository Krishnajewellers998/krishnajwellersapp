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
      final response = await client
          .get(Uri.parse(AppConstants.apiGoldRates))
          .timeout(const Duration(seconds: 8));

      if (response.statusCode == 200) {
        final decoded = json.decode(response.body);
        return GoldRatesModel.fromJson(decoded);
      }
      throw ServerFailure('Gold rates server responded with status: ${response.statusCode}');
    } catch (e) {
      throw ServerFailure('Failed to fetch gold rates: $e');
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
