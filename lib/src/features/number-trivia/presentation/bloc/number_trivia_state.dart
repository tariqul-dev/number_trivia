part of 'number_trivia_bloc.dart';

abstract class NumberTriviaState extends Equatable {
  const NumberTriviaState();
  @override
  List<Object> get props => [];
}

class NumberTriviaInitial extends NumberTriviaState {

}

class EmptyState extends NumberTriviaState{}

class LoadingState extends NumberTriviaState{}

class LoadedState extends NumberTriviaState{
  final NumberTrivia numberTrivia;
  const LoadedState({required this.numberTrivia});
}

class ErrorState extends NumberTriviaState{
  final String message;

  const ErrorState({required this.message});
}



