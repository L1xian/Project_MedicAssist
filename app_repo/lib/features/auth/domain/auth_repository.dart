import 'package:blog_app/core/cubits/app_user/user.dart';
import 'package:blog_app/core/constants/errors.dart';
import 'package:fpdart/fpdart.dart';

abstract interface class AuthRepository {
  Future<Either<Failure, User>> signUpWithEmailPassword({
    required String name,
    required String email,
    required String password,
  });

  Future<Either<Failure, User>> loginWithEmailPassword({
    required String email,
    required String password,
  });

  Future<Either<Failure, User>> currentUser();
  
  Future<Either<Failure, void>> signOut();
}
