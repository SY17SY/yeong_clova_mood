# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Task Master AI Instructions
**Import Task Master's development workflow commands and guidelines, treat as if import is in the main CLAUDE.md file.**
@./.taskmaster/CLAUDE.md

## Project Overview
Yeong Clova Mood is a Flutter mood tracking application with Firebase backend integration. The app allows users to create posts with moods, images, and share content in a social feed format.

## Development Commands

### Running the App
```bash
# Run on iOS simulator
flutter run

# Run on Android emulator
flutter run

# Hot reload is available during development
```

### Building
```bash
# Build iOS
flutter build ios

# Build Android APK
flutter build apk

# Build Android bundle
flutter build appbundle
```

### Testing and Code Quality
```bash
# Run tests
flutter test

# Analyze code (linting)
flutter analyze

# Format code
flutter format .

# Get dependencies
flutter pub get

# Clean build artifacts
flutter clean
```

## Architecture

### State Management
- **Flutter Riverpod**: Primary state management solution
- **StreamNotifier**: Used for real-time data streams (posts, user data)
- **StateNotifier**: Used for UI state management (upload state, settings)
- **Provider**: Used for dependency injection of repositories

### Project Structure
```
lib/
├── constants/          # App-wide constants (colors, sizes, text, etc.)
├── models/            # Data models with Firebase serialization
├── repos/             # Repository layer for data access (Firebase, SharedPreferences)
├── view_models/       # Business logic and state management (Riverpod)
├── views/             # UI screens organized by feature
│   ├── abc_authentication/  # Auth flow screens
│   ├── d_common/           # Shared navigation screens
│   └── f_upload/           # Post creation screens
├── widgets/           # Reusable UI components
├── router.dart        # GoRouter configuration
├── utils.dart         # Utility functions
├── firebase_options.dart  # Firebase configuration
└── main.dart          # App entry point
```

### Firebase Integration
- **Authentication**: Firebase Auth with email/password
- **Database**: Cloud Firestore for posts and user data
- **Storage**: Firebase Storage for images
- **Functions**: Cloud Functions integration available

### File Naming Conventions
Files are prefixed with letters indicating their layer/purpose:
- `a_` prefix: User-related files
- `b_` prefix: Authentication-related files
- `c_` prefix: Login-related files
- `d_` prefix: Common/shared files
- `e_` prefix: Personal/private screens
- `f_` prefix: Post/content-related files

### Key Architecture Patterns

**Repository Pattern**:
- Repositories handle all data access logic
- View models consume repositories via dependency injection
- Clean separation between data layer and business logic

**MVVM with Riverpod**:
- Models: Plain Dart classes with Firebase serialization
- View Models: Riverpod notifiers managing state and business logic
- Views: Flutter widgets consuming state via Riverpod

**Navigation**:
- GoRouter for declarative navigation
- Custom page transitions with fade effects
- Authentication-aware routing with redirects

## Development Notes

### Theme System
- Custom theme with Pretendard fonts (Semibold/Medium variants)
- Light and dark theme support
- Color system defined in `constants/colors.dart`
- Typography scale in `constants/sizes.dart`

### Image Handling
- Camera and gallery integration via `image_picker`
- Firebase Storage for image uploads
- Gallery saving via `gal` package
- Permission handling via `permission_handler`

### Error Handling
- Firebase errors displayed via `showFirebaseErrorSnack` utility
- AsyncValue.guard pattern for safe async operations
- Graceful error states in UI components

### Asset Management
- Images stored in `assets/images/`
- Custom fonts in `assets/fonts/`
- SVG support via `flutter_svg`

## Firebase Configuration
The app uses Firebase project `yeong-mood-tracker-0` with the following services:
- Authentication
- Cloud Firestore
- Cloud Storage
- Cloud Functions

## Dependencies
Key packages used:
- State Management: `flutter_riverpod`
- Navigation: `go_router`
- Firebase: `firebase_core`, `firebase_auth`, `cloud_firestore`, `firebase_storage`
- UI: `font_awesome_flutter`, `flutter_svg`
- Camera: `camera`, `image_picker`, `gal`
- Permissions: `permission_handler`
- Storage: `shared_preferences`