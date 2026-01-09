import 'package:booko/core/error/failures.dart';
import 'package:dartz/dartz.dart';

abstract class UseCaseWithParams<Type, Params> {
  Future<Either<Failure, Type>> call(Params params);
}
