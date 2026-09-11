import 'package:equatable/equatable.dart';
import '../../../domain/entities/gold_rates_entity.dart';

abstract class GoldRatesState extends Equatable {
  const GoldRatesState();

  @override
  List<Object?> get props => [];
}

class GoldRatesInitial extends GoldRatesState {}

class GoldRatesLoading extends GoldRatesState {}

class GoldRatesLoaded extends GoldRatesState {
  final GoldRatesEntity rates;

  const GoldRatesLoaded(this.rates);

  @override
  List<Object?> get props => [rates];
}

class GoldRatesError extends GoldRatesState {
  final String message;

  const GoldRatesError(this.message);

  @override
  List<Object?> get props => [message];
}
