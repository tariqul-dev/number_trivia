import 'package:dartz/dartz.dart';
import 'package:number_trivia/src/core/error/failures.dart';
import 'package:number_trivia/src/core/use-cases/use_case.dart';
import 'package:number_trivia/src/features/number-trivia/domain/entities/number_trivia.dart';
import 'package:number_trivia/src/features/number-trivia/domain/repositories/number_trivia_repository.dart';

class GetRandomNumberTrivia extends UseCase<NumberTrivia, NoParams> {
  final NumberTriviaRepository repository;

  GetRandomNumberTrivia({required this.repository});

  @override
  Future<Either<Failure, NumberTrivia>?> call(NoParams params) async {
    return await repository.getRandomNumberTrivia();
  }
}
