class AppConfig {
  // Backend API Configuration
  static const String baseUrl = 'https://your-backend-domain.com'; // TODO: Update with your backend URL
  
  // Authentication
  static const String apiKey = 'your-api-key-here'; // TODO: Update with your API key
  
  // App Configuration
  static const String appName = 'Hypnos Assistant';
  static const String appVersion = '1.0.0';
  
  // Feature Flags
  static const bool enableVoiceInput = true;
  static const bool enableCameraInput = true;
  static const bool enableTextInput = true;
  static const bool enableTtsOutput = true;
  
  // Accessibility Configuration
  static const bool enableAccessibilityMode = true;
  static const bool enableHapticFeedback = true;
  static const bool enableVoiceFeedback = true;
  
  // Performance Configuration
  static const int requestTimeoutSeconds = 30;
  static const int speechTimeoutSeconds = 30;
  
  // UI Configuration
  static const double maxMessageWidthRatio = 0.75;
  static const double buttonSize = 60.0;
  static const double voiceButtonSize = 80.0;
  
  // Debug Configuration
  static const bool enableDebugLogging = true;
  static const bool enablePerformanceMetrics = true;
  
  // Voice Configuration
  static const String defaultVoiceName = 'com.apple.ttsbundle.Samantha-compact';
  static const String defaultVoiceLocale = 'en-US';
  static const double defaultSpeechRate = 0.5;
  static const double defaultVolume = 0.9;
  
  // Available Voice Options (iOS/macOS)
  static const Map<String, Map<String, String>> availableVoices = {
    'Samantha': {
      'name': 'com.apple.ttsbundle.Samantha-compact',
      'locale': 'en-US',
      'description': 'Clear, friendly female voice'
    },
    'Alex': {
      'name': 'com.apple.ttsbundle.Alex-compact',
      'locale': 'en-US', 
      'description': 'Natural male voice'
    },
    'Victoria': {
      'name': 'com.apple.ttsbundle.Victoria-compact',
      'locale': 'en-US',
      'description': 'Warm, soothing female voice'
    },
    'Daniel': {
      'name': 'com.apple.ttsbundle.Daniel-compact',
      'locale': 'en-GB',
      'description': 'British male voice'
    },
    'Martha': {
      'name': 'com.apple.ttsbundle.Martha-compact',
      'locale': 'en-GB',
      'description': 'British female voice'
    },
    'Tom': {
      'name': 'com.apple.ttsbundle.Tom-compact',
      'locale': 'en-US',
      'description': 'Deep, authoritative male voice'
    }
  };
} 