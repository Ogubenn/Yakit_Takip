class AppConstants {
  // App Info
  static const String appName = 'Yakıt Takip';
  static const String appVersion = '1.0.0';
  
  // Storage Keys
  static const String vehiclesBox = 'vehicles';
  static const String fuelRecordsBox = 'fuel_records';
  static const String settingsBox = 'settings';
  
  // Defaults
  static const String defaultCurrency = '₺';
  static const String defaultCity = 'İstanbul';
  static const double defaultFuelPrice = 0.0;
  
  // Limits
  static const int maxVehiclesFree = 1;
  static const int maxVehiclesPremium = 99;
  static const int maxRecordsToShow = 50;
  
  // Formatting
  static const String dateFormat = 'dd.MM.yyyy';
  static const String dateTimeFormat = 'dd.MM.yyyy HH:mm';
  static const String currencyFormat = '#,##0.00';
  
  // Premium Features
  static const String premiumKey = 'is_premium';
  static const List<String> premiumFeatures = [
    'Reklamsız Deneyim',
    'Sınırsız Araç Ekleme',
    'Gelişmiş Raporlar',
    'PDF/CSV Export',
    'Cloud Yedekleme',
    'Öncelikli Destek',
  ];
  
  // Fuel Price API (Placeholder - gerçek API entegre edilecek)
  static const String fuelPriceApiUrl = 'https://api.example.com/fuel-prices';
  
  // Notifications
  static const int priceAlertThreshold = 1; // %1 fiyat değişimi
  static const int fuelReminderDays = 7; // 7 gün hatırlatma
}
