import 'dart:async';
import '../../domain/entities/gold_rates_entity.dart';
import '../../domain/repositories/gold_rates_repository.dart';
import '../datasources/jewellery_local_data_source.dart';
import '../datasources/jewellery_remote_data_source.dart';

class GoldRatesRepositoryImpl implements GoldRatesRepository {
  final JewelleryRemoteDataSource remoteDataSource;
  final JewelleryLocalDataSource localDataSource;

  Future<GoldRatesEntity>? _inFlightRates;

  GoldRatesRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<GoldRatesEntity> getGoldRates() async {
    final cached = localDataSource.getCachedGoldRates();
    if (cached != null) {
      _refreshRatesInBackground();
      return cached;
    }

    if (_inFlightRates != null) {
      return await _inFlightRates!;
    }

    _inFlightRates = _fetchAndCacheRates();
    try {
      final result = await _inFlightRates!;
      return result;
    } finally {
      _inFlightRates = null;
    }
  }

  Future<GoldRatesEntity> _fetchAndCacheRates() async {
    try {
      final remote = await remoteDataSource.getGoldRates();
      localDataSource.cacheGoldRates(remote);
      return remote;
    } catch (e) {
      final cached = localDataSource.getCachedGoldRates();
      if (cached != null) {
        return cached;
      }
      rethrow;
    }
  }

  void _refreshRatesInBackground() {
    if (_inFlightRates == null) {
      _inFlightRates = _fetchAndCacheRates();
      _inFlightRates!.catchError((_) => const GoldRatesEntity(rate24K: 0, rate22K: 0, rate18K: 0)).whenComplete(() {
        _inFlightRates = null;
      });
    }
  }

  @override
  Stream<GoldRatesEntity> getGoldRatesStream({
    Duration interval = const Duration(seconds: 60),
  }) async* {
    // Immediately yield cached rates for 0ms initial load if available
    final cached = localDataSource.getCachedGoldRates();
    if (cached != null) {
      yield cached;
    }

    // Fetch fresh live rates and yield
    try {
      yield await getGoldRates();
    } catch (_) {}

    // Stream periodic updates
    await for (final _ in Stream.periodic(interval)) {
      try {
        yield await remoteDataSource.getGoldRates();
      } catch (_) {}
    }
  }
}
