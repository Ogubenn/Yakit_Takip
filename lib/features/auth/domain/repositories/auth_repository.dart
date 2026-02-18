import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb;
import '../entities/user.dart';

/// Auth Repository Interface (Domain Layer)
abstract class AuthRepository {
  /// Get current user
  Future<Either<String, User?>> getCurrentUser();

  /// Sign in with email and password
  Future<Either<String, User>> signInWithEmail(String email, String password);

  /// Sign up with email and password
  Future<Either<String, User>> signUpWithEmail(String email, String password);

  /// Sign in with Google
  Future<Either<String, User>> signInWithGoogle();

  /// Sign out
  Future<Either<String, void>> signOut();

  /// Update user profile
  Future<Either<String, User>> updateProfile(User user);

  /// Delete account
  Future<Either<String, void>> deleteAccount();

  /// Check if user is signed in
  bool isSignedIn();

  /// Listen to auth state changes
  Stream<fb.User?> authStateChanges();

  /// Reset password
  Future<Either<String, void>> resetPassword(String email);
}
