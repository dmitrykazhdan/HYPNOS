import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../config/app_config.dart';

class MacApiGemmaService {
  static const String _baseUrl = AppConfig.MAC_SERVER_URL; // Default Mac server URL
  String _serverUrl;
  bool _isConnected = false;
  String _currentMode = 'Quality';

  MacApiGemmaService({String? serverUrl}) : _serverUrl = serverUrl ?? _baseUrl;

  bool get isModelLoaded => _isConnected;
  String get currentMode => _currentMode;
  String get serverUrl => _serverUrl;

  Future<void> loadModel() async {
    try {
      print('MacApi Gemma: Checking server connection...');
      
      // Test connection to the Mac server
      final response = await http.get(
        Uri.parse('$_serverUrl/health'),
        headers: {'Content-Type': 'application/json'},
      ).timeout(Duration(seconds: AppConfig.REQUEST_TIMEOUT_SECONDS));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final textModelLoaded = data['text_model_loaded'] ?? false;
        final visionModelLoaded = data['vision_model_loaded'] ?? false;
        
        _isConnected = textModelLoaded; // We need at least the text model
        
        if (_isConnected) {
          print('MacApi Gemma: Connected to Mac server successfully!');
          print('MacApi Gemma: Text model loaded: $textModelLoaded');
          print('MacApi Gemma: Vision model loaded: $visionModelLoaded');
        } else {
          print('MacApi Gemma: Server connected but models not loaded');
        }
      } else {
        throw Exception('Server responded with status: ${response.statusCode}');
      }
    } catch (e) {
      print('MacApi Gemma: Error connecting to Mac server: $e');
      _isConnected = false;
      throw Exception('Failed to connect to Mac server: $e');
    }
  }

  Future<String> processInput(String input) async {
    if (!_isConnected) {
      return 'Not connected to Mac server. Please check your connection and try again.';
    }

    try {
      print('MacApi Gemma: Sending request to Mac server: $input');
      
      final response = await http.post(
        Uri.parse('$_serverUrl/chat'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'message': input,
          'history': [], // For now, we'll send without history
        }),
      ).timeout(Duration(seconds: AppConfig.REQUEST_TIMEOUT_SECONDS));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final aiResponse = data['response'] ?? 'No response from server';
        print('MacApi Gemma: Received response: $aiResponse');
        return aiResponse;
      } else {
        final errorData = json.decode(response.body);
        throw Exception(errorData['error'] ?? 'Server error: ${response.statusCode}');
      }
    } catch (e) {
      print('MacApi Gemma: Error during API call: $e');
      return 'Sorry, I encountered an error while communicating with the Mac server. Please check your connection and try again.';
    }
  }

  Future<String> processImage(String imagePath, {String? userMessage}) async {
    if (!_isConnected) {
      return 'Not connected to Mac server. Please check your connection and try again.';
    }

    try {
      print('MacApi Gemma: Processing image via Mac server: $imagePath');
      print('MacApi Gemma: User message: $userMessage');
      
      // Read the image file
      final imageFile = File(imagePath);
      if (!await imageFile.exists()) {
        throw Exception('Image file not found: $imagePath');
      }

      // Try multimodal endpoint first
      try {
        final request = http.MultipartRequest(
          'POST',
          Uri.parse('$_serverUrl/process_image_multimodal'),
        );

        // Add the image file
        final imageStream = http.ByteStream(imageFile.openRead());
        final imageLength = await imageFile.length();
        
        final multipartFile = http.MultipartFile(
          'image',
          imageStream,
          imageLength,
          filename: imageFile.path.split('/').last,
        );
        
        request.files.add(multipartFile);
        
        // Add user message or default message
        final message = userMessage?.trim().isNotEmpty == true 
            ? userMessage!.trim()
            : 'What do you see in this image?';
        request.fields['message'] = message;

        // Send the request
        final streamedResponse = await request.send().timeout(
          Duration(seconds: AppConfig.REQUEST_TIMEOUT_SECONDS),
        );
        
        final response = await http.Response.fromStream(streamedResponse);

        if (response.statusCode == 200) {
          final data = json.decode(response.body);
          final aiResponse = data['response'] ?? 'No response from server';
          print('MacApi Gemma: Multimodal response: $aiResponse');
          return aiResponse;
        } else if (response.statusCode == 307) {
          // Fallback to regular endpoint
          throw Exception('Multimodal not available, falling back to text model');
        } else {
          final errorData = json.decode(response.body);
          throw Exception(errorData['error'] ?? 'Server error: ${response.statusCode}');
        }
      } catch (multimodalError) {
        print('MacApi Gemma: Multimodal failed, trying text model: $multimodalError');
        
        // Fallback to text-only endpoint
        final request = http.MultipartRequest(
          'POST',
          Uri.parse('$_serverUrl/process_image'),
        );

        // Add the image file again
        final imageStream = http.ByteStream(imageFile.openRead());
        final imageLength = await imageFile.length();
        
        final multipartFile = http.MultipartFile(
          'image',
          imageStream,
          imageLength,
          filename: imageFile.path.split('/').last,
        );
        
        request.files.add(multipartFile);
        
        // Add user message or default message
        final message = userMessage?.trim().isNotEmpty == true 
            ? userMessage!.trim()
            : 'Please analyze this image and describe what you see.';
        request.fields['message'] = message;

        // Send the request
        final streamedResponse = await request.send().timeout(
          Duration(seconds: AppConfig.REQUEST_TIMEOUT_SECONDS),
        );
        
        final response = await http.Response.fromStream(streamedResponse);

        if (response.statusCode == 200) {
          final data = json.decode(response.body);
          final aiResponse = data['response'] ?? 'No response from server';
          print('MacApi Gemma: Text model response: $aiResponse');
          return aiResponse;
        } else {
          final errorData = json.decode(response.body);
          throw Exception(errorData['error'] ?? 'Server error: ${response.statusCode}');
        }
      }
    } catch (e) {
      print('MacApi Gemma: Error during image processing: $e');
      return 'Sorry, I encountered an error while processing the image. Please check your connection and try again.';
    }
  }

  void switchToFastMode() {
    _currentMode = 'Fast';
    // In a real implementation, you might send a request to switch model parameters
  }

  void switchToQualityMode() {
    _currentMode = 'Quality';
    // In a real implementation, you might send a request to switch model parameters
  }

  String getModelStatus() {
    if (_isConnected) {
      return 'Mac Server $_currentMode mode - Ready';
    } else {
      return 'Mac Server - Not Connected';
    }
  }

  Map<String, dynamic> getPerformanceMetrics() {
    return {
      'model_loaded': _isConnected,
      'current_mode': _currentMode,
      'framework': 'HTTP API',
      'platform': 'Flutter (iOS/Android)',
      'server_url': _serverUrl,
    };
  }

  Future<bool> testConnection() async {
    try {
      final response = await http.get(
        Uri.parse('$_serverUrl/health'),
        headers: {'Content-Type': 'application/json'},
      ).timeout(Duration(seconds: 5)); // Keep short timeout for health check

      return response.statusCode == 200;
    } catch (e) {
      print('MacApi Gemma: Connection test failed: $e');
      return false;
    }
  }

  void updateServerUrl(String newUrl) {
    _serverUrl = newUrl;
    _isConnected = false; // Reset connection status
  }

  void dispose() {
    // No cleanup needed for HTTP client
  }
} 