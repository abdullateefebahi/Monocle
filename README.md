# Monocle

**Connect. Engage. Earn.**

A cross-platform digital ecosystem for social interactions with a gamified economy.

## Features

- 🎮 **Gamified Economy** - Earn Shards and Orbs through quests and activities
- 👥 **Communities** - Join and interact with communities organized by sectors
- 📋 **Quests System** - Complete daily, weekly, and global quests for rewards
- 💰 **Wallet** - Manage your digital currency and make transfers
- 🏆 **Leveling System** - Progress through levels and unlock new features

## Tech Stack

- **Frontend**: Flutter (iOS, Android, Web)
- **Backend**: Supabase (PostgreSQL, Auth, Realtime)
- **State Management**: Riverpod
- **Navigation**: GoRouter

## Getting Started

### Prerequisites

- Flutter SDK 3.0.0+
- Dart SDK 3.0.0+
- Supabase project

### Setup

1. Clone the repository:
```bash
git clone https://github.com/yourusername/monocle_app.git
cd monocle_app
```

2. Create `.env` file from example:
```bash
cp .env.example .env
```

3. Add your Supabase credentials to `.env`:
```
SUPABASE_URL=your_supabase_url
SUPABASE_ANON_KEY=your_anon_key
```

4. Install dependencies:
```bash
flutter pub get
```

5. Generate code:
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

6. Run the app:
```bash
flutter run
```

## Building

### Android
```bash
flutter build apk --release
# or for App Bundle
flutter build appbundle --release
```

### iOS
```bash
flutter build ipa --release
```

### Web
```bash
flutter build web --release
```

## CI/CD

This project uses **Codemagic** for CI/CD. See `codemagic.yaml` for workflow configurations.

## Project Structure

```
lib/
├── core/
│   ├── constants/    # App constants
│   ├── providers/    # Global providers
│   ├── services/     # API & Supabase services
│   └── theme/        # App theming
├── features/
│   ├── auth/         # Authentication
│   ├── communities/  # Communities & Sectors
│   ├── home/         # Home screen
│   ├── quests/       # Quest system
│   └── wallet/       # Wallet & transactions
└── shared/
    ├── models/       # Data models
    └── widgets/      # Reusable widgets
```

## License

This project is proprietary and confidential.
