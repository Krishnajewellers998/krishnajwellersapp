import '../models/category_model.dart';
import '../models/gold_rates_model.dart';
import '../models/jewellery_item_model.dart';
import '../models/paginated_response.dart';

abstract class JewelleryLocalDataSource {
  GoldRatesModel? getCachedGoldRates();
  void cacheGoldRates(GoldRatesModel rates);

  PaginatedResponse<CategoryModel>? getCachedCategories();
  void cacheCategories(PaginatedResponse<CategoryModel> categories);

  PaginatedResponse<JewelleryItemModel>? getCachedJewellery({String? category, String? search, int page = 1, int limit = 100});
  void cacheJewellery(PaginatedResponse<JewelleryItemModel> items, {String? category, String? search, int page = 1, int limit = 100});

  void clearCache();
}

class JewelleryLocalDataSourceImpl implements JewelleryLocalDataSource {
  GoldRatesModel? _cachedRates;
  DateTime? _ratesCacheTime;

  PaginatedResponse<CategoryModel>? _cachedCategories;
  DateTime? _categoriesCacheTime;

  PaginatedResponse<JewelleryItemModel>? _cachedJewelleryAll;
  final Map<String, PaginatedResponse<JewelleryItemModel>> _categoryJewelleryCache = {};

  final Duration ratesTtl;
  final Duration categoriesTtl;
  final Duration jewelleryTtl;

  JewelleryLocalDataSourceImpl({
    this.ratesTtl = const Duration(minutes: 5),
    this.categoriesTtl = const Duration(minutes: 15),
    this.jewelleryTtl = const Duration(minutes: 15),
  });


  @override
  GoldRatesModel? getCachedGoldRates() {
    if (_cachedRates != null && _ratesCacheTime != null) {
      if (DateTime.now().difference(_ratesCacheTime!) < ratesTtl) {
        return _cachedRates;
      }
    }
    return _cachedRates; // Return stale rates if available for instant display
  }

  @override
  void cacheGoldRates(GoldRatesModel rates) {
    _cachedRates = rates;
    _ratesCacheTime = DateTime.now();
  }

  @override
  PaginatedResponse<CategoryModel>? getCachedCategories() {
    if (_cachedCategories != null && _categoriesCacheTime != null) {
      if (DateTime.now().difference(_categoriesCacheTime!) < categoriesTtl) {
        return _cachedCategories;
      }
    }
    return _cachedCategories; // Return stale categories if available for instant display
  }

  @override
  void cacheCategories(PaginatedResponse<CategoryModel> categories) {
    _cachedCategories = categories;
    _categoriesCacheTime = DateTime.now();
  }

  @override
  PaginatedResponse<JewelleryItemModel>? getCachedJewellery({String? category, String? search, int page = 1, int limit = 100}) {
    // Only return cache for page 1 to keep things simple
    if (page != 1) return null;

    final catKey = (category ?? 'All').trim().toLowerCase();
    final searchKey = (search ?? '').trim().toLowerCase();

    if (catKey != 'all' && searchKey.isEmpty && _categoryJewelleryCache.containsKey(catKey)) {
      return _categoryJewelleryCache[catKey];
    }

    if (_cachedJewelleryAll != null) {
      List<JewelleryItemModel> result = _cachedJewelleryAll!.items;

      if (catKey != 'all' && catKey.isNotEmpty) {
        result = result.where((item) => item.category.trim().toLowerCase() == catKey).toList();
      }

      if (searchKey.isNotEmpty) {
        result = result.where((item) {
          final nameMatch = item.name.toLowerCase().contains(searchKey);
          final catMatch = item.category.toLowerCase().contains(searchKey);
          final descMatch = item.description.toLowerCase().contains(searchKey);
          final synMatch = item.synonyms.any((syn) => syn.toLowerCase().contains(searchKey));
          return nameMatch || catMatch || descMatch || synMatch;
        }).toList();
      }
      
      // If filtering happened, return it as page 1
      if (catKey != 'all' || searchKey.isNotEmpty) {
        return PaginatedResponse<JewelleryItemModel>(
            items: result.take(limit).toList(),
            total: result.length,
            page: 1,
            totalPages: (result.length / limit).ceil(),
        );
      }

      return _cachedJewelleryAll;
    }

    return null;
  }

  @override
  void cacheJewellery(PaginatedResponse<JewelleryItemModel> items, {String? category, String? search, int page = 1, int limit = 100}) {
    // Only cache page 1 responses to prevent state inconsistencies
    if (page != 1) return;
    
    final catKey = (category ?? 'All').trim().toLowerCase();
    final searchKey = (search ?? '').trim().toLowerCase();

    if ((category == null || catKey == 'all') && searchKey.isEmpty) {
      _cachedJewelleryAll = items;
    } else if (catKey != 'all' && searchKey.isEmpty) {
      _categoryJewelleryCache[catKey] = items;
    }
  }

  @override
  void clearCache() {
    _cachedRates = null;
    _ratesCacheTime = null;
    _cachedCategories = null;
    _categoriesCacheTime = null;
    _cachedJewelleryAll = null;
    _categoryJewelleryCache.clear();
  }
}
