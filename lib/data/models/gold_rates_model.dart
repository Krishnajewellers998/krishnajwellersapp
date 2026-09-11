import '../../domain/entities/gold_rates_entity.dart';

class GoldRatesModel extends GoldRatesEntity {
  const GoldRatesModel({
    required super.rate24K,
    required super.rate22K,
    required super.rate18K,
    super.updatedAt,
  });

  factory GoldRatesModel.fromJson(Map<String, dynamic> json) {
    final rates = json['goldRates'] is Map ? json['goldRates'] : json;
    final r24 = rates['24K'] ?? rates['rate24'] ?? 0;
    final r22 = rates['22K'] ?? rates['rate22'] ?? 0;
    final r18 = rates['18K'] ?? rates['rate18'] ?? 0;

    return GoldRatesModel(
      rate24K: (r24 is num) ? r24.toInt() : int.tryParse(r24.toString()) ?? 0,
      rate22K: (r22 is num) ? r22.toInt() : int.tryParse(r22.toString()) ?? 0,
      rate18K: (r18 is num) ? r18.toInt() : int.tryParse(r18.toString()) ?? 0,
      updatedAt: json['updatedAt']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'goldRates': {
        '24K': rate24K,
        '22K': rate22K,
        '18K': rate18K,
      },
      'updatedAt': updatedAt,
    };
  }
}
