import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../features/auth/domain/entities/user.dart';
import '../features/auth/domain/repositories/auth_repository.dart';
import 'app_providers.dart';

part 'auth_provider.freezed.dart';

/// Auth State
@freezed
class AuthState with _$AuthState {
  const factory AuthState.initial() = _Initial;
  const factory AuthState.loading() = _Loading;
  const factory AuthState.authenticated(User user) = _Authenticated;
  const factory AuthState.unauthenticated() = _Unauthenticated;
  const factory AuthState.error(String message) = _Error;
}

/// Auth State Notifier
class AuthNotifier extends StateNotifier<AuthState> {
  final AuthRepository _repository;

  AuthNotifier(this._repository) : super(const AuthState.initial()) {
    _checkAuthStatus();
  }

  Future<void> _checkAuthStatus() async {
    state = const AuthState.loading();

    final result = await _repository.getCurrentUser();
    result.fold(
      (error) => state = AuthState.error(error),
      (user) {
        if (user != null) {
          state = AuthState.authenticated(user);
        } else {
          state = const AuthState.unauthenticated();
        }
      },
    );
  }

  Future<void> signInWithEmail(String email, String password) async {
    state = const AuthState.loading();

    final result = await _repository.signInWithEmail(email, password);
    result.fold(
      (error) => state = AuthState.error(error),
      (user) => state = AuthState.authenticated(user),
    );
  }

  Future<void> signUpWithEmail(String email, String password) async {
    state = const AuthState.loading();

    final result = await _repository.signUpWithEmail(email, password);
    result.fold(
      (error) => state = AuthState.error(error),
      (user) => state = AuthState.authenticated(user),
    );
  }

  Future<void> signInWithGoogle() async {
    state = const AuthState.loading();

    final result = await _repository.signInWithGoogle();
    result.fold(
      (error) => state = AuthState.error(error),
      (user) => state = AuthState.authenticated(user),
    );
  }

  Future<void> signOut() async {
    state = const AuthState.loading();

    final result = await _repository.signOut();
    result.fold(
      (error) => state = AuthState.error(error),
      (_) => state = const AuthState.unauthenticated(),
    );
  }

  Future<void> updateProfile(User user) async {
    state = const AuthState.loading();

    final result = await _repository.updateProfile(user);
    result.fold(
      (error) => state = AuthState.error(error),
      (updatedUser) => state = AuthState.authenticated(updatedUser),
    );
  }

  User? get currentUser {
    return state.maybeWhen(
      authenticated: (user) => user,
      orElse: () => null,
    );
  }

  bool get isAuthenticated {
    return state is _Authenticated;
  }

  bool get isPremium {
    return currentUser?.isPremium ?? false;
  }
}

// Provider for AuthNotifier
final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final repository = ref.watch(authRepositoryProvider);
  return AuthNotifier(repository);
});

// Convenience providers
final currentUserProvider = Provider<User?>((ref) {
  return ref.watch(authProvider.notifier).currentUser;
});

final isAuthenticatedProvider = Provider<bool>((ref) {
  return ref.watch(authProvider.notifier).isAuthenticated;
});

final isPremiumProvider = Provider<bool>((ref) {
  return ref.watch(authProvider.notifier).isPremium;
});
