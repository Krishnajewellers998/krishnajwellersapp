import 'package:dio/dio.dart';
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

/// Dependency container — mirrors the website's simple fetch() approach.
///
/// Vercel serverless = no cold starts, no cookie sessions, no warm-up calls.
/// Single Dio instance with clean timeouts matching the website's behaviour.
class ServiceLocator {
  /// Shared Dio client — mirrors website's fetch() default headers.
  /// Content-Type: application/json is set per-request by Dio automatically.
  static final Dio dio = Dio(BaseOptions(
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 15),
    sendTimeout: const Duration(seconds: 10),
    headers: {
      'Accept': 'application/json',
      'Connection': 'keep-alive',
    },
  ));

  static Dio get httpClient => dio;

  // In-memory TTL cache for instant re-renders
  static final JewelleryLocalDataSource localDataSource =
      JewelleryLocalDataSourceImpl();

  // Clean remote source — single request per call, no retries
  static final JewelleryRemoteDataSource remoteDataSource =
      JewelleryRemoteDataSourceImpl(dio: dio);

  static final GoldRatesRepository goldRatesRepository = GoldRatesRepositoryImpl(
    remoteDataSource: remoteDataSource,
    localDataSource: localDataSource,
  );

  static final JewelleryRepository jewelleryRepository = JewelleryRepositoryImpl(
    remoteDataSource: remoteDataSource,
    localDataSource: localDataSource,
  );

  // ─── Use Cases ───────────────────────────────────────────────────────────
  static final GetGoldRatesStreamUseCase getGoldRatesStreamUseCase =
      GetGoldRatesStreamUseCase(goldRatesRepository);

  static final GetGoldRatesFutureUseCase getGoldRatesFutureUseCase =
      GetGoldRatesFutureUseCase(goldRatesRepository);

  static final GetCategoriesUseCase getCategoriesUseCase =
      GetCategoriesUseCase(jewelleryRepository);

  static final GetJewelleryUseCase getJewelleryUseCase =
      GetJewelleryUseCase(jewelleryRepository);

  // ─── Init ─────────────────────────────────────────────────────────────────
  /// Nothing async to set up on Vercel serverless — just a synchronous return.
  static Future<void> init() async {
    // No cookie jars, no warm-up calls, no Render cold-start prefetch.
    // Vercel functions respond immediately on every request.
  }

  // ─── BLoC Factories ──────────────────────────────────────────────────────
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
