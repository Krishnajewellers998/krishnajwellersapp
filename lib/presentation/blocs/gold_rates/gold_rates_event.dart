import 'package:equatable/equatable.dart';
import '../../../domain/entities/gold_rates_entity.dart';

abstract class GoldRatesEvent extends Equatable {
  const GoldRatesEvent();

  @override
  List<Object?> get props => [];
}

class StartGoldRatesStream extends GoldRatesEvent {}

class GoldRatesUpdated extends GoldRatesEvent {
  final GoldRatesEntity rates;

  const GoldRatesUpdated(this.rates);

  @override
  List<Object?> get props => [rates];
}

class FetchGoldRatesOnce extends GoldRatesEvent {}
