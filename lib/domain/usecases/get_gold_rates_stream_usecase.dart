import '../../core/usecase/usecase.dart';
import '../entities/gold_rates_entity.dart';
import '../repositories/gold_rates_repository.dart';

class GetGoldRatesStreamUseCase implements StreamUseCase<GoldRatesEntity, NoParams> {
  final GoldRatesRepository repository;

  GetGoldRatesStreamUseCase(this.repository);

  @override
  Stream<GoldRatesEntity> call(NoParams params) {
    return repository.getGoldRatesStream();
  }
}
