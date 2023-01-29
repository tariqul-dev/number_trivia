import 'package:dartz/dartz.dart';
import 'package:number_trivia/src/core/error/exceptions.dart';
import 'package:number_trivia/src/core/error/failures.dart';
import 'package:number_trivia/src/core/network/network_info.dart';
import 'package:number_trivia/src/features/number-trivia/data/data-sources/number_trivia_local_data_source.dart';
import 'package:number_trivia/src/features/number-trivia/data/data-sources/number_trivia_remote_data_source.dart';
import 'package:number_trivia/src/features/number-trivia/domain/entities/number_trivia.dart';
import 'package:number_trivia/src/features/number-trivia/domain/repositories/number_trivia_repository.dart';

import '../models/number_trivia_model.dart';

typedef _ChooseFunctionCall = Future<NumberTriviaModel> Function();

class NumberTriviaRepositoryImpl implements NumberTriviaRepository {
  final NumberTriviaRemoteDataSource remoteDataSource;
  final NumberTriviaLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  NumberTriviaRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, NumberTrivia>>? getConcreteNumberTrivia(
      int number) async {
    return await _getTrivia(
        () => remoteDataSource.getConcreteNumberTrivia(number)!);
  }

  @override
  Future<Either<Failure, NumberTrivia>>? getRandomNumberTrivia() async {
    return await _getTrivia(() => remoteDataSource.getRandomNumberTrivia()!);
  }

  Future<Either<Failure, NumberTrivia>> _getTrivia(
      _ChooseFunctionCall chooseFunctionCall) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteTrivia = await chooseFunctionCall();
        localDataSource.cacheNumberTrivia(remoteTrivia);
        return Right(remoteTrivia);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      try {
        final localTrivia = await localDataSource.getLastNumberTrivia();
        return Right(localTrivia!);
      } on CacheException {
        return Left(CacheFailure());
      }
    }
  }
}
