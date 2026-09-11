import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/usecase/usecase.dart';
import '../../../domain/usecases/get_gold_rates_future_usecase.dart';
import '../../../domain/usecases/get_gold_rates_stream_usecase.dart';
import 'gold_rates_event.dart';
import 'gold_rates_state.dart';

class GoldRatesBloc extends Bloc<GoldRatesEvent, GoldRatesState> {
  final GetGoldRatesStreamUseCase getGoldRatesStreamUseCase;
  final GetGoldRatesFutureUseCase getGoldRatesFutureUseCase;
  StreamSubscription? _ratesSubscription;

  GoldRatesBloc({
    required this.getGoldRatesStreamUseCase,
    required this.getGoldRatesFutureUseCase,
  }) : super(GoldRatesInitial()) {
    on<StartGoldRatesStream>(_onStartGoldRatesStream);
    on<GoldRatesUpdated>(_onGoldRatesUpdated);
    on<FetchGoldRatesOnce>(_onFetchGoldRatesOnce);
  }

  Future<void> _onStartGoldRatesStream(
    StartGoldRatesStream event,
    Emitter<GoldRatesState> emit,
  ) async {
    emit(GoldRatesLoading());
    await _ratesSubscription?.cancel();
    _ratesSubscription = getGoldRatesStreamUseCase(NoParams()).listen(
      (rates) => add(GoldRatesUpdated(rates)),
      onError: (err) => emit(GoldRatesError(err.toString())),
    );
  }

  void _onGoldRatesUpdated(
    GoldRatesUpdated event,
    Emitter<GoldRatesState> emit,
  ) {
    emit(GoldRatesLoaded(event.rates));
  }

  Future<void> _onFetchGoldRatesOnce(
    FetchGoldRatesOnce event,
    Emitter<GoldRatesState> emit,
  ) async {
    emit(GoldRatesLoading());
    try {
      final rates = await getGoldRatesFutureUseCase(NoParams());
      emit(GoldRatesLoaded(rates));
    } catch (e) {
      emit(GoldRatesError(e.toString()));
    }
  }

  @override
  Future<void> close() {
    _ratesSubscription?.cancel();
    return super.close();
  }
}
