import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable{
  final List<dynamic> properties;
  const Failure([this.properties = const <dynamic>[]]);
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class ServerFailure extends Failure{}
class CacheFailure extends Failure{}