import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:number_trivia/src/core/use-cases/use_case.dart';
import 'package:number_trivia/src/core/utils/input_converter.dart';
import 'package:number_trivia/src/features/number-trivia/domain/entities/number_trivia.dart';

import '../../../../core/error/failures.dart';
import '../../domain/use-cases/get_concrete_number_trivia.dart';
import '../../domain/use-cases/get_random_number_trivia.dart';

part 'number_trivia_event.dart';
part 'number_trivia_state.dart';

const String SERVER_FAILURE_MESSAGE = 'Server Failure';
const String CACHE_FAILURE_MESSAGE = 'Cache Failure';
const String INVALID_INPUT_FAILURE_MESSAGE =
    'Invalid Input - The number must be a positive integer or zero.';

class NumberTriviaBloc extends Bloc<NumberTriviaEvent, NumberTriviaState> {
  final GetConcreteNumberTrivia getConcreteNumberTrivia;
  final GetRandomNumberTrivia getRandomNumberTrivia;
  final InputConverter inputConverter;

  NumberTriviaBloc({
    required this.getConcreteNumberTrivia,
    required this.getRandomNumberTrivia,
    required this.inputConverter,
  }) : super(EmptyState()) {
    on<GetTriviaForConcreteNumber>((event, emit) async {
      final inputEither = inputConverter.stringToUnSignInt(event.numberString);

      await inputEither.fold(
        (failure) async  =>
            emit(const ErrorState(message: INVALID_INPUT_FAILURE_MESSAGE)),
        (integer)  async {
          emit(LoadingState());
          final failureOrTrivia =
              await getConcreteNumberTrivia(Params(integer));

          await failureOrTrivia!.fold(
            (failure) async =>
                emit(ErrorState(message: _mapFailureToMessage(failure))),
            (trivia) async => emit(LoadedState(numberTrivia: trivia)),
          );
        },
      );
    });

    on<GetTriviaForRandomNumber>((event, emit) async {
      emit(LoadingState());
      final failureOrTrivia = await getRandomNumberTrivia(NoParams());

      failureOrTrivia!.fold(
        (failure) => emit(ErrorState(message: _mapFailureToMessage(failure))),
        (trivia) => emit(LoadedState(numberTrivia: trivia)),
      );
    });
  }
  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return SERVER_FAILURE_MESSAGE;
      case CacheFailure:
        return CACHE_FAILURE_MESSAGE;
      default:
        return 'Unexpected error';
    }
  }
}
