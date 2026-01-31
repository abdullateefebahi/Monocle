# 👁️ Project Monocle

A cross-platform digital ecosystem for social interactions with a gamified economy.

## 🌟 Features

- **Cross-Platform**: Native experience on Web, Android, iOS, Linux, macOS, and Windows
- **Dual-Token Economy**: Sparks (soft currency) & Orbs (hard currency)
- **Limitless Communities**: Role-based communities with custom tools
- **Gamification Engine**: Quests, Missions, and Events
- **Real-time Chat**: WebSocket-powered messaging
- **Secure Authentication**: Supabase Auth (Email, Social, Magic Link)

## 🏗️ Architecture

```
lib/
├── core/
│   ├── constants/     # App-wide constants & API endpoints
│   ├── providers/     # Riverpod state providers
│   ├── services/      # Supabase & API services
│   └── theme/         # App theming (colors, typography)
├── features/
│   ├── auth/          # Authentication screens
│   ├── home/          # Dashboard & navigation
│   ├── wallet/        # Currency & transactions
│   ├── communities/   # Community features
│   ├── quests/        # Gamification
│   ├── chat/          # Messaging
│   └── profile/       # User profile
└── shared/
    ├── models/        # Data models
    └── widgets/       # Reusable UI components
```

## 🛠️ Tech Stack

| Layer | Technology |
|-------|------------|
| **Frontend** | Flutter (Dart) |
| **State Management** | Riverpod |
| **Backend** | Go Services |
| **Database** | PostgreSQL (Supabase) |
| **Authentication** | Supabase Auth |
| **Real-time** | WebSockets |

## 🚀 Getting Started

### Prerequisites

- Flutter SDK 3.10.7+
- Dart 3.0+
- Supabase project (for backend)
- Go 1.21+ (for backend services)

### Setup

1. **Clone & Install Dependencies**
   ```bash
   git clone <repository>
   cd monocle_app
   flutter pub get
   ```

2. **Configure Supabase**
   - Create a Supabase project at [supabase.com](https://supabase.com)
   - Run the SQL schema in `supabase_schema.sql`
   - Update `lib/core/constants/app_constants.dart`:
     ```dart
     static const String supabaseUrl = 'YOUR_SUPABASE_URL';
     static const String supabaseAnonKey = 'YOUR_SUPABASE_ANON_KEY';
     ```

3. **Generate Code** (for JSON serialization)
   ```bash
   flutter pub run build_runner build --delete-conflicting-outputs
   ```

4. **Run the App**
   ```bash
   # Web
   flutter run -d chrome

   # Android
   flutter run -d android

   # iOS
   flutter run -d ios

   # Windows
   flutter run -d windows

   # macOS
   flutter run -d macos

   # Linux
   flutter run -d linux
   ```

## 💰 Economy System

### Sparks (⚡ Soft Currency)
- Earned through engagement (quests, missions, events)
- Used for community access, mini-games, tipping
- Zero transaction fees (database ledger)

### Orbs (🔮 Hard Currency)
- Purchased via IAP
- Used for premium features, NFT-like assets
- Can be converted to Sparks

## 🎮 Gamification

| Feature | Description |
|---------|-------------|
| **Quests** | Story-driven challenges with rare rewards |
| **Daily Missions** | Quick tasks that reset daily |
| **Events** | Time-limited activities with bonus multipliers |
| **Achievements** | Milestone-based rewards |

## 📱 Supported Platforms

| Platform | Status |
|----------|--------|
| Android | ✅ Ready |
| iOS | ✅ Ready |
| Web | ✅ Ready |
| Windows | ✅ Ready |
| macOS | ✅ Ready |
| Linux | ✅ Ready |

## 🔐 Security

- Row Level Security (RLS) on all database tables
- JWT-based authentication
- Server-side validation for all transactions
- Immutable transaction ledger

## 📄 License

This project is proprietary software.

---

Built with 💜 using Flutter & Supabase
