import 'package:equatable/equatable.dart';
import '../../core/usecase/usecase.dart';
import '../entities/jewellery_item_entity.dart';
import '../repositories/jewellery_repository.dart';

class GetJewelleryParams extends Equatable {
  final String? category;
  final String? search;

  const GetJewelleryParams({this.category, this.search});

  @override
  List<Object?> get props => [category, search];
}

class GetJewelleryUseCase implements UseCase<List<JewelleryItemEntity>, GetJewelleryParams> {
  final JewelleryRepository repository;

  GetJewelleryUseCase(this.repository);

  @override
  Future<List<JewelleryItemEntity>> call(GetJewelleryParams params) async {
    return await repository.getJewellery(
      category: params.category,
      search: params.search,
    );
  }
}
