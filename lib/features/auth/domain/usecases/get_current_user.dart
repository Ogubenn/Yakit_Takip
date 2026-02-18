import 'package:dartz/dartz.dart';
import '../entities/user.dart';
import '../repositories/auth_repository.dart';

/// Get Current User Use Case
class GetCurrentUser {
  final AuthRepository repository;

  GetCurrentUser(this.repository);

  Future<Either<String, User?>> call() async {
    return await repository.getCurrentUser();
  }
}
