# Event Countdown App

A comprehensive Flutter-based event countdown application with dual interfaces: an Admin Dashboard for event management and a Client App for viewing countdowns with notifications.

## 📱 Project Overview

This project consists of two Flutter applications:

- **Admin Dashboard** (`Admin/`) - Event management interface for creating, editing, and deleting countdown events
- **Client App** (`Client/`) - User-facing application for viewing countdowns with local notifications

Both applications are built with Flutter and use Firebase for backend services including authentication and Firestore database.

## 🏗️ Architecture

### Admin Dashboard

- **Purpose**: Event management and administration
- **Features**: Create, edit, delete countdown events
- **Authentication**: Firebase Auth with login/signup
- **Database**: Cloud Firestore for event storage
- **State Management**: Flutter Bloc (Cubit pattern)

### Client App

- **Purpose**: User-facing countdown viewer
- **Features**: View countdowns, local notifications, custom reminders
- **Authentication**: Firebase Auth
- **Notifications**: Local notifications with custom timing
- **State Management**: Flutter Bloc (Cubit pattern)

## 🚀 Features

### Admin Dashboard Features

- ✅ Firebase Authentication (Login/Signup)
- ✅ Event Creation with date/time selection
- ✅ Event Editing and Deletion
- ✅ Real-time countdown display
- ✅ Dark theme UI with custom colors
- ✅ Responsive design
- ✅ Error handling and loading states

### Client App Features

- ✅ Firebase Authentication
- ✅ View all countdown events
- ✅ Real-time countdown timers
- ✅ Local notifications
- ✅ Custom reminder settings
- ✅ Event completion notifications
- ✅ Dark theme with Google Fonts (Exo 2)
- ✅ Pull-to-refresh functionality
- ✅ Offline support with local storage

## 🛠️ Tech Stack

### Core Technologies

- **Flutter**: ^3.7.0
- **Dart**: Latest stable
- **Firebase**: Authentication, Firestore, Core

### Key Dependencies

- **State Management**: `flutter_bloc: ^9.1.0`
- **Navigation**: `go_router: ^15.1.1`
- **Notifications**: `flutter_local_notifications: ^19.1.0`
- **UI Components**: `font_awesome_flutter: ^10.8.0`
- **Typography**: `google_fonts: ^6.2.1`
- **Local Storage**: `sqflite: ^2.4.2`
- **Timezone Support**: `timezone: ^0.10.0`
- **Permissions**: `permission_handler: ^12.0.0+1`

## 📁 Project Structure

```
event-countdown-DEPI/
├── Admin/                          # Admin Dashboard App
│   ├── lib/
│   │   ├── controllers/            # Bloc/Cubit state management
│   │   │   ├── event_cubit/        # Event management logic
│   │   │   └── user_cubit/         # User authentication logic
│   │   ├── core/                   # Core utilities
│   │   │   ├── helpers/            # Helper functions and theming
│   │   │   └── routing/            # Navigation configuration
│   │   ├── models/                 # Data models and services
│   │   │   ├── data_models/        # Event and user models
│   │   │   └── services/           # Firebase and API services
│   │   ├── views/                  # UI screens and widgets
│   │   │   ├── login/              # Authentication screens
│   │   │   ├── signup/             # Registration screens
│   │   │   ├── widgets/            # Reusable UI components
│   │   │   ├── add_event_view.dart # Event creation/editing
│   │   │   └── home_view.dart      # Main dashboard
│   │   └── main.dart               # App entry point
│   ├── android/                    # Android-specific files
│   ├── ios/                        # iOS-specific files
│   ├── web/                        # Web-specific files
│   └── pubspec.yaml                # Dependencies and metadata
│
├── Client/                         # Client App
│   ├── lib/
│   │   ├── controllers/            # Bloc/Cubit state management
│   │   ├── core/                   # Core utilities
│   │   ├── models/                 # Data models and services
│   │   ├── views/                  # UI screens and widgets
│   │   │   ├── events/             # Event-related screens
│   │   │   ├── login/              # Authentication screens
│   │   │   ├── signup/             # Registration screens
│   │   │   └── splash_screen/      # App loading screen
│   │   └── main.dart               # App entry point
│   ├── android/                    # Android-specific files
│   ├── ios/                        # iOS-specific files
│   ├── web/                        # Web-specific files
│   └── pubspec.yaml                # Dependencies and metadata
│
└── README.md                       # This file
```

## 🔧 Setup Instructions

### Prerequisites

- Flutter SDK (^3.7.0)
- Dart SDK
- Firebase project setup
- Android Studio / VS Code
- Git

### Firebase Setup

1. Create a new Firebase project at [Firebase Console](https://console.firebase.google.com/)
2. Enable Authentication (Email/Password)
3. Enable Firestore Database
4. Download `google-services.json` for Android
5. Download `GoogleService-Info.plist` for iOS
6. Place the files in their respective platform directories

### Installation Steps

#### 1. Clone the Repository

```bash
git clone https://github.com/A7medMaged/event-countdown-DEPI.git
cd event-countdown-DEPI
```

#### 2. Install Dependencies

For Admin Dashboard:

```bash
cd Admin
flutter pub get
```

For Client App:

```bash
cd Client
flutter pub get
```

#### 3. Firebase Configuration

- Update `firebase_options.dart` files with your Firebase project configuration
- Ensure `google-services.json` and `GoogleService-Info.plist` are properly placed

#### 4. Run the Applications

Admin Dashboard:

```bash
cd Admin
flutter run
```

Client App:

```bash
cd Client
flutter run
```

## 📱 Platform Support

Both applications support:

- ✅ Android
- ✅ iOS
- ✅ Web
- ✅ Windows
- ✅ macOS
- ✅ Linux

## 🔐 Authentication

The applications use Firebase Authentication with email/password authentication. Users can:

- Sign up with email and password
- Sign in to existing accounts
- Sign out from the application

## 🗄️ Database Schema

### Events Collection (Firestore)

```json
{
  "id": "string",
  "title": "string",
  "description": "string",
  "eventDate": "timestamp",
  "reminderDuration": "duration",
  "createdAt": "timestamp",
  "updatedAt": "timestamp",
  "userId": "string"
}
```

## 🔔 Notification System

The Client App includes a comprehensive notification system:

- **Custom Reminders**: Set custom reminder times before events
- **Event Completion**: Notifications when countdowns reach zero
- **Permission Handling**: Automatic permission requests
- **Timezone Support**: Proper timezone handling for notifications

## 🎨 UI/UX Features

### Design System

- **Dark Theme**: Consistent dark theme across both apps
- **Custom Colors**: Branded color scheme with primary and secondary colors
- **Typography**: Google Fonts (Exo 2) for modern typography
- **Icons**: Font Awesome icons for consistent iconography
- **Responsive**: Adaptive layouts for different screen sizes

### User Experience

- **Real-time Updates**: Live countdown timers
- **Pull-to-Refresh**: Easy data refresh functionality
- **Loading States**: Proper loading indicators
- **Error Handling**: User-friendly error messages
- **Empty States**: Helpful empty state screens

## 🧪 Testing

Run tests for both applications:

```bash
# Admin Dashboard tests
cd Admin
flutter test

# Client App tests
cd Client
flutter test
```

## 🚀 Building for Production

### Android APK

```bash
cd Admin  # or Client
flutter build apk --release
```

### iOS App

```bash
cd Admin  # or Client
flutter build ios --release
```

### Web App

```bash
cd Admin  # or Client
flutter build web --release
```

## 📝 Development Guidelines

### Code Structure

- Follow Flutter/Dart best practices
- Use meaningful variable and function names
- Implement proper error handling
- Add comments for complex logic

### State Management

- Use Bloc/Cubit pattern consistently
- Separate business logic from UI
- Handle loading, success, and error states

### UI Development

- Use consistent theming
- Implement responsive design
- Follow Material Design guidelines
- Test on multiple screen sizes



## 🆘 Support

For support and questions:

- Create an issue in the repository
- Check the documentation


## 🔄 Version History

- **v1.0.0** - Initial release with Admin Dashboard and Client App
  - Firebase integration
  - Real-time countdowns
  - Local notifications
  - Authentication system
  - Cross-platform support

---
