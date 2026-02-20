import 'package:intl/intl.dart';

class Formatters {
  // Currency Formatter
  static String currency(double amount, {String symbol = '₺'}) {
    final formatter = NumberFormat('#,##0.00', 'tr_TR');
    return '${formatter.format(amount)} $symbol';
  }

  // Compact Currency Formatter (1.2K, 2.5M)
  static String currencyCompact(double amount, {String symbol = '₺'}) {
    if (amount >= 1000000) {
      return '${(amount / 1000000).toStringAsFixed(1)}M $symbol';
    } else if (amount >= 1000) {
      return '${(amount / 1000).toStringAsFixed(1)}K $symbol';
    } else {
      return '${amount.toStringAsFixed(0)} $symbol';
    }
  }

  // Number Formatter
  static String number(num value, {int decimals = 2}) {
    final formatter = NumberFormat('#,##0.${'0' * decimals}', 'tr_TR');
    return formatter.format(value);
  }

  // Date Formatter
  static String date(DateTime dateTime, {String format = 'dd.MM.yyyy'}) {
    final formatter = DateFormat(format, 'tr_TR');
    return formatter.format(dateTime);
  }

  // DateTime Formatter
  static String dateTime(DateTime dateTime, {String format = 'dd.MM.yyyy HH:mm'}) {
    final formatter = DateFormat(format, 'tr_TR');
    return formatter.format(dateTime);
  }

  // Relative Time (Örn: "2 gün önce")
  static String relativeTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays > 365) {
      final years = (difference.inDays / 365).floor();
      return '$years yıl önce';
    } else if (difference.inDays > 30) {
      final months = (difference.inDays / 30).floor();
      return '$months ay önce';
    } else if (difference.inDays > 0) {
      return '${difference.inDays} gün önce';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} saat önce';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} dakika önce';
    } else {
      return 'Az önce';
    }
  }

  // Litre Formatter
  static String litre(double amount) {
    return '${number(amount)} L';
  }

  // Kilometer Formatter
  static String kilometer(double km) {
    return '${NumberFormat('#,##0', 'tr_TR').format(km)} km';
  }

  // Fuel Consumption (L/100km)
  static String consumption(double value) {
    return '${number(value, decimals: 1)} L/100km';
  }

  // Percentage
  static String percentage(double value, {bool showSign = true}) {
    final sign = showSign && value > 0 ? '+' : '';
    return '$sign${number(value, decimals: 1)}%';
  }
}
