import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../core/constants/api_constants.dart';
import '../models/user.dart';
import 'api_client.dart';

class ApiAuthService {
  final ApiClient _apiClient = ApiClient();
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  // Register with email/password
  Future<Map<String, dynamic>> register({
    required String name,
    required String city,
    String? email,
    String? password,
  }) async {
    final response = await _apiClient.post(
      ApiConstants.register,
      data: {
        'name': name,
        'email': email,
        'password': password,
        'city': city,
        'auth_provider': 'manual',
      },
    );

    final token = response.data['token'];
    final user = User.fromJson(response.data['user']);

    await _apiClient.saveToken(token);
    await _saveUser(user);

    return {'token': token, 'user': user};
  }

  // Login with email/password
  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    final response = await _apiClient.post(
      ApiConstants.login,
      data: {
        'email': email,
        'password': password,
      },
    );

    final token = response.data['token'];
    final user = User.fromJson(response.data['user']);

    await _apiClient.saveToken(token);
    await _saveUser(user);

    return {'token': token, 'user': user};
  }

  // Social Login (Google/Apple)
  Future<Map<String, dynamic>> socialLogin({
    required String provider,
    required String providerId,
    required String name,
    required String city,
    String? email,
  }) async {
    final response = await _apiClient.post(
      ApiConstants.socialLogin,
      data: {
        'provider': provider,
        'provider_id': providerId,
        'name': name,
        'email': email,
        'city': city,
      },
    );

    final token = response.data['token'];
    final user = User.fromJson(response.data['user']);

    await _apiClient.saveToken(token);
    await _saveUser(user);

    return {'token': token, 'user': user};
  }

  // Get current user
  Future<User> getCurrentUser() async {
    final response = await _apiClient.get(ApiConstants.user);
    final user = User.fromJson(response.data);
    await _saveUser(user);
    return user;
  }

  // Update profile
  Future<User> updateProfile({
    String? name,
    String? email,
    String? city,
    String? photoUrl,
  }) async {
    final data = <String, dynamic>{};
    if (name != null) data['name'] = name;
    if (email != null) data['email'] = email;
    if (city != null) data['city'] = city;
    if (photoUrl != null) data['photo_url'] = photoUrl;

    final response = await _apiClient.put(ApiConstants.user, data: data);
    final user = User.fromJson(response.data);
    await _saveUser(user);
    return user;
  }

  // Logout
  Future<void> logout() async {
    try {
      await _apiClient.post(ApiConstants.logout);
    } catch (e) {
      // Ignore logout errors
    }
    await _apiClient.clearToken();
    await _storage.delete(key: ApiConstants.userKey);
  }

  // Check if logged in
  Future<bool> isLoggedIn() async {
    final token = await _apiClient.getToken();
    return token != null;
  }

  // Get saved user from local storage
  Future<User?> getSavedUser() async {
    final userData = await _storage.read(key: ApiConstants.userKey);
    if (userData == null) return null;
    return User.fromJson(jsonDecode(userData));
  }

  // Save user to local storage
  Future<void> _saveUser(User user) async {
    await _storage.write(
      key: ApiConstants.userKey,
      value: jsonEncode(user.toJson()),
    );
  }
}
