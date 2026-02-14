import 'dart:convert';
import 'package:http/http.dart' as http;

class CurrencyUtility {
  static const String _apiBaseUrl =
      'https://api.exchangerate-api.com/v4/latest/USD';

  // Default rate if API fails
  static double _ilsToUsdRate = 3.7;
  static DateTime? _lastUpdate;

  /// Fetches live exchange rates.
  static Future<void> fetchRates() async {
    try {
      final response = await http.get(Uri.parse(_apiBaseUrl));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        _ilsToUsdRate = (data['rates']['ILS'] as num).toDouble();
        _lastUpdate = DateTime.now();
      }
    } catch (e) {
      print('Error fetching rates: $e');
    }
  }

  static double convertUsdToIls(double usd) => usd * _ilsToUsdRate;
  static double convertIlsToUsd(double ils) => ils / _ilsToUsdRate;

  static double get ilsRate => _ilsToUsdRate;
  static DateTime? get lastUpdate => _lastUpdate;
}
