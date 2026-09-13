import 'package:equatable/equatable.dart';
import '../../core/usecase/usecase.dart';
import '../entities/jewellery_item_entity.dart';
import '../repositories/jewellery_repository.dart';

import '../../data/models/paginated_response.dart';

class GetJewelleryParams extends Equatable {
  final String? category;
  final String? search;
  final int page;
  final int limit;

  const GetJewelleryParams({this.category, this.search, this.page = 1, this.limit = 100});

  @override
  List<Object?> get props => [category, search, page, limit];
}

class GetJewelleryUseCase implements UseCase<PaginatedResponse<JewelleryItemEntity>, GetJewelleryParams> {
  final JewelleryRepository repository;

  GetJewelleryUseCase(this.repository);

  @override
  Future<PaginatedResponse<JewelleryItemEntity>> call(GetJewelleryParams params) async {
    return await repository.getJewellery(
      category: params.category,
      search: params.search,
      page: params.page,
      limit: params.limit,
    );
  }
}
