# 📱 HYPNOS Flutter App

An insomnia-friendly AI sleep companion built with Flutter.

## ✨ Features

- 🎤 **Voice Chat** - Talk naturally with AI
- 🌙 **Dark Theme** - Sleep-friendly interface
- 🎨 **Modern UI** - Glass morphism design
- 💬 **Conversation History** - Save and manage chats
- 🔧 **Settings** - Customize voice and preferences

## 🚀 Quick Start

```bash
# Install dependencies
flutter pub get

# Run on iOS
flutter run -d ios

# Run on Android  
flutter run -d android
```

## 📱 Requirements

- Flutter 3.0+
- iOS 13.0+ / Android 5.0+
- Microphone permissions for voice features
- Camera permissions for image analysis

## 🔗 Configuration

Edit `lib/config/app_config.dart` to:
- Change server URL
- Toggle features on/off
- Customize voice settings
- Adjust UI preferences

## 🏗️ Architecture

- **Provider** - State management
- **Services** - AI, speech, storage
- **Widgets** - Reusable UI components
- **Models** - Data structures
- **Utils** - Theme and helpers

## 📦 Dependencies

- `speech_to_text` - Voice recognition
- `flutter_tts` - Text-to-speech
- `image_picker` - Camera integration
- `http` - API communication
- `shared_preferences` - Local storage 