import 'dart:convert';
import 'package:http/http.dart' as http;

class MarketPrice {
  final String cropName;
  final String cropNameTelugu;
  final String market;
  final String state;
  final double currentPrice;
  final double minPrice;
  final double maxPrice;
  final bool isTrendingUp;

  MarketPrice({
    required this.cropName,
    required this.cropNameTelugu,
    required this.market,
    required this.state,
    required this.currentPrice,
    required this.minPrice,
    required this.maxPrice,
    required this.isTrendingUp,
  });
}

class MarketService {
  // Replace with your Data.gov.in API key
  static const String _apiKey = 'YOUR_DATA_GOV_IN_API_KEY';
  static const String _baseUrl =
      'https://api.data.gov.in/resource/9ef84268-d588-465a-a308-a864a43d0070';

  Future<List<MarketPrice>> getMarketPrices(String state) async {
    try {
      final url =
          '$_baseUrl?api-key=$_apiKey&format=json&filters[state.keyword]=$state&limit=20';
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final records = data['records'] as List;
        return records
            .map((r) => MarketPrice(
                  cropName: r['commodity'] ?? '',
                  cropNameTelugu: _getTeluguName(r['commodity'] ?? ''),
                  market: r['market'] ?? '',
                  state: r['state'] ?? '',
                  currentPrice: double.tryParse(r['modal_price'] ?? '0') ?? 0,
                  minPrice: double.tryParse(r['min_price'] ?? '0') ?? 0,
                  maxPrice: double.tryParse(r['max_price'] ?? '0') ?? 0,
                  isTrendingUp: true,
                ))
            .toList();
      }
    } catch (e) {
      // Return mock data
    }
    return _getMockPrices(state);
  }

  String _getTeluguName(String english) {
    const map = {
      'Rice': 'వరి',
      'Wheat': 'గోధుమ',
      'Cotton': 'పత్తి',
      'Groundnut': 'వేరుశనగ',
      'Maize': 'మొక్కజొన్న',
      'Turmeric': 'పసుపు',
      'Chilli': 'మిరప',
      'Paddy': 'వడ్లు',
      'Soybean': 'సోయాబీన్',
      'Sunflower': 'పొద్దుతిరుగుడు',
    };
    return map[english] ?? english;
  }

  List<MarketPrice> _getMockPrices(String state) {
    final data = [
      ['Paddy', 'వడ్లు', 'Warangal', 2250.0, 2100.0, 2350.0, true],
      ['Cotton', 'పత్తి', 'Karimnagar', 7800.0, 7500.0, 8100.0, true],
      ['Maize', 'మొక్కజొన్న', 'Nizamabad', 1850.0, 1700.0, 1950.0, false],
      ['Groundnut', 'వేరుశనగ', 'Kurnool', 5200.0, 5000.0, 5400.0, true],
      ['Chilli', 'మిరప', 'Guntur', 12500.0, 12000.0, 13000.0, true],
      ['Turmeric', 'పసుపు', 'Nizamabad', 8500.0, 8000.0, 9000.0, false],
      ['Soybean', 'సోయాబీన్', 'Adilabad', 3900.0, 3700.0, 4100.0, true],
      ['Sunflower', 'పొద్దుతిరుగుడు', 'Nalgonda', 4800.0, 4600.0, 5000.0, false],
    ];
    return data
        .map((d) => MarketPrice(
              cropName: d[0] as String,
              cropNameTelugu: d[1] as String,
              market: d[2] as String,
              state: state,
              currentPrice: d[3] as double,
              minPrice: d[4] as double,
              maxPrice: d[5] as double,
              isTrendingUp: d[6] as bool,
            ))
        .toList();
  }
}
