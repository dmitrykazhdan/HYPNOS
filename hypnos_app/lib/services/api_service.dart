import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../config/app_config.dart';

class ApiService {
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;
  ApiService._internal();

  final String _baseUrl = AppConfig.baseUrl;
  final String _apiKey = AppConfig.apiKey;

  // Headers with authentication
  Map<String, String> get _headers => {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer $_apiKey',
    'User-Agent': 'HypnosApp/${AppConfig.appVersion}',
  };

  /// Send a chat message to the backend
  Future<Map<String, dynamic>> sendChatMessage({
    required String message,
    required List<Map<String, String>> history,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/chat'),
        headers: _headers,
        body: jsonEncode({
          'message': message,
          'history': history,
        }),
      ).timeout(Duration(seconds: AppConfig.requestTimeoutSeconds));

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else if (response.statusCode == 401) {
        throw Exception('Authentication failed. Please check your API key.');
      } else if (response.statusCode == 429) {
        throw Exception('Rate limit exceeded. Please try again later.');
      } else {
        throw Exception('Server error: ${response.statusCode}');
      }
    } on SocketException {
      throw Exception('Network error. Please check your internet connection.');
    } on FormatException {
      throw Exception('Invalid response from server.');
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }

  /// Process an image with text
  Future<Map<String, dynamic>> processImage({
    required File imageFile,
    required String message,
    required List<Map<String, String>> history,
  }) async {
    try {
      final request = http.MultipartRequest(
        'POST',
        Uri.parse('$_baseUrl/process_image'),
      );

      // Add headers
      request.headers.addAll({
        'Authorization': 'Bearer $_apiKey',
        'User-Agent': 'HypnosApp/${AppConfig.appVersion}',
      });

      // Add image file
      request.files.add(
        await http.MultipartFile.fromPath(
          'image',
          imageFile.path,
        ),
      );

      // Add text data
      request.fields['message'] = message;
      request.fields['history'] = jsonEncode(history);

      final streamedResponse = await request.send()
          .timeout(Duration(seconds: AppConfig.requestTimeoutSeconds));
      
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else if (response.statusCode == 401) {
        throw Exception('Authentication failed. Please check your API key.');
      } else if (response.statusCode == 429) {
        throw Exception('Rate limit exceeded. Please try again later.');
      } else {
        throw Exception('Server error: ${response.statusCode}');
      }
    } on SocketException {
      throw Exception('Network error. Please check your internet connection.');
    } on FormatException {
      throw Exception('Invalid response from server.');
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }

  /// Check server health
  Future<Map<String, dynamic>> checkHealth() async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/health'),
        headers: {
          'Authorization': 'Bearer $_apiKey',
          'User-Agent': 'HypnosApp/${AppConfig.appVersion}',
        },
      ).timeout(Duration(seconds: 10));

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Server health check failed: ${response.statusCode}');
      }
    } on SocketException {
      throw Exception('Cannot connect to server. Please check your internet connection.');
    } catch (e) {
      throw Exception('Health check error: $e');
    }
  }

  /// Reset conversation
  Future<Map<String, dynamic>> resetConversation() async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/reset'),
        headers: _headers,
      ).timeout(Duration(seconds: AppConfig.requestTimeoutSeconds));

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to reset conversation: ${response.statusCode}');
      }
    } on SocketException {
      throw Exception('Network error. Please check your internet connection.');
    } catch (e) {
      throw Exception('Reset error: $e');
    }
  }
} 