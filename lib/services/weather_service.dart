import 'dart:convert';
import 'package:http/http.dart' as http;

class WeatherData {
  final String city;
  final double temperature;
  final double feelsLike;
  final int humidity;
  final double windSpeed;
  final String condition;
  final String icon;

  WeatherData({
    required this.city,
    required this.temperature,
    required this.feelsLike,
    required this.humidity,
    required this.windSpeed,
    required this.condition,
    required this.icon,
  });
}

class WeatherService {
  // Replace with your OpenWeather API key
  static const String _apiKey = 'YOUR_OPENWEATHER_API_KEY';
  static const String _baseUrl =
      'https://api.openweathermap.org/data/2.5/weather';

  Future<WeatherData?> getWeather(String city) async {
    try {
      final url =
          '$_baseUrl?q=$city&appid=$_apiKey&units=metric';
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return WeatherData(
          city: data['name'],
          temperature: data['main']['temp'].toDouble(),
          feelsLike: data['main']['feels_like'].toDouble(),
          humidity: data['main']['humidity'],
          windSpeed: data['wind']['speed'].toDouble(),
          condition: data['weather'][0]['description'],
          icon: data['weather'][0]['icon'],
        );
      }
    } catch (e) {
      // Return mock data for demo
    }
    // Mock data when API key not set
    return WeatherData(
      city: city,
      temperature: 32.5,
      feelsLike: 35.0,
      humidity: 65,
      windSpeed: 12.5,
      condition: 'Partly Cloudy',
      icon: '02d',
    );
  }

  String getWeatherIcon(String condition) {
    final c = condition.toLowerCase();
    if (c.contains('rain')) return '🌧️';
    if (c.contains('cloud')) return '☁️';
    if (c.contains('clear') || c.contains('sun')) return '☀️';
    if (c.contains('storm') || c.contains('thunder')) return '⛈️';
    if (c.contains('snow')) return '❄️';
    if (c.contains('mist') || c.contains('fog')) return '🌫️';
    return '🌤️';
  }
}
