import 'dart:async';
import '../../domain/entities/gold_rates_entity.dart';
import '../../domain/repositories/gold_rates_repository.dart';
import '../datasources/jewellery_remote_data_source.dart';

class GoldRatesRepositoryImpl implements GoldRatesRepository {
  final JewelleryRemoteDataSource remoteDataSource;

  GoldRatesRepositoryImpl({
    required this.remoteDataSource,
  });

  @override
  Future<GoldRatesEntity> getGoldRates() async {
    // Exclusively fetch live rates from actual backend API
    return await remoteDataSource.getGoldRates();
  }

  @override
  Stream<GoldRatesEntity> getGoldRatesStream({
    Duration interval = const Duration(seconds: 60),
  }) async* {
    // Immediately fetch & emit live backend rates
    yield await getGoldRates();

    // Periodically stream fresh rates from backend API
    await for (final _ in Stream.periodic(interval)) {
      yield await getGoldRates();
    }
  }
}
