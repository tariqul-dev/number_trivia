import 'dart:convert';

import 'package:number_trivia/src/core/error/exceptions.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/number_trivia_model.dart';

abstract class NumberTriviaLocalDataSource {
  /// Get last number trivia from local data source
  /// throws [CacheException]
  Future<NumberTriviaModel>? getLastNumberTrivia();

  /// Cache last number trivia to local data source
  /// throws [CacheException]
  Future<void>? cacheNumberTrivia(NumberTriviaModel triviaToCache);
}

const String cacheNumberTriviaKey = 'CACHE_NUMBER_TRIVIA';

class NumberTriviaLocalDataSourceImpl implements NumberTriviaLocalDataSource {
  final SharedPreferences sharedPreferences;

  NumberTriviaLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<void>? cacheNumberTrivia(NumberTriviaModel triviaToCache) {
    return sharedPreferences.setString(
        cacheNumberTriviaKey, json.encode(triviaToCache.toJson()));
  }

  @override
  Future<NumberTriviaModel>? getLastNumberTrivia() {
    final jsonString = sharedPreferences.getString(cacheNumberTriviaKey);
    if (jsonString != null) {
      return Future.value(NumberTriviaModel.fromJson(json.decode(jsonString)));
    } else {
      throw CacheException();
    }
  }
}
