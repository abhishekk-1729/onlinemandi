# Online Mandi

A Flutter application project.

## Getting Started

This project is a starting point for a Flutter application.

### Prerequisites

- Flutter SDK (>=3.0.0)
- Dart SDK
- Android Studio / VS Code with Flutter extensions
- Xcode (for iOS development on macOS)

### Installation

1. Clone the repository
2. Navigate to the project directory
3. Install dependencies:
   ```bash
   flutter pub get
   ```

### Running the App

- **Android**: `flutter run`
- **iOS**: `flutter run` (requires macOS and Xcode)
- **Web**: `flutter run -d chrome`

### Project Structure

```
lib/
├── core/               # Core functionality
│   ├── constants/      # App constants
│   ├── routes/         # App routing
│   ├── theme/          # App theming
│   └── utils/          # Utility functions
├── features/           # Feature modules
│   ├── auth/           # Authentication feature
│   └── home/           # Home feature
├── shared/             # Shared components
│   └── widgets/        # Reusable widgets
└── main.dart           # App entry point

test/                   # Test files
assets/                 # Images, fonts, etc.
android/                # Android platform files
ios/                    # iOS platform files
web/                    # Web platform files
```

### Building

- **Android APK**: `flutter build apk`
- **Android App Bundle**: `flutter build appbundle`
- **iOS**: `flutter build ios`
- **Web**: `flutter build web`

### Testing

Run tests with:
```bash
flutter test
```

## Contributing

1. Fork the repository
2. Create your feature branch
3. Commit your changes
4. Push to the branch
5. Create a Pull Request

