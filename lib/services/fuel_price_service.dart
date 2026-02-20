import 'package:geolocator/geolocator.dart';

class FuelPriceService {
  
  // Mock data - Gerçek API entegrasyonunda kaldırılacak
  static final Map<String, Map<String, double>> _mockPrices = {
    'İstanbul': {
      'benzin95': 42.50,
      'benzin97': 44.20,
      'dizel': 43.10,
      'lpg': 24.80,
      'motorin': 43.10,
    },
    'Ankara': {
      'benzin95': 42.30,
      'benzin97': 44.00,
      'dizel': 42.90,
      'lpg': 24.60,
      'motorin': 42.90,
    },
    'İzmir': {
      'benzin95': 42.45,
      'benzin97': 44.15,
      'dizel': 43.05,
      'lpg': 24.75,
      'motorin': 43.05,
    },
  };

  // Konum izni kontrolü ve alma
  static Future<bool> checkLocationPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();
    
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return false;
      }
    }
    
    if (permission == LocationPermission.deniedForever) {
      return false;
    }
    
    return true;
  }

  // Mevcut konumu al
  static Future<Position?> getCurrentLocation() async {
    try {
      final hasPermission = await checkLocationPermission();
      if (!hasPermission) return null;

      return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
    } catch (e) {
      print('Konum alınamadı: $e');
      return null;
    }
  }

  // Konuma göre şehir belirle (basitleştirilmiş)
  static Future<String> getCityFromLocation(Position position) async {
    // Gerçek uygulamada Geocoding API kullanılacak
    // Şimdilik mock data
    if (position.latitude > 41.0 && position.latitude < 41.2) {
      return 'İstanbul';
    } else if (position.latitude > 39.8 && position.latitude < 40.0) {
      return 'Ankara';
    } else if (position.latitude > 38.3 && position.latitude < 38.5) {
      return 'İzmir';
    }
    return 'İstanbul'; // Default
  }

  // EPDK'dan fiyat çek
  static Future<Map<String, double>?> fetchFuelPrices(String city) async {
    try {
      // Gerçek API çağrısı (şimdilik mock)
      // final response = await http.get(Uri.parse('$_epdkApiUrl?city=$city'));
      // if (response.statusCode == 200) {
      //   final data = json.decode(response.body);
      //   return _parseFuelPrices(data);
      // }

      // Mock data döndür
      await Future.delayed(const Duration(milliseconds: 500)); // API simülasyonu
      return _mockPrices[city] ?? _mockPrices['İstanbul'];
    } catch (e) {
      print('Fiyat bilgisi alınamadı: $e');
      return null;
    }
  }

  // Konum + EPDK verisiyle otomatik fiyat getir
  static Future<Map<String, dynamic>> getAutomaticFuelPrice(String fuelType) async {
    try {
      // 1. Konum al
      final position = await getCurrentLocation();
      if (position == null) {
        return {
          'success': false,
          'error': 'Konum izni gerekli',
        };
      }

      // 2. Şehir belirle
      final city = await getCityFromLocation(position);

      // 3. EPDK fiyatlarını çek
      final prices = await fetchFuelPrices(city);
      if (prices == null) {
        return {
          'success': false,
          'error': 'Fiyat bilgisi alınamadı',
        };
      }

      // 4. İlgili yakıt türü fiyatını döndür
      final price = prices[fuelType];
      if (price == null) {
        return {
          'success': false,
          'error': 'Bu yakıt türü için fiyat bulunamadı',
        };
      }

      return {
        'success': true,
        'city': city,
        'price': price,
        'latitude': position.latitude,
        'longitude': position.longitude,
        'timestamp': DateTime.now().toIso8601String(),
      };
    } catch (e) {
      return {
        'success': false,
        'error': e.toString(),
      };
    }
  }

  // Tüm yakıt fiyatlarını getir (şehre göre)
  static Future<Map<String, double>?> getAllFuelPricesForCity(String city) async {
    return await fetchFuelPrices(city);
  }
}
