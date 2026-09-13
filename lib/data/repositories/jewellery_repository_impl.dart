import 'dart:async';
import '../../domain/entities/category_entity.dart';
import '../../domain/entities/jewellery_item_entity.dart';
import '../../domain/repositories/jewellery_repository.dart';
import '../datasources/jewellery_local_data_source.dart';
import '../datasources/jewellery_remote_data_source.dart';
import '../models/paginated_response.dart';

class JewelleryRepositoryImpl implements JewelleryRepository {
  final JewelleryRemoteDataSource remoteDataSource;
  final JewelleryLocalDataSource localDataSource;

  Future<PaginatedResponse<CategoryEntity>>? _inFlightCategories;
  final Map<String, Future<PaginatedResponse<JewelleryItemEntity>>> _inFlightJewellery = {};

  JewelleryRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<PaginatedResponse<CategoryEntity>> getCategories({int page = 1, int limit = 100}) async {
    final cached = localDataSource.getCachedCategories();

    // If we have cached categories for page 1, return immediately for instant rendering
    if (page == 1 && cached != null && cached.items.isNotEmpty) {
      // Trigger background update if needed
      _refreshCategoriesInBackground();
      return cached;
    }

    // Deduplicate in-flight network requests
    if (page == 1 && _inFlightCategories != null) {
      return await _inFlightCategories!;
    }

    final future = _fetchAndCacheCategories(page: page, limit: limit);
    if (page == 1) _inFlightCategories = future;
    try {
      final result = await future;
      return result;
    } finally {
      if (page == 1) _inFlightCategories = null;
    }
  }

  Future<PaginatedResponse<CategoryEntity>> _fetchAndCacheCategories({int page = 1, int limit = 100}) async {
    try {
      final remote = await remoteDataSource.getCategories(page: page, limit: limit);
      if (page == 1) localDataSource.cacheCategories(remote);
      return remote;
    } catch (e) {
      if (page == 1) {
        final cached = localDataSource.getCachedCategories();
        if (cached != null && cached.items.isNotEmpty) {
          return cached;
        }
      }
      rethrow;
    }
  }

  void _refreshCategoriesInBackground() {
    if (_inFlightCategories == null) {
      _inFlightCategories = _fetchAndCacheCategories();
      _inFlightCategories!.catchError((_) => PaginatedResponse<CategoryEntity>(items: [], total: 0, page: 1, totalPages: 1)).whenComplete(() {
        _inFlightCategories = null;
      });
    }
  }

  @override
  Future<PaginatedResponse<JewelleryItemEntity>> getJewellery({String? category, String? search, int page = 1, int limit = 100}) async {
    final cached = localDataSource.getCachedJewellery(category: category, search: search, page: page, limit: limit);

    if (page == 1 && cached != null && cached.items.isNotEmpty) {
      _refreshJewelleryInBackground(category: category, search: search);
      return cached;
    }

    final key = '${category ?? 'All'}:${search ?? ''}:$page:$limit';
    if (_inFlightJewellery.containsKey(key)) {
      return await _inFlightJewellery[key]!;
    }

    final future = _fetchAndCacheJewellery(category: category, search: search, page: page, limit: limit);
    _inFlightJewellery[key] = future;
    try {
      final result = await future;
      return result;
    } finally {
      _inFlightJewellery.remove(key);
    }
  }

  Future<PaginatedResponse<JewelleryItemEntity>> _fetchAndCacheJewellery({String? category, String? search, int page = 1, int limit = 100}) async {
    try {
      final remote = await remoteDataSource.getJewellery(category: category, search: search, page: page, limit: limit);
      if (page == 1) localDataSource.cacheJewellery(remote, category: category, search: search);
      return remote;
    } catch (e) {
      if (page == 1) {
        final cached = localDataSource.getCachedJewellery(category: category, search: search);
        if (cached != null && cached.items.isNotEmpty) {
          return cached;
        }
      }
      rethrow;
    }
  }

  void _refreshJewelleryInBackground({String? category, String? search}) {
    final key = '${category ?? 'All'}:${search ?? ''}:1:100'; // Only background refresh page 1
    if (!_inFlightJewellery.containsKey(key)) {
      final future = _fetchAndCacheJewellery(category: category, search: search, page: 1, limit: 100);
      _inFlightJewellery[key] = future;
      future.catchError((_) => PaginatedResponse<JewelleryItemEntity>(items: [], total: 0, page: 1, totalPages: 1)).whenComplete(() {
        _inFlightJewellery.remove(key);
      });
    }
  }

  @override
  Future<JewelleryItemEntity> getJewelleryById(dynamic id) async {
    final all = await getJewellery();
    return all.items.firstWhere((i) => i.id.toString() == id.toString());
  }
}
