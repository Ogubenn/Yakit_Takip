import 'package:dartz/dartz.dart';
import '../entities/user.dart';
import '../repositories/auth_repository.dart';

/// Sign In With Email Use Case
class SignInWithEmail {
  final AuthRepository repository;

  SignInWithEmail(this.repository);

  Future<Either<String, User>> call(String email, String password) async {
    // Validate inputs
    if (email.isEmpty) {
      return const Left('E-posta adresi gerekli');
    }
    if (!_isValidEmail(email)) {
      return const Left('Geçersiz e-posta adresi');
    }
    if (password.isEmpty) {
      return const Left('Şifre gerekli');
    }
    if (password.length < 6) {
      return const Left('Şifre en az 6 karakter olmalıdır');
    }

    return await repository.signInWithEmail(email, password);
  }

  bool _isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }
}
