import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/weather_service.dart';
import '../services/language_provider.dart';

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  final WeatherService _service = WeatherService();
  final TextEditingController _cityController =
      TextEditingController(text: 'Hyderabad');
  WeatherData? _weather;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadWeather();
  }

  Future<void> _loadWeather() async {
    setState(() => _isLoading = true);
    final data = await _service.getWeather(_cityController.text.trim());
    if (mounted) setState(() { _weather = data; _isLoading = false; });
  }

  @override
  Widget build(BuildContext context) {
    final lang = context.watch<LanguageProvider>();
    return Scaffold(
      appBar: AppBar(
        title: Text(lang.t('🌦️ Weather', '🌦️ వాతావరణం')),
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            color: const Color(0xFF2E7D32),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _cityController,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: lang.t('Search city...', 'నగరం వెతకండి...'),
                      hintStyle: const TextStyle(color: Colors.white60),
                      prefixIcon: const Icon(Icons.location_city, color: Colors.white70),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Colors.white38),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Colors.white38),
                      ),
                    ),
                    onSubmitted: (_) => _loadWeather(),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  onPressed: _loadWeather,
                  icon: const Icon(Icons.search, color: Colors.white),
                  style: IconButton.styleFrom(
                    backgroundColor: Colors.white24,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator(color: Color(0xFF2E7D32)))
                : _weather == null
                    ? Center(child: Text(lang.t('City not found', 'నగరం కనుగొనబడలేదు')))
                    : _WeatherView(weather: _weather!, service: _service, lang: lang),
          ),
        ],
      ),
    );
  }
}

class _WeatherView extends StatelessWidget {
  final WeatherData weather;
  final WeatherService service;
  final LanguageProvider lang;

  const _WeatherView({required this.weather, required this.service, required this.lang});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          const SizedBox(height: 20),
          Text(
            service.getWeatherIcon(weather.condition),
            style: const TextStyle(fontSize: 80),
          ),
          const SizedBox(height: 12),
          Text(
            weather.city,
            style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(
            weather.condition.toUpperCase(),
            style: const TextStyle(color: Colors.grey, letterSpacing: 1.5),
          ),
          const SizedBox(height: 20),
          Text(
            '${weather.temperature.round()}°C',
            style: const TextStyle(
              fontSize: 72,
              fontWeight: FontWeight.w200,
              color: Color(0xFF2E7D32),
            ),
          ),
          const SizedBox(height: 32),
          Row(
            children: [
              _StatCard(
                icon: '💧',
                label: lang.t('Humidity', 'తేమ'),
                value: '${weather.humidity}%',
              ),
              const SizedBox(width: 12),
              _StatCard(
                icon: '💨',
                label: lang.t('Wind', 'గాలి'),
                value: '${weather.windSpeed} m/s',
              ),
              const SizedBox(width: 12),
              _StatCard(
                icon: '🌡️',
                label: lang.t('Feels Like', 'అనుభూతి'),
                value: '${weather.feelsLike.round()}°C',
              ),
            ],
          ),
          const SizedBox(height: 20),
          Card(
            color: const Color(0xFF2E7D32).withOpacity(0.08),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  const Text('🌾', style: TextStyle(fontSize: 24)),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      lang.t(
                        'Good conditions for farming. Check market prices for today\'s best crops.',
                        'వ్యవసాయానికి అనుకూలమైన పరిస్థితులు. నేటి ఉత్తమ పంటల కోసం మార్కెట్ ధరలు చూడండి.',
                      ),
                      style: const TextStyle(fontSize: 13, height: 1.4),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String icon;
  final String label;
  final String value;

  const _StatCard({required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 2,
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            children: [
              Text(icon, style: const TextStyle(fontSize: 24)),
              const SizedBox(height: 6),
              Text(value,
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold)),
              Text(label,
                  style: const TextStyle(color: Colors.grey, fontSize: 12)),
            ],
          ),
        ),
      ),
    );
  }
}
