import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/language_provider.dart';
import 'news_screen.dart';
import 'weather_screen.dart';
import 'market_prices_screen.dart';
import 'chat_screen.dart';
import 'profile_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    NewsScreen(),
    WeatherScreen(),
    MarketPricesScreen(),
    ChatScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final lang = context.watch<LanguageProvider>();
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (i) => setState(() => _currentIndex = i),
        backgroundColor: Colors.white,
        indicatorColor: const Color(0xFF2E7D32).withOpacity(0.15),
        destinations: [
          NavigationDestination(
            icon: const Icon(Icons.newspaper_outlined),
            selectedIcon:
                const Icon(Icons.newspaper, color: Color(0xFF2E7D32)),
            label: lang.t('News', 'వార్తలు'),
          ),
          NavigationDestination(
            icon: const Icon(Icons.cloud_outlined),
            selectedIcon:
                const Icon(Icons.cloud, color: Color(0xFF2E7D32)),
            label: lang.t('Weather', 'వాతావరణం'),
          ),
          NavigationDestination(
            icon: const Icon(Icons.trending_up_outlined),
            selectedIcon:
                const Icon(Icons.trending_up, color: Color(0xFF2E7D32)),
            label: lang.t('Market', 'మార్కెట్'),
          ),
          NavigationDestination(
            icon: const Icon(Icons.chat_bubble_outline),
            selectedIcon:
                const Icon(Icons.chat_bubble, color: Color(0xFF2E7D32)),
            label: lang.t('Chat', 'చాట్'),
          ),
          NavigationDestination(
            icon: const Icon(Icons.person_outline),
            selectedIcon:
                const Icon(Icons.person, color: Color(0xFF2E7D32)),
            label: lang.t('Profile', 'ప్రొఫైల్'),
          ),
        ],
      ),
    );
  }
}
