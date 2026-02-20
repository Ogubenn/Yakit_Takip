import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/user.dart';
import '../services/api_auth_service.dart';
import '../services/sync_service.dart';

// Services
final apiAuthService = Provider((ref) => ApiAuthService());
final syncServiceProvider = Provider((ref) => SyncService());

// Current user state provider
final currentUserProvider = StateNotifierProvider<AuthNotifier, User?>((ref) {
  return AuthNotifier(ref);
});

// Auth state (is user logged in)
final isAuthenticatedProvider = Provider<bool>((ref) {
  final user = ref.watch(currentUserProvider);
  return user != null;
});

class AuthNotifier extends StateNotifier<User?> {
  final Ref ref;
  Box<User>? _userBox;
  late ApiAuthService _apiAuthService;
  late SyncService _syncService;

  AuthNotifier(this.ref) : super(null) {
    _apiAuthService = ref.read(apiAuthService);
    _syncService = ref.read(syncServiceProvider);
    _loadUser();
  }

  Future<void> _loadUser() async {
    try {
      // Try to get user from API first
      final isLoggedIn = await _apiAuthService.isLoggedIn();
      if (isLoggedIn) {
        try {
          final user = await _apiAuthService.getCurrentUser();
          state = user;
          
          // Auto sync if needed
          if (await _syncService.needsSync()) {
            _syncService.autoSync();
          }
          return;
        } catch (e) {
          print('Error fetching user from API: $e');
        }
      }

      // Fallback to local storage
      _userBox = await Hive.openBox<User>('users');
      final user = _userBox?.get('currentUser');
      if (user != null) {
        state = user;
      }
    } catch (e) {
      print('Error loading user: $e');
    }
  }

  // Manual registration (API + Local)
  Future<bool> registerManual({
    required String name,
    required String city,
    String? email,
    String? password,
  }) async {
    try {
      // Register via API
      final result = await _apiAuthService.register(
        name: name,
        city: city,
        email: email,
        password: password,
      );

      final user = result['user'] as User;
      
      // Save locally as backup
      _userBox = await Hive.openBox<User>('users');
      await _userBox?.put('currentUser', user);
      
      state = user;

      // Initial sync from server
      await _syncService.syncFromServer();
      
      return true;
    } catch (e) {
      print('Error registering user: $e');
      
      // Fallback to local-only registration
      return await _registerLocalOnly(name: name, city: city);
    }
  }

  // Local-only registration (offline fallback)
  Future<bool> _registerLocalOnly({
    required String name,
    required String city,
  }) async {
    try {
      final user = User(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: name,
        city: city,
        authProvider: 'manual',
        createdAt: DateTime.now(),
        lastLoginAt: DateTime.now(),
      );

      _userBox = await Hive.openBox<User>('users');
      await _userBox?.put('currentUser', user);
      state = user;
      return true;
    } catch (e) {
      print('Error in local registration: $e');
      return false;
    }
  }

  // Google Sign In (API + Local)
  Future<bool> signInWithGoogle({
    required String providerId,
    required String name,
    String? email,
  }) async {
    try {
      final result = await _apiAuthService.socialLogin(
        provider: 'google',
        providerId: providerId,
        name: name,
        city: 'İstanbul', // Default, can be updated later
        email: email,
      );

      final user = result['user'] as User;
      
      _userBox = await Hive.openBox<User>('users');
      await _userBox?.put('currentUser', user);
      
      state = user;

      // Sync data
      await _syncService.syncFromServer();
      
      return true;
    } catch (e) {
      print('Error signing in with Google: $e');
      return false;
    }
  }

  // Apple Sign In (API + Local)
  Future<bool> signInWithApple({
    required String providerId,
    required String name,
    String? email,
  }) async {
    try {
      final result = await _apiAuthService.socialLogin(
        provider: 'apple',
        providerId: providerId,
        name: name,
        city: 'İstanbul', // Default, can be updated later
        email: email,
      );

      final user = result['user'] as User;
      
      _userBox = await Hive.openBox<User>('users');
      await _userBox?.put('currentUser', user);
      
      state = user;

      // Sync data
      await _syncService.syncFromServer();
      
      return true;
    } catch (e) {
      print('Error signing in with Apple: $e');
      return false;
    }
  }

  // Update user profile (API + Local)
  Future<bool> updateProfile({
    String? name,
    String? city,
    String? email,
  }) async {
    try {
      if (state == null) return false;

      // Update via API
      final updatedUser = await _apiAuthService.updateProfile(
        name: name,
        city: city,
        email: email,
      );

      // Update local cache
      _userBox = await Hive.openBox<User>('users');
      await _userBox?.put('currentUser', updatedUser);
      
      state = updatedUser;
      
      return true;
    } catch (e) {
      print('Error updating profile: $e');
      
      // Fallback to local update
      if (state == null) return false;
      
      final updatedUser = state!.copyWith(
        name: name,
        city: city,
        email: email,
      );

      await _userBox?.put('currentUser', updatedUser);
      state = updatedUser;
      
      return true;
    }
  }

  // Sign out (API + Local)
  Future<void> signOut() async {
    try {
      // Logout from API
      await _apiAuthService.logout();
    } catch (e) {
      print('Error logging out from API: $e');
    }
    
    // Clear local data
    await _userBox?.delete('currentUser');
    state = null;
  }

  // Force sync with server
  Future<bool> syncWithServer() async {
    try {
      await _syncService.syncToServer();
      return true;
    } catch (e) {
      print('Error syncing with server: $e');
      return false;
    }
  }
}
