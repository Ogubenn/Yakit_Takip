import 'package:hive/hive.dart';

/// User Model (Data Layer - Local Storage)
@HiveType(typeId: 2)
class UserModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String email;

  @HiveField(2)
  final String? displayName;

  @HiveField(3)
  final String? photoUrl;

  @HiveField(4)
  final bool isPremium;

  @HiveField(5)
  final DateTime? premiumExpiresAt;

  @HiveField(6)
  final String currency;

  @HiveField(7)
  final String distanceUnit;

  @HiveField(8)
  final bool darkMode;

  @HiveField(9)
  final DateTime createdAt;

  @HiveField(10)
  final DateTime? updatedAt;

  UserModel({
    required this.id,
    required this.email,
    this.displayName,
    this.photoUrl,
    required this.isPremium,
    this.premiumExpiresAt,
    required this.currency,
    required this.distanceUnit,
    required this.darkMode,
    required this.createdAt,
    this.updatedAt,
  });

  /// Convert to Domain Entity
  Map<String, dynamic> toEntity() {
    return {
      'id': id,
      'email': email,
      'displayName': displayName,
      'photoUrl': photoUrl,
      'isPremium': isPremium,
      'premiumExpiresAt': premiumExpiresAt?.toIso8601String(),
      'currency': currency,
      'distanceUnit': distanceUnit,
      'darkMode': darkMode,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  /// Convert from Domain Entity
  factory UserModel.fromEntity(Map<String, dynamic> entity) {
    return UserModel(
      id: entity['id'] as String,
      email: entity['email'] as String,
      displayName: entity['displayName'] as String?,
      photoUrl: entity['photoUrl'] as String?,
      isPremium: entity['isPremium'] as bool? ?? false,
      premiumExpiresAt: entity['premiumExpiresAt'] != null
          ? DateTime.parse(entity['premiumExpiresAt'] as String)
          : null,
      currency: entity['currency'] as String? ?? 'TRY',
      distanceUnit: entity['distanceUnit'] as String? ?? 'km',
      darkMode: entity['darkMode'] as bool? ?? true,
      createdAt: DateTime.parse(entity['createdAt'] as String),
      updatedAt: entity['updatedAt'] != null
          ? DateTime.parse(entity['updatedAt'] as String)
          : null,
    );
  }

  /// Convert to Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'email': email,
      'displayName': displayName,
      'photoUrl': photoUrl,
      'isPremium': isPremium,
      'premiumExpiresAt': premiumExpiresAt?.toIso8601String(),
      'currency': currency,
      'distanceUnit': distanceUnit,
      'darkMode': darkMode,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  /// Convert from Firestore
  factory UserModel.fromFirestore(String id, Map<String, dynamic> data) {
    return UserModel(
      id: id,
      email: data['email'] as String,
      displayName: data['displayName'] as String?,
      photoUrl: data['photoUrl'] as String?,
      isPremium: data['isPremium'] as bool? ?? false,
      premiumExpiresAt: data['premiumExpiresAt'] != null
          ? DateTime.parse(data['premiumExpiresAt'] as String)
          : null,
      currency: data['currency'] as String? ?? 'TRY',
      distanceUnit: data['distanceUnit'] as String? ?? 'km',
      darkMode: data['darkMode'] as bool? ?? true,
      createdAt: DateTime.parse(data['createdAt'] as String),
      updatedAt: data['updatedAt'] != null
          ? DateTime.parse(data['updatedAt'] as String)
          : null,
    );
  }
}
