import '../../domain/entities/category_entity.dart';
import '../../domain/entities/jewellery_item_entity.dart';
import '../../domain/repositories/jewellery_repository.dart';
import '../datasources/jewellery_remote_data_source.dart';

class JewelleryRepositoryImpl implements JewelleryRepository {
  final JewelleryRemoteDataSource remoteDataSource;

  JewelleryRepositoryImpl({
    required this.remoteDataSource,
  });

  @override
  Future<List<CategoryEntity>> getCategories() async {
    // Exclusively fetch real categories from backend API
    return await remoteDataSource.getCategories();
  }

  @override
  Future<List<JewelleryItemEntity>> getJewellery({String? category, String? search}) async {
    // Exclusively fetch real jewellery from backend API
    return await remoteDataSource.getJewellery(category: category, search: search);
  }

  @override
  Future<JewelleryItemEntity> getJewelleryById(dynamic id) async {
    final all = await getJewellery();
    return all.firstWhere((i) => i.id.toString() == id.toString());
  }
}
