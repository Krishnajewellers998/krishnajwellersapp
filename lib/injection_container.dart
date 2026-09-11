import 'package:http/http.dart' as http;
import 'data/datasources/jewellery_remote_data_source.dart';
import 'data/repositories/gold_rates_repository_impl.dart';
import 'data/repositories/jewellery_repository_impl.dart';
import 'domain/repositories/gold_rates_repository.dart';
import 'domain/repositories/jewellery_repository.dart';
import 'domain/usecases/get_categories_usecase.dart';
import 'domain/usecases/get_gold_rates_future_usecase.dart';
import 'domain/usecases/get_gold_rates_stream_usecase.dart';
import 'domain/usecases/get_jewellery_usecase.dart';
import 'presentation/blocs/categories/categories_bloc.dart';
import 'presentation/blocs/gold_rates/gold_rates_bloc.dart';
import 'presentation/blocs/jewellery/jewellery_bloc.dart';

class ServiceLocator {
  static final http.Client httpClient = http.Client();

  // Exclusively remote backend data source - no dummy or local data
  static final JewelleryRemoteDataSource remoteDataSource =
      JewelleryRemoteDataSourceImpl(client: httpClient);

  static final GoldRatesRepository goldRatesRepository = GoldRatesRepositoryImpl(
    remoteDataSource: remoteDataSource,
  );

  static final JewelleryRepository jewelleryRepository = JewelleryRepositoryImpl(
    remoteDataSource: remoteDataSource,
  );

  // Use Cases
  static final GetGoldRatesStreamUseCase getGoldRatesStreamUseCase =
      GetGoldRatesStreamUseCase(goldRatesRepository);

  static final GetGoldRatesFutureUseCase getGoldRatesFutureUseCase =
      GetGoldRatesFutureUseCase(goldRatesRepository);

  static final GetCategoriesUseCase getCategoriesUseCase =
      GetCategoriesUseCase(jewelleryRepository);

  static final GetJewelleryUseCase getJewelleryUseCase =
      GetJewelleryUseCase(jewelleryRepository);

  // Blocs
  static GoldRatesBloc createGoldRatesBloc() {
    return GoldRatesBloc(
      getGoldRatesStreamUseCase: getGoldRatesStreamUseCase,
      getGoldRatesFutureUseCase: getGoldRatesFutureUseCase,
    );
  }

  static CategoriesBloc createCategoriesBloc() {
    return CategoriesBloc(getCategoriesUseCase: getCategoriesUseCase);
  }

  static JewelleryBloc createJewelleryBloc() {
    return JewelleryBloc(getJewelleryUseCase: getJewelleryUseCase);
  }
}
