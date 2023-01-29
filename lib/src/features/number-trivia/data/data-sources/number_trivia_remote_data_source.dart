import 'dart:convert';

import 'package:number_trivia/src/core/error/exceptions.dart';
import 'package:number_trivia/src/features/number-trivia/data/models/number_trivia_model.dart';
import 'package:http/http.dart' as http;

abstract class NumberTriviaRemoteDataSource {
  /// Calls http://numbersapi.com/$number
  /// end point
  /// throws [ServerException]
  Future<NumberTriviaModel>? getConcreteNumberTrivia(int number);

  /// Calls http://numbersapi.com/random
  /// end point
  /// throws [ServerException]
  Future<NumberTriviaModel>? getRandomNumberTrivia();
}

class NumberTriviaRemoteDatasourceImpl implements NumberTriviaRemoteDataSource {
  final http.Client client;

  NumberTriviaRemoteDatasourceImpl({required this.client});

  @override
  Future<NumberTriviaModel>? getConcreteNumberTrivia(int number) =>
      _numberTriviaFromUrl('http://numbersapi.com/$number');

  @override
  Future<NumberTriviaModel>? getRandomNumberTrivia() =>
      _numberTriviaFromUrl('http://numbersapi.com/random');

  Future<NumberTriviaModel> _numberTriviaFromUrl(String url) async {
    final response = await client
        .get(Uri.parse(url), headers: {'Content-Type': 'application/json'});

    if (response.statusCode == 200) {
      return NumberTriviaModel.fromJson(json.decode(response.body));
    } else {
      throw ServerException();
    }
  }
}
