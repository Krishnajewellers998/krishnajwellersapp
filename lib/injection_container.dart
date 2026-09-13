import 'package:dio/dio.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:path_provider/path_provider.dart';
import 'data/datasources/jewellery_local_data_source.dart';
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
  static final Dio dio = Dio(BaseOptions(
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 10),
    sendTimeout: const Duration(seconds: 10),
    headers: {
      'Accept': 'application/json, text/plain, */*',
      'Connection': 'keep-alive',
    },
  ));

  static Dio get httpClient => dio;

  // Fast local in-memory & TTL cache
  static final JewelleryLocalDataSource localDataSource = JewelleryLocalDataSourceImpl();

  // Optimized remote backend data source
  static final JewelleryRemoteDataSource remoteDataSource = JewelleryRemoteDataSourceImpl(dio: dio);

  static final GoldRatesRepository goldRatesRepository = GoldRatesRepositoryImpl(
    remoteDataSource: remoteDataSource,
    localDataSource: localDataSource,
  );

  static final JewelleryRepository jewelleryRepository = JewelleryRepositoryImpl(
    remoteDataSource: remoteDataSource,
    localDataSource: localDataSource,
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

  // Background prefetch and backend warm-up
  static Future<void> init() async {
    try {
      final appDocDir = await getApplicationDocumentsDirectory();
      final cookieJar = PersistCookieJar(
        ignoreExpires: true,
        storage: FileStorage("${appDocDir.path}/.cookies/"),
      );
      dio.interceptors.add(CookieManager(cookieJar));
    } catch (e) {
      // Fallback to in-memory if persist fails
      dio.interceptors.add(CookieManager(CookieJar()));
    }
    remoteDataSource.prefetchAll();
  }

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
