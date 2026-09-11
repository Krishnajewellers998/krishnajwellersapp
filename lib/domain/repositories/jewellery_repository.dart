import '../entities/category_entity.dart';
import '../entities/jewellery_item_entity.dart';

abstract class JewelleryRepository {
  Future<List<CategoryEntity>> getCategories();
  Future<List<JewelleryItemEntity>> getJewellery({String? category, String? search});
  Future<JewelleryItemEntity> getJewelleryById(dynamic id);
}
