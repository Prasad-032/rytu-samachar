# 🌾 Rytu Samachar - రైతు సమాచార్

A Flutter app for Telugu-speaking Indian farmers providing agricultural news, weather, market prices, community chat, and government scheme information.

---

## 📱 Screens
1. Splash Screen
2. Login / Sign Up (Firebase Auth)
3. Home (Bottom Navigation)
4. News Feed (NewsAPI)
5. Weather (OpenWeather API)
6. Market Prices (Data.gov.in)
7. Community Chat (Firebase Firestore)
8. Government Schemes (expandable cards)
9. Profile (language toggle, notifications, logout)

---

## 🚀 Setup Instructions

### Step 1 — Install Flutter
Download Flutter SDK: https://flutter.dev/docs/get-started/install

### Step 2 — Firebase Setup
1. Go to https://console.firebase.google.com
2. Create a new project named **"Rytu Samachar"**
3. Add an Android app with package name: `com.rytusamachar.app`
4. Download `google-services.json` and place it in `android/app/`
5. Enable these Firebase services:
   - **Authentication** → Email/Password
   - **Cloud Firestore** → Start in test mode
   - **Cloud Messaging** (FCM)

### Step 3 — API Keys
Open the service files and replace placeholder keys:

| File | Key to Replace | Get it from |
|---|---|---|
| `lib/services/weather_service.dart` | `YOUR_OPENWEATHER_API_KEY` | https://openweathermap.org/api |
| `lib/services/news_service.dart` | `YOUR_NEWSAPI_KEY` | https://newsapi.org |
| `lib/services/market_service.dart` | `YOUR_DATA_GOV_IN_API_KEY` | https://data.gov.in/user/register |

> ⚠️ All three APIs are **FREE** with generous limits. The app works with mock data even without API keys (for testing).

### Step 4 — Firestore Security Rules
In Firebase Console → Firestore → Rules, paste:
```
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /messages/{msg} {
      allow read, write: if request.auth != null;
    }
  }
}
```

### Step 5 — Run the App
```bash
cd rytu_samachar
flutter pub get
flutter run
```

---

## 🛠️ Tech Stack
| Layer | Technology |
|---|---|
| Framework | Flutter 3.x |
| Language | Dart |
| Auth | Firebase Auth |
| Database | Cloud Firestore |
| Notifications | Firebase FCM + Local Notifications |
| Weather | OpenWeather API |
| News | NewsAPI |
| Market Prices | Data.gov.in API |
| State Management | Provider |
| Storage | SharedPreferences |

---

## 📦 Packages
```yaml
firebase_core: ^2.24.2
firebase_auth: ^4.15.3
cloud_firestore: ^4.13.6
firebase_messaging: ^14.7.9
http: ^1.2.0
shared_preferences: ^2.2.2
provider: ^6.1.1
flutter_local_notifications: ^16.3.0
url_launcher: ^6.2.4
intl: ^0.18.1
cached_network_image: ^3.3.1
shimmer: ^3.0.0
```

---

## 📁 Project Structure
```
lib/
├── main.dart                        # App entry point + Firebase init
├── screens/
│   ├── splash_screen.dart           # Logo + auto-login check
│   ├── auth_screen.dart             # Login + Sign Up
│   ├── home_screen.dart             # Bottom navigation shell
│   ├── news_screen.dart             # Agricultural news feed
│   ├── weather_screen.dart          # Weather with city search
│   ├── market_prices_screen.dart    # Crop prices with state filter
│   ├── chat_screen.dart             # Real-time community chat
│   ├── schemes_screen.dart          # Government schemes
│   └── profile_screen.dart          # Profile, language, notifications
└── services/
    ├── language_provider.dart       # English ↔ Telugu toggle
    ├── notification_service.dart    # FCM + local notifications
    ├── weather_service.dart         # OpenWeather API
    ├── news_service.dart            # NewsAPI
    └── market_service.dart          # Data.gov.in API
```

---

## 🌍 Languages
- English 🇬🇧 (default)
- Telugu తెలుగు 🇮🇳

Toggle from Profile screen. Preference is saved and remembered.

---

## 🔔 Notifications
- Market price update alerts
- Firebase FCM for remote push
- Local notifications for in-app triggers
- Test notification button in Profile

---

## 👥 Target Users
Indian farmers, especially Telugu-speaking farmers in Telangana and Andhra Pradesh.

---

## ⚠️ Notes
- Replace `google-services.json` with your own — do NOT share your Firebase config publicly
- The app works with **mock data** if API keys are not set — useful for UI testing
- Minimum Android SDK: **21** (Android 5.0 Lollipop)
