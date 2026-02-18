import 'package:freezed_annotation/freezed_annotation.dart';

part 'user.freezed.dart';
part 'user.g.dart';

/// User Entity (Domain Layer)
@freezed
class User with _$User {
  const factory User({
    required String id,
    required String email,
    String? displayName,
    String? photoUrl,
    @Default(false) bool isPremium,
    DateTime? premiumExpiresAt,
    @Default('TRY') String currency,
    @Default('km') String distanceUnit,
    @Default(true) bool darkMode,
    required DateTime createdAt,
    DateTime? updatedAt,
  }) = _User;

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
}
