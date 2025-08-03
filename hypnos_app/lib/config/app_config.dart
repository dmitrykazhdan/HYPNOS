class AppConfig {
  // Model Configuration
  static const bool USE_MAC_MODEL = true; // Set to false to use local model
  
  // Mac Server Configuration
  static const String MAC_SERVER_URL = 'http://192.168.1.116:3001';
  
  // Local Model Configuration
  static const String LOCAL_MODEL_PATH = 'hypnos_model.gguf';
  static const int LOCAL_MODEL_CONTEXT_SIZE = 4096;
  static const int LOCAL_MODEL_THREADS = 4;
  
  // App Configuration
  static const String APP_NAME = 'Hypnos Assistant';
  static const String APP_VERSION = '1.0.0';
  
  // Feature Flags
  static const bool ENABLE_VOICE_INPUT = true;
  static const bool ENABLE_CAMERA_INPUT = true;
  static const bool ENABLE_TEXT_INPUT = true;
  static const bool ENABLE_TTS_OUTPUT = true;
  
  // Accessibility Configuration
  static const bool ENABLE_ACCESSIBILITY_MODE = true;
  static const bool ENABLE_HAPTIC_FEEDBACK = true;
  static const bool ENABLE_VOICE_FEEDBACK = true;
  
  // Performance Configuration
  static const int REQUEST_TIMEOUT_SECONDS = 30;
  static const int MODEL_LOAD_TIMEOUT_SECONDS = 60;
  static const int SPEECH_TIMEOUT_SECONDS = 30;
  
  // UI Configuration
  static const double MAX_MESSAGE_WIDTH_RATIO = 0.75;
  static const double BUTTON_SIZE = 60.0;
  static const double VOICE_BUTTON_SIZE = 80.0;
  
  // Debug Configuration
  static const bool ENABLE_DEBUG_LOGGING = true;
  static const bool ENABLE_PERFORMANCE_METRICS = true;
  
  // Voice Configuration
  static const String DEFAULT_VOICE_NAME = 'com.apple.ttsbundle.Samantha-compact';
  static const String DEFAULT_VOICE_LOCALE = 'en-US';
  static const double DEFAULT_SPEECH_RATE = 0.5;
  static const double DEFAULT_VOLUME = 0.9;
  
  // Available Voice Options (iOS/macOS)
  static const Map<String, Map<String, String>> AVAILABLE_VOICES = {
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