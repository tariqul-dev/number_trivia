import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:number_trivia/src/core/network/network_info.dart';
import 'package:number_trivia/src/core/utils/input_converter.dart';
import 'package:number_trivia/src/features/number-trivia/data/data-sources/number_trivia_local_data_source.dart';
import 'package:number_trivia/src/features/number-trivia/data/data-sources/number_trivia_remote_data_source.dart';
import 'package:number_trivia/src/features/number-trivia/data/repositories/number_trivia_repository_impl.dart';
import 'package:number_trivia/src/features/number-trivia/domain/repositories/number_trivia_repository.dart';
import 'package:number_trivia/src/features/number-trivia/domain/use-cases/get_concrete_number_trivia.dart';
import 'package:number_trivia/src/features/number-trivia/domain/use-cases/get_random_number_trivia.dart';
import 'package:number_trivia/src/features/number-trivia/presentation/bloc/number_trivia_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

// service locator
final sl = GetIt.instance;

Future<void> init() async {
//! Features - Number trivia
// Bloc
  sl.registerFactory(
    () => NumberTriviaBloc(
      getConcreteNumberTrivia: sl(),
      getRandomNumberTrivia: sl(),
      inputConverter: sl(),
    ),
  );

// Use cases
  sl.registerLazySingleton(() => GetConcreteNumberTrivia(repository: sl()));
  sl.registerLazySingleton(() => GetRandomNumberTrivia(repository: sl()));

// Repository
  sl.registerLazySingleton<NumberTriviaRepository>(
    () => NumberTriviaRepositoryImpl(
      remoteDataSource: sl(),
      localDataSource: sl(),
      networkInfo: sl(),
    ),
  );

// Data sources
  sl.registerLazySingleton<NumberTriviaRemoteDataSource>(
    () => NumberTriviaRemoteDatasourceImpl(
      client: sl(),
    ),
  );
  sl.registerLazySingleton<NumberTriviaLocalDataSource>(
    () => NumberTriviaLocalDataSourceImpl(
      sharedPreferences: sl(),
    ),
  );

//! Core
  sl.registerLazySingleton(() => InputConverter());
  sl.registerLazySingleton<NetworkInfo>(
    () => NetworkInfoImpl(
      dataConnectionChecker: sl(),
    ),
  );

//! External
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  sl.registerLazySingleton(() => InternetConnectionChecker());
  sl.registerLazySingleton(() => http.Client());
}
