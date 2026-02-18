import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb;
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_datasource.dart';
import '../datasources/user_local_datasource.dart';
import '../models/user_model.dart';

/// Auth Repository Implementation
class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final UserLocalDataSource localDataSource;

  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<Either<String, User?>> getCurrentUser() async {
    try {
      // Try local first
      final localUser = await localDataSource.getCurrentUser();
      if (localUser != null) {
        return Right(User.fromJson(localUser.toEntity()));
      }

      // Try remote
      final remoteUser = await remoteDataSource.getCurrentUser();
      if (remoteUser != null) {
        await localDataSource.saveUser(remoteUser);
        return Right(User.fromJson(remoteUser.toEntity()));
      }

      return const Right(null);
    } catch (e) {
      return Left('Kullanıcı bilgileri getirilemedi: ${e.toString()}');
    }
  }

  @override
  Future<Either<String, User>> signInWithEmail(
      String email, String password) async {
    try {
      final userModel = await remoteDataSource.signInWithEmail(email, password);
      await localDataSource.saveUser(userModel);
      return Right(User.fromJson(userModel.toEntity()));
    } on fb.FirebaseAuthException catch (e) {
      return Left(_getFirebaseAuthErrorMessage(e.code));
    } catch (e) {
      return Left('Giriş başarısız: ${e.toString()}');
    }
  }

  @override
  Future<Either<String, User>> signUpWithEmail(
      String email, String password) async {
    try {
      final userModel = await remoteDataSource.signUpWithEmail(email, password);
      await localDataSource.saveUser(userModel);
      return Right(User.fromJson(userModel.toEntity()));
    } on fb.FirebaseAuthException catch (e) {
      return Left(_getFirebaseAuthErrorMessage(e.code));
    } catch (e) {
      return Left('Kayıt başarısız: ${e.toString()}');
    }
  }

  @override
  Future<Either<String, User>> signInWithGoogle() async {
    try {
      final userModel = await remoteDataSource.signInWithGoogle();
      await localDataSource.saveUser(userModel);
      return Right(User.fromJson(userModel.toEntity()));
    } on fb.FirebaseAuthException catch (e) {
      return Left(_getFirebaseAuthErrorMessage(e.code));
    } catch (e) {
      return Left('Google ile giriş başarısız: ${e.toString()}');
    }
  }

  @override
  Future<Either<String, void>> signOut() async {
    try {
      await remoteDataSource.signOut();
      await localDataSource.deleteUser();
      return const Right(null);
    } catch (e) {
      return Left('Çıkış başarısız: ${e.toString()}');
    }
  }

  @override
  Future<Either<String, User>> updateProfile(User user) async {
    try {
      final model = UserModel.fromEntity({
        ...user.toJson(),
        'updatedAt': DateTime.now().toIso8601String(),
      });

      final updatedModel = await remoteDataSource.updateProfile(model);
      await localDataSource.updateUser(updatedModel);
      return Right(User.fromJson(updatedModel.toEntity()));
    } catch (e) {
      return Left('Profil güncellenemedi: ${e.toString()}');
    }
  }

  @override
  Future<Either<String, void>> deleteAccount() async {
    try {
      await remoteDataSource.deleteAccount();
      await localDataSource.deleteUser();
      return const Right(null);
    } catch (e) {
      return Left('Hesap silinemedi: ${e.toString()}');
    }
  }

  @override
  bool isSignedIn() {
    return remoteDataSource.isSignedIn();
  }

  @override
  Stream<fb.User?> authStateChanges() {
    return remoteDataSource.authStateChanges();
  }

  @override
  Future<Either<String, void>> resetPassword(String email) async {
    try {
      await remoteDataSource.resetPassword(email);
      return const Right(null);
    } on fb.FirebaseAuthException catch (e) {
      return Left(_getFirebaseAuthErrorMessage(e.code));
    } catch (e) {
      return Left('Şifre sıfırlama başarısız: ${e.toString()}');
    }
  }

  String _getFirebaseAuthErrorMessage(String code) {
    switch (code) {
      case 'user-not-found':
        return 'Kullanıcı bulunamadı';
      case 'wrong-password':
        return 'Hatalı şifre';
      case 'email-already-in-use':
        return 'Bu e-posta adresi zaten kullanımda';
      case 'invalid-email':
        return 'Geçersiz e-posta adresi';
      case 'weak-password':
        return 'Şifre çok zayıf';
      case 'user-disabled':
        return 'Kullanıcı hesabı devre dışı';
      case 'too-many-requests':
        return 'Çok fazla deneme. Lütfen daha sonra tekrar deneyin';
      case 'operation-not-allowed':
        return 'Bu işlem izinli değil';
      default:
        return 'Bir hata oluştu: $code';
    }
  }
}
