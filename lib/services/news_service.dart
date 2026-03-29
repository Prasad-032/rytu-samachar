import 'dart:convert';
import 'package:http/http.dart' as http;

class NewsArticle {
  final String title;
  final String description;
  final String? imageUrl;
  final String source;
  final String url;
  final DateTime publishedAt;

  NewsArticle({
    required this.title,
    required this.description,
    this.imageUrl,
    required this.source,
    required this.url,
    required this.publishedAt,
  });
}

class NewsService {
  // Replace with your NewsAPI key
  static const String _apiKey = 'YOUR_NEWSAPI_KEY';
  static const String _baseUrl = 'https://newsapi.org/v2/everything';

  Future<List<NewsArticle>> getAgriNews() async {
    try {
      final url =
          '$_baseUrl?q=agriculture+farmers+india&language=en&sortBy=publishedAt&apiKey=$_apiKey';
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final articles = data['articles'] as List;
        return articles
            .where((a) => a['title'] != null && a['title'] != '[Removed]')
            .take(20)
            .map((a) => NewsArticle(
                  title: a['title'] ?? '',
                  description: a['description'] ?? 'Read more...',
                  imageUrl: a['urlToImage'],
                  source: a['source']['name'] ?? 'Unknown',
                  url: a['url'] ?? '',
                  publishedAt: DateTime.tryParse(a['publishedAt'] ?? '') ??
                      DateTime.now(),
                ))
            .toList();
      }
    } catch (e) {
      // Return mock data
    }
    return _getMockNews();
  }

  List<NewsArticle> _getMockNews() {
    return [
      NewsArticle(
        title: 'Kharif Crop Season: Farmers Prepare for Sowing',
        description:
            'Farmers across Telangana and Andhra Pradesh are gearing up for the kharif season with increased support from state governments.',
        imageUrl: null,
        source: 'The Hindu',
        url: '',
        publishedAt: DateTime.now().subtract(const Duration(hours: 2)),
      ),
      NewsArticle(
        title: 'PM-KISAN: Next Installment Release Date Announced',
        description:
            'The government has announced the release of the next PM-KISAN installment. Eligible farmers will receive ₹2,000 directly to their bank accounts.',
        imageUrl: null,
        source: 'Economic Times',
        url: '',
        publishedAt: DateTime.now().subtract(const Duration(hours: 5)),
      ),
      NewsArticle(
        title: 'Monsoon Forecast 2024: Good Rains Expected in South India',
        description:
            'IMD predicts above-normal rainfall for Telangana and Andhra Pradesh this monsoon season, which is expected to benefit paddy and cotton farmers.',
        imageUrl: null,
        source: 'Times of India',
        url: '',
        publishedAt: DateTime.now().subtract(const Duration(hours: 8)),
      ),
      NewsArticle(
        title: 'Rythu Bandhu: New Guidelines for Farmers Released',
        description:
            'Telangana government releases updated guidelines for the Rythu Bandhu scheme. Farmers are advised to check eligibility and update their records.',
        imageUrl: null,
        source: 'Deccan Chronicle',
        url: '',
        publishedAt: DateTime.now().subtract(const Duration(hours: 12)),
      ),
      NewsArticle(
        title: 'Organic Farming Initiative: Subsidies for Telangana Farmers',
        description:
            'The state agriculture department has announced a 50% subsidy on organic inputs for farmers who wish to transition to organic farming methods.',
        imageUrl: null,
        source: 'Telangana Today',
        url: '',
        publishedAt: DateTime.now().subtract(const Duration(hours: 16)),
      ),
      NewsArticle(
        title: 'Cotton Prices Rise: Farmers Benefit from Market Surge',
        description:
            'Cotton prices have seen a significant increase at major mandis across Telangana and AP, bringing relief to thousands of farmers who cultivate the crop.',
        imageUrl: null,
        source: 'Business Line',
        url: '',
        publishedAt: DateTime.now().subtract(const Duration(hours: 20)),
      ),
    ];
  }
}
