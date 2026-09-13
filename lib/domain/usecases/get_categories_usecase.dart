import '../../core/usecase/usecase.dart';
import '../entities/category_entity.dart';
import '../repositories/jewellery_repository.dart';

import '../../data/models/paginated_response.dart';
import 'package:equatable/equatable.dart';

class GetCategoriesParams extends Equatable {
  final int page;
  final int limit;

  const GetCategoriesParams({this.page = 1, this.limit = 100});

  @override
  List<Object?> get props => [page, limit];
}

class GetCategoriesUseCase implements UseCase<PaginatedResponse<CategoryEntity>, GetCategoriesParams> {
  final JewelleryRepository repository;

  GetCategoriesUseCase(this.repository);

  @override
  Future<PaginatedResponse<CategoryEntity>> call(GetCategoriesParams params) async {
    return await repository.getCategories(page: params.page, limit: params.limit);
  }
}
