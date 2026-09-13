import '../entities/category_entity.dart';
import '../entities/jewellery_item_entity.dart';

import '../../data/models/paginated_response.dart';

abstract class JewelleryRepository {
  Future<PaginatedResponse<CategoryEntity>> getCategories({int page = 1, int limit = 100});
  Future<PaginatedResponse<JewelleryItemEntity>> getJewellery({String? category, String? search, int page = 1, int limit = 100});
  Future<JewelleryItemEntity> getJewelleryById(dynamic id);
}
