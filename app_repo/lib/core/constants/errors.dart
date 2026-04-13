import 'package:fpdart/fpdart.dart';

class Failure {
  final String message;
  Failure([this.message = 'An unexpected error occurred.']);
}

class ServerException implements Exception {
  final String message;
  const ServerException(this.message);

  @override
  String toString() => 'ServerException: $message';
}

abstract interface class UseCase<SuccessType, Params> {
  Future<Either<Failure, SuccessType>> call(Params params);
}

class NoParams {}
