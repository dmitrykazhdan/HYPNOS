# 🚀 HYPNOS for Appetize.io

This guide explains how to deploy HYPNOS to Appetize.io for easy demo sharing.

## 📋 Overview

The Appetize.io version of HYPNOS features:
- ✅ **Local LLM Processing** - No server required
- ✅ **Voice Chat** - Speech recognition & synthesis
- ✅ **Image Analysis** - Camera integration
- ✅ **Demo Mode** - Optimized for web testing
- ✅ **Cross-Platform** - Works on all devices

## 🛠️ Build Instructions

### 1. Prerequisites
```bash
# Ensure you have Flutter installed
flutter --version

# Install dependencies
cd hypnos_app
flutter pub get
```

### 2. Build for Appetize.io
```bash
# Use the automated build script
./scripts/build_appetize.sh

# Or build manually
flutter build apk --release --target-platform android-arm64
```

### 3. Upload to Appetize.io
1. Go to [Appetize.io Upload](https://appetize.io/upload)
2. Upload the generated APK: `build/hypnos-appetize.apk`
3. Configure using `appetize.yml` settings
4. Share the demo link!

## ⚙️ Configuration

### Demo Mode Settings
Edit `lib/config/app_config.dart`:
```dart
// Demo Mode Configuration
static const bool DEMO_MODE = true;
static const bool SHOW_DEMO_BANNER = true;
static const String DEMO_BANNER_TEXT = "Demo Mode - Local AI Processing";
```

### Local LLM Settings
```dart
// Model Configuration
static const bool USE_LOCAL_MODEL = true;  // Enable local processing
static const bool USE_MAC_MODEL = false;   // Disable server mode
```

## 🎯 Features in Demo Mode

### Voice Features
- **Speech Recognition**: Tap the sphere to start voice input
- **Text-to-Speech**: AI responses are spoken aloud
- **Voice Toggle**: Enable/disable in settings

### Image Features
- **Camera Integration**: Take photos for analysis
- **Image Processing**: AI analyzes sleep environment
- **Optional Text**: Add context to images

### Chat Features
- **Conversation History**: Save and manage chats
- **Text Input**: Type messages directly
- **Real-time Processing**: Fast local inference

## 📱 Appetize.io Configuration

The `appetize.yml` file configures:
- **Device Selection**: Pixel 7, Galaxy S22, iPhone 14
- **Feature Flags**: All features enabled for demo
- **Performance**: 2GB memory limit, 5-minute timeout
- **Instructions**: User guidance for demo

## 🔧 Customization

### Adding Real LLM Models
1. Place your GGUF model in `assets/models/`
2. Update `lib/services/local_llm_service.dart`
3. Implement actual llama.cpp integration
4. Test performance on target devices

### Modifying Demo Responses
Edit `lib/services/local_llm_service.dart`:
```dart
String _generateMockResponse(String input) {
  // Add your custom responses here
  return 'Your custom response here';
}
```

## 🚨 Troubleshooting

### Build Issues
```bash
# Clean and rebuild
flutter clean
flutter pub get
flutter build apk --release
```

### Appetize.io Issues
- **Timeout**: Increase timeout in appetize.yml
- **Memory**: Reduce model size or optimize
- **Performance**: Use smaller models for demo

### Local Testing
```bash
# Test on local device
flutter run --release

# Test specific features
flutter test
```

## 📊 Performance Optimization

### For Appetize.io
- **Model Size**: Keep under 100MB for fast loading
- **Memory Usage**: Optimize for 2GB limit
- **Startup Time**: Minimize initialization delay
- **Response Time**: Target <2 seconds for demo

### Recommended Settings
```dart
// Performance Configuration
static const int REQUEST_TIMEOUT_SECONDS = 10;
static const int MODEL_LOAD_TIMEOUT_SECONDS = 30;
static const int SPEECH_TIMEOUT_SECONDS = 15;
```

## 🔗 Useful Links

- [Appetize.io Documentation](https://docs.appetize.io/)
- [Flutter Build Guide](https://docs.flutter.dev/deployment/android)
- [llama.cpp Integration](https://github.com/ggerganov/llama.cpp)
- [HYPNOS Main Repository](../README.md)

## 📞 Support

For issues with:
- **Appetize.io**: Check their documentation
- **Flutter Build**: Review Flutter deployment guide
- **HYPNOS App**: Check main README.md

---

**Ready to share your demo?** 🎉
Build and upload to Appetize.io to let users try HYPNOS instantly! 