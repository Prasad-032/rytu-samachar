import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:intl/intl.dart';
import '../services/news_service.dart';
import '../services/language_provider.dart';

class NewsScreen extends StatefulWidget {
  const NewsScreen({super.key});

  @override
  State<NewsScreen> createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> {
  final NewsService _newsService = NewsService();
  List<NewsArticle> _articles = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadNews();
  }

  Future<void> _loadNews() async {
    setState(() => _isLoading = true);
    final articles = await _newsService.getAgriNews();
    if (mounted) {
      setState(() {
        _articles = articles;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final lang = context.watch<LanguageProvider>();
    return Scaffold(
      appBar: AppBar(
        title: Text(lang.t('🌾 Farm News', '🌾 వ్యవసాయ వార్తలు')),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadNews,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: Color(0xFF2E7D32)))
          : RefreshIndicator(
              onRefresh: _loadNews,
              color: const Color(0xFF2E7D32),
              child: ListView.builder(
                padding: const EdgeInsets.all(12),
                itemCount: _articles.length,
                itemBuilder: (context, i) => _NewsCard(article: _articles[i]),
              ),
            ),
    );
  }
}

class _NewsCard extends StatelessWidget {
  final NewsArticle article;
  const _NewsCard({required this.article});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 2,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {
          if (article.url.isNotEmpty) {
            launchUrl(Uri.parse(article.url));
          }
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (article.imageUrl != null)
              ClipRRect(
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(16)),
                child: Image.network(
                  article.imageUrl!,
                  height: 180,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    height: 120,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          const Color(0xFF2E7D32).withOpacity(0.7),
                          const Color(0xFF4CAF50).withOpacity(0.5),
                        ],
                      ),
                    ),
                    child: const Center(
                        child: Text('🌾', style: TextStyle(fontSize: 48))),
                  ),
                ),
              )
            else
              Container(
                height: 100,
                decoration: BoxDecoration(
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(16)),
                  gradient: LinearGradient(
                    colors: [
                      const Color(0xFF2E7D32).withOpacity(0.7),
                      const Color(0xFF4CAF50).withOpacity(0.5),
                    ],
                  ),
                ),
                child: const Center(
                    child: Text('🌾', style: TextStyle(fontSize: 48))),
              ),
            Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: const Color(0xFF2E7D32).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          article.source,
                          style: const TextStyle(
                            color: Color(0xFF2E7D32),
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const Spacer(),
                      Text(
                        DateFormat('dd MMM').format(article.publishedAt),
                        style:
                            const TextStyle(color: Colors.grey, fontSize: 12),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    article.title,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      height: 1.3,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    article.description,
                    style: const TextStyle(
                        color: Colors.grey, fontSize: 13, height: 1.4),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
