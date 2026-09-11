import '../../core/usecase/usecase.dart';
import '../entities/gold_rates_entity.dart';
import '../repositories/gold_rates_repository.dart';

class GetGoldRatesFutureUseCase implements UseCase<GoldRatesEntity, NoParams> {
  final GoldRatesRepository repository;

  GetGoldRatesFutureUseCase(this.repository);

  @override
  Future<GoldRatesEntity> call(NoParams params) async {
    return await repository.getGoldRates();
  }
}
