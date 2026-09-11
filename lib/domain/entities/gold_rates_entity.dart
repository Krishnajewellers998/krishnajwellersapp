import 'package:equatable/equatable.dart';

class GoldRatesEntity extends Equatable {
  final int rate24K;
  final int rate22K;
  final int rate18K;
  final String? updatedAt;

  const GoldRatesEntity({
    required this.rate24K,
    required this.rate22K,
    required this.rate18K,
    this.updatedAt,
  });

  @override
  List<Object?> get props => [rate24K, rate22K, rate18K, updatedAt];
}
