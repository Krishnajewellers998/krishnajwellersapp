import '../../domain/entities/gold_rates_entity.dart';

class GoldRatesModel extends GoldRatesEntity {
  const GoldRatesModel({
    required super.rate24K,
    required super.rate22K,
    required super.rate18K,
    super.updatedAt,
  });

  /// Parses the inner `goldRates` map from the backend/live-stream response.
  ///
  /// Website backend returns:
  ///   { success: true, goldRates: { "24K": n, "22K": n, "18K": n }, updatedAt: "..." }
  ///
  /// The remote datasource passes [decoded['goldRates']] here, i.e. the inner map.
  /// Live-stream path builds this map directly without a wrapper.
  /// Key names exactly match the website: "24K", "22K", "18K".
  factory GoldRatesModel.fromJson(Map<String, dynamic> json) {
    // Support both shapes: inner map {"24K":n} OR full response {"goldRates":{...}}
    final rates = (json['goldRates'] is Map<String, dynamic>)
        ? json['goldRates'] as Map<String, dynamic>
        : json;

    // Exact key names matching website goldRatesService.js output
    final r24 = rates['24K'] ?? rates['rate24K'] ?? 0;
    final r22 = rates['22K'] ?? rates['rate22K'] ?? 0;
    final r18 = rates['18K'] ?? rates['rate18K'] ?? 0;

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
