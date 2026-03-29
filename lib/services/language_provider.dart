import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageProvider extends ChangeNotifier {
  bool _isTelugu = false;
  static const String _key = 'is_telugu';

  bool get isTelugu => _isTelugu;

  LanguageProvider() {
    _loadLanguagePreference();
  }

  Future<void> _loadLanguagePreference() async {
    final prefs = await SharedPreferences.getInstance();
    _isTelugu = prefs.getBool(_key) ?? false;
    notifyListeners();
  }

  Future<void> toggleLanguage() async {
    _isTelugu = !_isTelugu;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_key, _isTelugu);
    notifyListeners();
  }

  String t(String english, String telugu) {
    return _isTelugu ? telugu : english;
  }
}
