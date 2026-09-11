import '../../core/usecase/usecase.dart';
import '../entities/category_entity.dart';
import '../repositories/jewellery_repository.dart';

class GetCategoriesUseCase implements UseCase<List<CategoryEntity>, NoParams> {
  final JewelleryRepository repository;

  GetCategoriesUseCase(this.repository);

  @override
  Future<List<CategoryEntity>> call(NoParams params) async {
    return await repository.getCategories();
  }
}
