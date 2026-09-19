import 'package:dio/dio.dart';
import '../../constants/app_constants.dart';
import '../../core/error/failures.dart';
import '../models/gold_rates_model.dart';
import '../models/category_model.dart';
import '../models/jewellery_item_model.dart';
import '../models/paginated_response.dart';

/// Remote data source — mirrors the website's apiClient.js pattern exactly.
///
/// Website pattern (source of truth):
///   - Single fetch() per request, no retries
///   - Content-Type: application/json
///   - Gold rates: GET /api/gold-rates  (backend owns the live feed + DB fallback)
///   - Categories: GET /api/categories
///   - Jewellery:  GET /api/jewellery?category=&search=&page=&limit=
abstract class JewelleryRemoteDataSource {
  Future<GoldRatesModel> getGoldRates();
  Future<PaginatedResponse<CategoryModel>> getCategories({int page = 1, int limit = 100});
  Future<PaginatedResponse<JewelleryItemModel>> getJewellery({
    String? category,
    String? search,
    int page = 1,
    int limit = 100,
  });
}

class JewelleryRemoteDataSourceImpl implements JewelleryRemoteDataSource {
  final Dio dio;

  JewelleryRemoteDataSourceImpl({required this.dio});

  // ─── Gold Rates ──────────────────────────────────────────────────────────
  // Website goldRatesService.js: fetchGoldRates() → GET /api/gold-rates
  // The backend fetches from Pankaj Chain live feed and falls back to DB.
  // We do NOT call the live stream directly — the backend handles it.
  @override
  Future<GoldRatesModel> getGoldRates() async {
    try {
      final response = await dio.get(AppConstants.apiGoldRates);

      if (response.statusCode == 200) {
        final decoded = response.data as Map<String, dynamic>;
        if (decoded['success'] == true && decoded['goldRates'] != null) {
          return GoldRatesModel.fromJson(decoded['goldRates'] as Map<String, dynamic>);
        }
      }
      throw ServerFailure('Gold rates response invalid (status ${response.statusCode})');
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionError) {
        throw ServerFailure('No internet connection');
      }
      throw ServerFailure('Failed to fetch gold rates: ${e.message}');
    } catch (e) {
      if (e is ServerFailure) rethrow;
      throw ServerFailure('Failed to fetch gold rates: $e');
    }
  }

  // ─── Categories ──────────────────────────────────────────────────────────
  // Website categoriesService.js: fetchCategories() → GET /api/categories
  @override
  Future<PaginatedResponse<CategoryModel>> getCategories({
    int page = 1,
    int limit = 100,
  }) async {
    try {
      final response = await dio.get(
        AppConstants.apiCategories,
        queryParameters: {'page': page, 'limit': limit},
      );

      if (response.statusCode == 200) {
        final decoded = response.data as Map<String, dynamic>;
        if (decoded['success'] == true) {
          return PaginatedResponse<CategoryModel>.fromJson(
            decoded,
            (json) => CategoryModel.fromJson(json),
            'categories',
          );
        }
        // Fallback: plain list response
        if (decoded['categories'] is List) {
          final list = decoded['categories'] as List;
          return PaginatedResponse<CategoryModel>(
            items: list.map((c) => CategoryModel.fromJson(c)).toList(),
            total: list.length,
            page: 1,
            totalPages: 1,
          );
        }
      }
      throw ServerFailure('Categories API returned status: ${response.statusCode}');
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionError) {
        throw ServerFailure('No internet connection');
      }
      throw ServerFailure('Failed to fetch categories: ${e.message}');
    } catch (e) {
      if (e is ServerFailure) rethrow;
      throw ServerFailure('Failed to fetch categories: $e');
    }
  }

  // ─── Jewellery ───────────────────────────────────────────────────────────
  // Website jewelleryService.js: fetchJewellery({category, search, page, limit})
  //   → GET /api/jewellery?category=&search=&page=&limit=
  @override
  Future<PaginatedResponse<JewelleryItemModel>> getJewellery({
    String? category,
    String? search,
    int page = 1,
    int limit = 100,
  }) async {
    try {
      final queryParameters = <String, dynamic>{
        // Mirrors website: only send category if non-empty and not "All"
        if (category != null && category.isNotEmpty && category != 'All')
          'category': category,
        // Mirrors website: only send search if non-empty
        if (search != null && search.isNotEmpty) 'search': search,
        'page': page,
        'limit': limit,
      };

      final response = await dio.get(
        AppConstants.apiJewellery,
        queryParameters: queryParameters,
      );

      if (response.statusCode == 200) {
        final decoded = response.data as Map<String, dynamic>;
        if (decoded['success'] == true) {
          return PaginatedResponse<JewelleryItemModel>.fromJson(
            decoded,
            (json) => JewelleryItemModel.fromJson(json),
            'jewellery',
          );
        }
        // Fallback: plain list response
        if (decoded['jewellery'] is List) {
          final list = decoded['jewellery'] as List;
          return PaginatedResponse<JewelleryItemModel>(
            items: list.map((i) => JewelleryItemModel.fromJson(i as Map<String, dynamic>)).toList(),
            total: list.length,
            page: 1,
            totalPages: 1,
          );
        }
      }
      throw ServerFailure('Jewellery API returned status: ${response.statusCode}');
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionError) {
        throw ServerFailure('No internet connection');
      }
      throw ServerFailure('Failed to fetch jewellery: ${e.message}');
    } catch (e) {
      if (e is ServerFailure) rethrow;
      throw ServerFailure('Failed to fetch jewellery: $e');
    }
  }
}
