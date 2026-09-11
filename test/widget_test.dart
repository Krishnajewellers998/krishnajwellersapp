import 'package:flutter_test/flutter_test.dart';
import 'package:krishna_jewellers_mobile/injection_container.dart';

void main() {
  test('ServiceLocator initializes dependencies properly', () {
    expect(ServiceLocator.httpClient, isNotNull);
    expect(ServiceLocator.remoteDataSource, isNotNull);
    expect(ServiceLocator.goldRatesRepository, isNotNull);
    expect(ServiceLocator.jewelleryRepository, isNotNull);
    expect(ServiceLocator.getGoldRatesStreamUseCase, isNotNull);
    expect(ServiceLocator.getGoldRatesFutureUseCase, isNotNull);
    expect(ServiceLocator.getCategoriesUseCase, isNotNull);
    expect(ServiceLocator.getJewelleryUseCase, isNotNull);
  });
}
