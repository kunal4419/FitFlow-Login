# Fit-Flow

A modern Flutter fitness application designed to streamline your workout routine with structured training programs and exercise video demonstrations.

## Features

- **Push/Pull/Leg Split Training** - Organized workout routines for optimal muscle group targeting
- **Exercise Video Library** - Video demonstrations with caching for offline access
- **Workout Tracking** - Monitor your progress and stats
- **Clean Interface** - Intuitive design for seamless navigation

## Getting Started

### Prerequisites

- Flutter SDK (latest stable version)
- Dart SDK
- Android Studio / Xcode (for mobile deployment)

### Installation

1. Clone the repository
```bash
git clone <repository-url>
cd Fit-Flow-Flutter-Dev
```

2. Install dependencies
```bash
flutter pub get
```

3. Run the application
```bash
flutter run
```

flutter run      --dart-define=SUPABASE_URL=https://ybifciydjqimcxccevad.supabase.co      --dart-define=SUPABASE_ANON_KEY=sb_publishable_mcViYMaZ7sy78GROUs0MAQ_fQclwvDZ

## Build Instructions

### Build APK (Release)

To build a release APK for Android:

```bash
flutter build apk --release
```

The generated APK will be located at `build/app/outputs/flutter-apk/app-release.apk`

### Generate Splash Screen

To generate the native splash screen:

```bash
dart run flutter_native_splash:create
```

### Test the Splash Screen

To test the splash screen implementation:

```bash
flutter clean
flutter pub get
flutter run
```

## Project Structure

```
lib/
├── data/          # Exercise data and resources
├── models/        # Data models
├── screens/       # UI screens
├── services/      # Business logic and services
└── widgets/       # Reusable UI components
```

## License

All rights reserved.
