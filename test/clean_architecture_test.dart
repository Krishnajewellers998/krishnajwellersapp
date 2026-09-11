import 'package:flutter_test/flutter_test.dart';
import 'package:krishna_jewellers_mobile/core/usecase/usecase.dart';
import 'package:krishna_jewellers_mobile/domain/entities/gold_rates_entity.dart';
import 'package:krishna_jewellers_mobile/domain/repositories/gold_rates_repository.dart';
import 'package:krishna_jewellers_mobile/domain/usecases/get_gold_rates_future_usecase.dart';
import 'package:krishna_jewellers_mobile/domain/usecases/get_gold_rates_stream_usecase.dart';
import 'package:krishna_jewellers_mobile/presentation/blocs/gold_rates/gold_rates_bloc.dart';
import 'package:krishna_jewellers_mobile/presentation/blocs/gold_rates/gold_rates_event.dart';
import 'package:krishna_jewellers_mobile/presentation/blocs/gold_rates/gold_rates_state.dart';

class MockGoldRatesRepository implements GoldRatesRepository {
  final GoldRatesEntity mockRates = const GoldRatesEntity(
    rate24K: 160000,
    rate22K: 146600,
    rate18K: 120000,
    updatedAt: '2026-09-11T10:00:00Z',
  );

  @override
  Future<GoldRatesEntity> getGoldRates() async {
    return mockRates;
  }

  @override
  Stream<GoldRatesEntity> getGoldRatesStream({Duration interval = const Duration(seconds: 60)}) async* {
    yield mockRates;
  }
}

void main() {
  late MockGoldRatesRepository repository;
  late GetGoldRatesFutureUseCase futureUseCase;
  late GetGoldRatesStreamUseCase streamUseCase;
  late GoldRatesBloc bloc;

  setUp(() {
    repository = MockGoldRatesRepository();
    futureUseCase = GetGoldRatesFutureUseCase(repository);
    streamUseCase = GetGoldRatesStreamUseCase(repository);
    bloc = GoldRatesBloc(
      getGoldRatesStreamUseCase: streamUseCase,
      getGoldRatesFutureUseCase: futureUseCase,
    );
  });

  tearDown(() {
    bloc.close();
  });

  test('GetGoldRatesFutureUseCase should return rates from repository', () async {
    final result = await futureUseCase(NoParams());
    expect(result.rate24K, 160000);
    expect(result.rate22K, 146600);
    expect(result.rate18K, 120000);
  });

  test('GetGoldRatesStreamUseCase should stream rates from repository', () async {
    final stream = streamUseCase(NoParams());
    final firstEmission = await stream.first;
    expect(firstEmission.rate24K, 160000);
    expect(firstEmission.rate22K, 146600);
  });

  test('GoldRatesBloc initial state is GoldRatesInitial', () {
    expect(bloc.state, isA<GoldRatesInitial>());
  });

  test('GoldRatesBloc emits [GoldRatesLoading, GoldRatesLoaded] when FetchGoldRatesOnce is added', () async {
    final expected = [
      isA<GoldRatesLoading>(),
      isA<GoldRatesLoaded>(),
    ];

    expectLater(bloc.stream, emitsInOrder(expected));

    bloc.add(FetchGoldRatesOnce());
  });
}
