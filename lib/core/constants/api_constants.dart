class ApiConstants {
  // Base URL - Kebirhost sunucunuz için güncelleyin
  static const String baseUrl = 'https://your-domain.com/api';
  
  // Endpoints
  static const String register = '/register';
  static const String login = '/login';
  static const String socialLogin = '/social-login';
  static const String logout = '/logout';
  static const String user = '/user';
  
  static const String vehicles = '/vehicles';
  static const String fuelRecords = '/fuel-records';
  static const String fuelPrices = '/fuel-prices';
  
  static const String syncUpload = '/sync/upload';
  static const String syncDownload = '/sync/download';
  static const String syncChanges = '/sync/changes';
  
  // Storage Keys
  static const String tokenKey = 'auth_token';
  static const String userKey = 'user_data';
  static const String lastSyncKey = 'last_sync';
  
  // Timeouts
  static const Duration connectTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);
}
