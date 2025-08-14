# EcoDataAtlas - Claude Code Configuration

## Project Overview

EcoDataAtlas is a Flutter application that provides ecological and economic data visualization. It integrates with World Bank APIs and Firebase services for authentication and data storage.

## Development Environment

- Flutter 3.32.8 (Stable channel)
- Dart 3.8.1
- Firebase integration (Auth, Firestore, Storage)

## Key Dependencies

- **State Management**: flutter_riverpod ^3.0.0-dev.17
- **Routing**: go_router ^16.1.0
- **UI**: font_awesome_flutter ^10.9.0
- **Backend**: Firebase suite (core, auth, firestore, storage)
- **HTTP**: http ^1.2.2
- **Local Storage**: shared_preferences ^2.5.3
- **Image Handling**: image_picker ^1.1.2
- **Code Generation**: build_runner, freezed, json_annotation

## Project Structure

```
lib/
├── api_services/         # API integration (World Bank)
├── common/              # Shared utilities and widgets
│   ├── main_navigation/ # Navigation components
│   └── widgets/         # Reusable UI components
├── constants/           # App constants and configurations
├── features/           # Feature-based modules (deleted - needs reconstruction)
├── router/             # Go Router configuration
└── main.dart           # App entry point
```

## Build Commands

```zsh
# Get dependencies
flutter pub get

# Run code generation
dart run build_runner build --delete-conflicting-outputs

# Run the app (debug)
flutter run

# Build for release
flutter build apk --release     # Android
flutter build ios --release     # iOS
flutter build web --release     # Web
flutter build macos --release   # macOS
```

## Development Workflow

1. Use `flutter pub get` after adding dependencies
2. Run `dart run build_runner build` after modifying models/providers
3. Use `flutter analyze` for static analysis
4. Use `flutter test` to run tests

## Firebase Configuration

- Google Services configured for Android (`google-services.json`)
- iOS configuration present (`GoogleService-Info.plist`)
- Firebase options generated (`firebase_options.dart`)

## Platform Support

- ✅ Android
- ✅ iOS
- ✅ Web

## Assets

- World Bank data files in `assets/worldbank/`
- Material Design icons enabled

## Notes

- The `features/` directory was recently deleted - may need reconstruction
- Uses Riverpod for state management with code generation
- Freezed for immutable data classes
- Go Router for navigation
- Firebase for backend services

## Testing

- Widget tests located in `test/`
- Run with: `flutter test`

## Known Issues & Solutions

### iOS/macOS Build Performance
The iOS and macOS builds are slow due to Firebase dependencies compilation time:
- First build takes 5-10 minutes (CocoaPods + Xcode compilation)
- Subsequent builds are faster due to caching
- This is normal behavior for Firebase-enabled Flutter apps

### macOS Deployment Target Fixed
- Updated `macos/Podfile` platform from `10.14` to `10.15`
- Required for Firebase compatibility on macOS

### Working Development Setup
```zsh
# ✅ Web (fastest for development/testing)
flutter run -d chrome

# ✅ macOS (after initial long build)
flutter run -d macos  

# ✅ iOS Simulator (after initial long build)
flutter run -d ios

# ✅ Android
flutter run -d android
```

### Recommended Development Workflow
1. **Primary development**: Use `flutter run -d chrome` for fast iteration
2. **Platform testing**: Use native builds after major changes
3. **Production builds**: Allow extra time for initial Firebase compilation

## Authentication Troubleshooting

### Keychain Error (인증 정보 저장 중 오류가 발생했습니다)

**Problem**: Error message "인증 정보 저장 중 오류가 발생했습니다. 앱을 다시 시작해주세요" when creating accounts.

**Root Cause**: SharedPreferences keychain access issues on iOS/macOS, particularly in simulator environments.

**Solutions Applied**:

1. **Enhanced Error Handling**: 
   - Authentication repository now handles keychain errors gracefully
   - Account creation succeeds even if local storage fails
   - Relies on Firebase authentication state as primary source

2. **Improved User Messages**:
   - Changed error message to: "로컬 저장소 접근에 문제가 있지만, 계정 생성은 완료되었습니다. 로그인을 다시 시도해주세요"
   - Provides clearer guidance to users

3. **Automatic Recovery**:
   - Automatic keychain error recovery attempts
   - Progressive cleanup of authentication keys
   - Graceful fallback to Firebase-only authentication

**User Instructions**:
```
If you encounter the keychain error:
1. The account was likely created successfully
2. Close and restart the app
3. Try logging in with your credentials
4. The app will automatically recover from keychain issues
```

**Developer Notes**:
- Keychain errors are common in iOS simulators
- Firebase authentication works independently of local storage
- The app prioritizes functionality over local state persistence
- Enhanced error recovery mechanisms handle most edge cases
