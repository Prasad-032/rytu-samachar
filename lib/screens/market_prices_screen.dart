import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/market_service.dart';
import '../services/language_provider.dart';
import '../services/notification_service.dart';

class MarketPricesScreen extends StatefulWidget {
  const MarketPricesScreen({super.key});

  @override
  State<MarketPricesScreen> createState() => _MarketPricesScreenState();
}

class _MarketPricesScreenState extends State<MarketPricesScreen> {
  final MarketService _service = MarketService();
  List<MarketPrice> _prices = [];
  bool _isLoading = true;
  String _selectedState = 'Telangana';

  final List<String> _states = [
    'Telangana',
    'Andhra Pradesh',
    'Karnataka',
    'Maharashtra',
    'Punjab',
  ];

  @override
  void initState() {
    super.initState();
    _loadPrices();
  }

  Future<void> _loadPrices() async {
    setState(() => _isLoading = true);
    final prices = await _service.getMarketPrices(_selectedState);
    if (mounted) {
      setState(() { _prices = prices; _isLoading = false; });
      NotificationService().showNotification(
        'Market Prices Updated 📈',
        'Latest $_selectedState market prices are now available!',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final lang = context.watch<LanguageProvider>();
    return Scaffold(
      appBar: AppBar(
        title: Text(lang.t('📈 Market Prices', '📈 మార్కెట్ ధరలు')),
        actions: [
          IconButton(icon: const Icon(Icons.refresh), onPressed: _loadPrices),
        ],
      ),
      body: Column(
        children: [
          Container(
            color: const Color(0xFF2E7D32),
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
            child: DropdownButtonFormField<String>(
              value: _selectedState,
              decoration: InputDecoration(
                labelText: lang.t('Select State', 'రాష్ట్రం ఎంచుకోండి'),
                labelStyle: const TextStyle(color: Colors.white70),
                filled: true,
                fillColor: Colors.white10,
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Colors.white38)),
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Colors.white38)),
              ),
              dropdownColor: const Color(0xFF2E7D32),
              style: const TextStyle(color: Colors.white),
              items: _states
                  .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                  .toList(),
              onChanged: (v) {
                if (v != null) {
                  setState(() => _selectedState = v);
                  _loadPrices();
                }
              },
            ),
          ),
          Expanded(
            child: _isLoading
                ? const Center(
                    child: CircularProgressIndicator(color: Color(0xFF2E7D32)))
                : RefreshIndicator(
                    onRefresh: _loadPrices,
                    color: const Color(0xFF2E7D32),
                    child: ListView.builder(
                      padding: const EdgeInsets.all(12),
                      itemCount: _prices.length,
                      itemBuilder: (ctx, i) =>
                          _PriceCard(price: _prices[i], lang: lang),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}

class _PriceCard extends StatelessWidget {
  final MarketPrice price;
  final LanguageProvider lang;

  const _PriceCard({required this.price, required this.lang});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: const Color(0xFF2E7D32).withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Center(child: Text('🌾', style: TextStyle(fontSize: 24))),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${price.cropName} / ${price.cropNameTelugu}',
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      const Icon(Icons.location_on, size: 12, color: Colors.grey),
                      const SizedBox(width: 2),
                      Text(price.market,
                          style: const TextStyle(color: Colors.grey, fontSize: 12)),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    lang.t(
                      'Min: ₹${price.minPrice.round()} | Max: ₹${price.maxPrice.round()}',
                      'కనిష్ట: ₹${price.minPrice.round()} | గరిష్ట: ₹${price.maxPrice.round()}',
                    ),
                    style: const TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '₹${price.currentPrice.round()}',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2E7D32),
                  ),
                ),
                Row(
                  children: [
                    Icon(
                      price.isTrendingUp
                          ? Icons.arrow_upward
                          : Icons.arrow_downward,
                      color: price.isTrendingUp ? Colors.green : Colors.red,
                      size: 14,
                    ),
                    Text(
                      price.isTrendingUp ? '↑' : '↓',
                      style: TextStyle(
                        color: price.isTrendingUp ? Colors.green : Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
