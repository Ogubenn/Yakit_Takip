/// App-wide constants
class AppConstants {
  // App Info
  static const String appName = 'Yakıt Takip';
  static const String appVersion = '1.0.0';
  
  // API
  static const String baseUrl = 'https://your-cloud-function-url.com';
  static const Duration apiTimeout = Duration(seconds: 30);
  
  // Pagination
  static const int defaultPageSize = 20;
  static const int maxEntriesPerPage = 50;
  
  // Sync
  static const int maxSyncRetries = 3;
  static const Duration syncInterval = Duration(minutes: 5);
  
  // Cache
  static const Duration cacheValidDuration = Duration(hours: 24);
  
  // Animation
  static const Duration defaultAnimationDuration = Duration(milliseconds: 300);
  
  // Ads
  static const int entriesBeforeAd = 5;
}

/// Firebase Collection Names
class FirebaseCollections {
  static const String users = 'users';
  static const String vehicles = 'vehicles';
  static const String fuelEntries = 'fuel_entries';
  static const String subscriptions = 'subscriptions';
  static const String fuelPrices = 'fuel_prices';
}

/// Hive Box Names
class HiveBoxes {
  static const String user = 'user';
  static const String vehicles = 'vehicles';
  static const String fuelEntries = 'fuel_entries';
  static const String syncQueue = 'sync_queue';
  static const String settings = 'settings';
}
