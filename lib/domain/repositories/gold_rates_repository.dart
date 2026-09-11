import '../entities/gold_rates_entity.dart';

abstract class GoldRatesRepository {
  Future<GoldRatesEntity> getGoldRates();
  Stream<GoldRatesEntity> getGoldRatesStream({Duration interval = const Duration(seconds: 60)});
}
