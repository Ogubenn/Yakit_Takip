import 'package:hive/hive.dart';
import '../models/user_model.dart';

/// Local Data Source for User (Hive)
class UserLocalDataSource {
  static const String boxName = 'user';

  Future<Box<UserModel>> get _box async =>
      await Hive.openBox<UserModel>(boxName);

  /// Save user
  Future<UserModel> saveUser(UserModel user) async {
    final box = await _box;
    await box.put('current_user', user);
    return user;
  }

  /// Get current user
  Future<UserModel?> getCurrentUser() async {
    final box = await _box;
    return box.get('current_user');
  }

  /// Update user
  Future<UserModel> updateUser(UserModel user) async {
    final box = await _box;
    await box.put('current_user', user);
    return user;
  }

  /// Delete user
  Future<void> deleteUser() async {
    final box = await _box;
    await box.delete('current_user');
  }

  /// Clear all user data
  Future<void> clearAll() async {
    final box = await _box;
    await box.clear();
  }
}
