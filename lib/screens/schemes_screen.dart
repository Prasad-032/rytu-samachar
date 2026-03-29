import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../services/language_provider.dart';

class SchemesScreen extends StatelessWidget {
  const SchemesScreen({super.key});

  static const List<Map<String, dynamic>> schemes = [
    {
      'name': 'PM-KISAN',
      'nameTe': 'పిఎం-కిసాన్',
      'emoji': '💰',
      'color': 0xFF1565C0,
      'description':
          'Pradhan Mantri Kisan Samman Nidhi provides income support of ₹6,000 per year to farmer families in three equal installments.',
      'descriptionTe':
          'ప్రధాన మంత్రి కిసాన్ సమ్మాన్ నిధి రైతు కుటుంబాలకు వార్షికంగా ₹6,000 ఆదాయ సహాయాన్ని మూడు సమాన వాయిదాలలో అందిస్తుంది.',
      'eligibility': 'All land-holding farmer families',
      'eligibilityTe': 'భూమి కలిగిన అన్ని రైతు కుటుంబాలు',
      'url': 'https://pmkisan.gov.in',
    },
    {
      'name': 'Rythu Bandhu',
      'nameTe': 'రైతు బంధు',
      'emoji': '🤝',
      'color': 0xFF2E7D32,
      'description':
          'Telangana government scheme providing ₹10,000 per acre per season (₹5,000 each for Kharif and Rabi) as investment support to farmers.',
      'descriptionTe':
          'తెలంగాణ ప్రభుత్వ పథకం రైతులకు పెట్టుబడి సహాయంగా సీజన్‌కు ఎకరాకు ₹10,000 అందిస్తుంది.',
      'eligibility': 'Telangana farmers with registered land',
      'eligibilityTe': 'నమోదైన భూమి కలిగిన తెలంగాణ రైతులు',
      'url': 'https://rythubandhu.telangana.gov.in',
    },
    {
      'name': 'Fasal Bima Yojana',
      'nameTe': 'ఫసల్ బీమా యోజన',
      'emoji': '🛡️',
      'color': 0xFFE65100,
      'description':
          'Pradhan Mantri Fasal Bima Yojana provides crop insurance coverage and financial support to farmers in case of crop failure.',
      'descriptionTe':
          'పంట వైఫల్యం విషయంలో రైతులకు పంట బీమా కవరేజ్ మరియు ఆర్థిక సహాయాన్ని అందిస్తుంది.',
      'eligibility': 'Farmers growing notified crops',
      'eligibilityTe': 'నోటిఫైడ్ పంటలు పండించే రైతులు',
      'url': 'https://pmfby.gov.in',
    },
    {
      'name': 'Kisan Credit Card',
      'nameTe': 'కిసాన్ క్రెడిట్ కార్డ్',
      'emoji': '💳',
      'color': 0xFF6A1B9A,
      'description':
          'Provides farmers with affordable credit for agricultural needs including seeds, fertilizers, and crop protection at low interest rates.',
      'descriptionTe':
          'విత్తనాలు, ఎరువులు మరియు పంట రక్షణ కోసం తక్కువ వడ్డీ రేట్లకు సాగు అవసరాలకు రైతులకు సరసమైన క్రెడిట్ అందిస్తుంది.',
      'eligibility': 'All farmers, sharecroppers, tenant farmers',
      'eligibilityTe': 'అన్ని రైతులు, వాటాదారులు, కౌలు రైతులు',
      'url': 'https://www.nabard.org/kcc',
    },
    {
      'name': 'Rythu Bharosa',
      'nameTe': 'రైతు భరోసా',
      'emoji': '🌱',
      'color': 0xFF00695C,
      'description':
          'Andhra Pradesh government scheme providing ₹13,500 per year to farmers as income support through multiple installments.',
      'descriptionTe':
          'ఆంధ్రప్రదేశ్ ప్రభుత్వ పథకం రైతులకు వార్షికంగా ₹13,500 ఆదాయ సహాయాన్ని అందిస్తుంది.',
      'eligibility': 'AP farmers with less than 5 acres',
      'eligibilityTe': '5 ఎకరాల కంటే తక్కువ కలిగిన ఏపీ రైతులు',
      'url': 'https://rythubarasaap.ap.gov.in',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final lang = context.watch<LanguageProvider>();
    return Scaffold(
      appBar: AppBar(
        title: Text(lang.t('🏛️ Government Schemes', '🏛️ ప్రభుత్వ పథకాలు')),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: schemes.length,
        itemBuilder: (ctx, i) =>
            _SchemeCard(scheme: schemes[i], lang: lang),
      ),
    );
  }
}

class _SchemeCard extends StatefulWidget {
  final Map<String, dynamic> scheme;
  final LanguageProvider lang;

  const _SchemeCard({required this.scheme, required this.lang});

  @override
  State<_SchemeCard> createState() => _SchemeCardState();
}

class _SchemeCardState extends State<_SchemeCard> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final s = widget.scheme;
    final lang = widget.lang;
    final color = Color(s['color'] as int);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 2,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () => setState(() => _expanded = !_expanded),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: Text(s['emoji'],
                          style: const TextStyle(fontSize: 24)),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          lang.t(s['name'], s['nameTe']),
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: color,
                          ),
                        ),
                        Text(
                          lang.t(
                            'Tap to ${_expanded ? 'hide' : 'view'} details',
                            'వివరాలు ${_expanded ? 'దాచు' : 'చూడు'}',
                          ),
                          style:
                              const TextStyle(color: Colors.grey, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    _expanded
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    color: Colors.grey,
                  ),
                ],
              ),
              if (_expanded) ...[
                const Divider(height: 24),
                Text(
                  lang.t(s['description'], s['descriptionTe']),
                  style: const TextStyle(fontSize: 13, height: 1.5),
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.07),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.people, color: color, size: 16),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              lang.t('Eligibility', 'అర్హత'),
                              style: TextStyle(
                                  color: color,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600),
                            ),
                            Text(
                              lang.t(
                                  s['eligibility'], s['eligibilityTe']),
                              style: const TextStyle(fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: () => launchUrl(Uri.parse(s['url']),
                        mode: LaunchMode.externalApplication),
                    icon: const Icon(Icons.open_in_new, size: 16),
                    label: Text(lang.t(
                        'Visit Official Website', 'అధికారిక వెబ్సైట్ చూడండి')),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: color,
                      side: BorderSide(color: color),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
