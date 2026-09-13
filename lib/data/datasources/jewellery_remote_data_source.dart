import 'package:dio/dio.dart';
import '../../constants/app_constants.dart';
import '../../core/error/failures.dart';
import '../models/gold_rates_model.dart';
import '../models/category_model.dart';
import '../models/jewellery_item_model.dart';

import '../models/paginated_response.dart';

abstract class JewelleryRemoteDataSource {
  Future<GoldRatesModel> getGoldRates();
  Future<PaginatedResponse<CategoryModel>> getCategories({int page = 1, int limit = 100});
  Future<PaginatedResponse<JewelleryItemModel>> getJewellery({String? category, String? search, int page = 1, int limit = 100});
  Future<void> prefetchAll();
}

class JewelleryRemoteDataSourceImpl implements JewelleryRemoteDataSource {
  final Dio dio;

  JewelleryRemoteDataSourceImpl({required this.dio});

  // Retry a GET request up to [maxRetries] times.
  // Handles Render cold-starts gracefully.
  Future<Response> _getWithRetry(
    String url, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    int maxRetries = 2,
  }) async {
    DioException? lastError;
    for (int attempt = 1; attempt <= maxRetries; attempt++) {
      try {
        final response = await dio.get(
          url,
          queryParameters: queryParameters,
          options: options,
        );
        return response;
      } on DioException catch (e) {
        if (e.type == DioExceptionType.connectionError) {
          throw ServerFailure('No internet connection');
        }
        lastError = e;
        if (attempt < maxRetries) {
          await Future.delayed(const Duration(milliseconds: 1500));
        }
      }
    }
    throw ServerFailure('Request failed after $maxRetries attempts: ${lastError?.message}');
  }

  @override
  Future<void> prefetchAll() async {
    try {
      // Warm up Render backend by firing requests concurrently
      await Future.wait([
        getGoldRates().catchError((_) => const GoldRatesModel(rate24K: 0, rate22K: 0, rate18K: 0)),
        getCategories().catchError((_) => PaginatedResponse<CategoryModel>(items: [], total: 0, page: 1, totalPages: 1)),
        getJewellery().catchError((_) => PaginatedResponse<JewelleryItemModel>(items: [], total: 0, page: 1, totalPages: 1)),
      ]);
    } catch (_) {
      // Ignore prefetch errors in background
    }
  }

  @override
  Future<GoldRatesModel> getGoldRates() async {
    try {
      final url = '${AppConstants.liveGoldStreamUrl}?_=${DateTime.now().millisecondsSinceEpoch}';
      final response = await dio.get(
        url,
        options: Options(
          headers: {'Accept': 'text/plain, */*; q=0.01'},
          receiveTimeout: const Duration(seconds: 3),
          sendTimeout: const Duration(seconds: 3),
          responseType: ResponseType.plain,
        ),
      );

      if (response.statusCode == 200) {
        final text = response.data as String;
        final regExp = RegExp(
          r'6335\s+GOLD\s+99\.50\s+CASH\s+BHAV\s+(\d+)\s+(\d+)\s+(\d+)\s+(\d+)',
          caseSensitive: false,
        );
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
      // Ignore live stream failure, fallback to backend API below
    }

    // Fallback to backend API with retry
    try {
      final response = await _getWithRetry(AppConstants.apiGoldRates);

      if (response.statusCode == 200) {
        final decoded = response.data;
        if (decoded['success'] == true && decoded['goldRates'] != null) {
          return GoldRatesModel.fromJson(decoded['goldRates']);
        }
      }
      throw ServerFailure('Backend gold rates returned status: ${response.statusCode}');
    } catch (e) {
      throw ServerFailure('Failed to fetch gold rates: $e');
    }
  }

  @override
  Future<PaginatedResponse<CategoryModel>> getCategories({int page = 1, int limit = 100}) async {
    try {
      final queryParameters = <String, dynamic>{
        'page': page,
        'limit': limit,
      };

      final response = await _getWithRetry(
        AppConstants.apiCategories,
        queryParameters: queryParameters,
      );

      if (response.statusCode == 200) {
        final decoded = response.data;
        if (decoded is Map<String, dynamic> && decoded['success'] == true) {
          return PaginatedResponse<CategoryModel>.fromJson(
            decoded,
            (json) => CategoryModel.fromJson(json),
            'categories',
          );
        } else if (decoded is List) {
          // Fallback if backend hasn't been updated yet
          return PaginatedResponse<CategoryModel>(
            items: decoded.map((c) => CategoryModel.fromJson(c)).toList(),
            total: decoded.length,
            page: 1,
            totalPages: 1,
          );
        } else if (decoded is Map<String, dynamic> && decoded['categories'] is List) {
           return PaginatedResponse<CategoryModel>(
            items: (decoded['categories'] as List).map((c) => CategoryModel.fromJson(c)).toList(),
            total: (decoded['categories'] as List).length,
            page: 1,
            totalPages: 1,
          );
        }
      }
      throw ServerFailure('Categories API returned status: ${response.statusCode}');
    } catch (e) {
      throw ServerFailure('Failed to fetch categories: $e');
    }
  }

  @override
  Future<PaginatedResponse<JewelleryItemModel>> getJewellery({String? category, String? search, int page = 1, int limit = 100}) async {
    try {
      final queryParameters = <String, dynamic>{
        if (category != null && category.isNotEmpty && category != 'All') 'category': category,
        if (search != null && search.isNotEmpty) 'search': search,
        'page': page,
        'limit': limit,
      };

      final response = await _getWithRetry(
        AppConstants.apiJewellery,
        queryParameters: queryParameters,
      );

      if (response.statusCode == 200) {
        final decoded = response.data;
        if (decoded is Map<String, dynamic> && decoded['success'] == true) {
          return PaginatedResponse<JewelleryItemModel>.fromJson(
            decoded,
            (json) => JewelleryItemModel.fromJson(json),
            'jewellery',
          );
        } else if (decoded is Map<String, dynamic> && decoded['jewellery'] is List) {
          return PaginatedResponse<JewelleryItemModel>(
            items: (decoded['jewellery'] as List).map((i) => JewelleryItemModel.fromJson(i)).toList(),
            total: (decoded['jewellery'] as List).length,
            page: 1,
            totalPages: 1,
          );
        }
      }
      throw ServerFailure('Jewellery API returned status: ${response.statusCode}');
    } catch (e) {
      throw ServerFailure('Failed to fetch jewellery: $e');
    }
  }
}
