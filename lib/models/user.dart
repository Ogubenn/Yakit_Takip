import 'package:hive/hive.dart';

part 'user.g.dart';

@HiveType(typeId: 2)
class User extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  String name;

  @HiveField(2)
  String city;

  @HiveField(3)
  String? email;

  @HiveField(4)
  String? photoUrl;

  @HiveField(5)
  String? authProvider; // 'google', 'apple', 'manual'

  @HiveField(6)
  DateTime createdAt;

  @HiveField(7)
  DateTime? lastLoginAt;

  User({
    required this.id,
    required this.name,
    required this.city,
    this.email,
    this.photoUrl,
    this.authProvider = 'manual',
    required this.createdAt,
    this.lastLoginAt,
  });

  // JSON serialization for future API integration
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as String,
      name: json['name'] as String,
      city: json['city'] as String,
      email: json['email'] as String?,
      photoUrl: json['photoUrl'] as String?,
      authProvider: json['authProvider'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      lastLoginAt: json['lastLoginAt'] != null
          ? DateTime.parse(json['lastLoginAt'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'city': city,
      'email': email,
      'photoUrl': photoUrl,
      'authProvider': authProvider,
      'createdAt': createdAt.toIso8601String(),
      'lastLoginAt': lastLoginAt?.toIso8601String(),
    };
  }

  User copyWith({
    String? name,
    String? city,
    String? email,
    String? photoUrl,
    String? authProvider,
    DateTime? lastLoginAt,
  }) {
    return User(
      id: id,
      name: name ?? this.name,
      city: city ?? this.city,
      email: email ?? this.email,
      photoUrl: photoUrl ?? this.photoUrl,
      authProvider: authProvider ?? this.authProvider,
      createdAt: createdAt,
      lastLoginAt: lastLoginAt ?? this.lastLoginAt,
    );
  }
}
