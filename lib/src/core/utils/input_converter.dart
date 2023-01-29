import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../error/failures.dart';

class InputConverter extends Equatable {
  Either<Failure, int> stringToUnSignInt(String str) {
    try {
      final integer = int.parse(str);
      if (integer < 0) {
        throw const FormatException();
      }
      return Right(integer);
    } on FormatException {
      return Left(InvalidFailure());
    }
  }

  @override
  List<Object?> get props => [];
}

class InvalidFailure extends Failure {}
