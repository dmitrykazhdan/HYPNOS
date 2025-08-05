import 'package:flutter/material.dart';
import 'dart:io';

import '../models/chat_message.dart';
import '../models/conversation.dart';
import '../services/api_service.dart';
import '../services/speech_service.dart';
import '../services/conversation_service.dart';


class HypnosChatProvider extends ChangeNotifier {
  // Core services
  final ApiService _apiService = ApiService();
  final SpeechService _speechService = SpeechService();
  final ConversationService _conversationService = ConversationService();
  final TextEditingController textController = TextEditingController();

  // State
  bool _isConnected = false;
  bool _isProcessing = false;
  bool _isRecording = false;
  bool _voiceEnabled = true;
  String _status = 'Connecting...';
  
  // Chat data
  final List<ChatMessage> _messages = [];
  final List<Conversation> _conversations = [];
  String? _currentConversationId;

  // Getters
  bool get isConnected => _isConnected;
  bool get isProcessing => _isProcessing;
  bool get isRecording => _isRecording;
  bool get isSpeaking => _speechService.isSpeaking;
  bool get voiceEnabled => _voiceEnabled;
  String get status => _status;
  List<ChatMessage> get messages => _messages;
  List<Conversation> get conversations => _conversations;

  HypnosChatProvider() {
    // Add listener to text controller to trigger UI updates
    textController.addListener(() {
      notifyListeners();
    });
    _initialize();
  }

  Future<void> _initialize() async {
    await _initializeSpeech();
    await _loadSettings();
    await _loadConversations();
    await _loadCurrentConversation();
    await _connectToServer();
  }

  Future<void> _initializeSpeech() async {
    final available = await _speechService.initialize();
    if (available) {
      _status = 'Ready';
    } else {
      _status = 'Speech not available';
    }
    notifyListeners();
  }

  Future<void> _connectToServer() async {
    try {
      _status = 'Checking server...';
      notifyListeners();
      
      final health = await _apiService.checkHealth();
      _isConnected = health['status'] == 'healthy';
      _status = _isConnected ? 'Connected' : 'Server not ready';
    } catch (e) {
      _isConnected = false;
      _status = 'Connection failed: $e';
    }
    notifyListeners();
  }

  Future<void> _loadSettings() async {
    _voiceEnabled = await _conversationService.loadVoiceEnabled();
  }

  Future<void> _loadConversations() async {
    _conversations.clear();
    _conversations.addAll(await _conversationService.loadConversations());
  }

  Future<void> _loadCurrentConversation() async {
    final currentId = await _conversationService.loadCurrentConversationId();
    
    if (currentId != null) {
      // Find the current conversation
      final conversation = _conversations.firstWhere(
        (conv) => conv.id == currentId,
        orElse: () => Conversation.create(title: 'New Chat', messages: []),
      );
      
      _messages.clear();
      _messages.addAll(conversation.messages);
      _currentConversationId = currentId;
    }
  }

  Future<void> _updateCurrentConversation() async {
    if (_messages.isNotEmpty) {
      final title = _conversationService.generateConversationTitle(_messages);
      
      if (_currentConversationId != null) {
        // Update existing conversation
        final index = _conversations.indexWhere((conv) => conv.id == _currentConversationId);
        if (index != -1) {
          _conversations[index] = Conversation.create(
            id: _currentConversationId!,
            title: title,
            messages: List.from(_messages),
            timestamp: _conversations[index].timestamp,
          );
        }
      } else {
        // Create new conversation
        final newId = DateTime.now().millisecondsSinceEpoch.toString();
        _currentConversationId = newId;
        _conversations.add(Conversation.create(
          id: newId,
          title: title,
          messages: List.from(_messages),
          timestamp: DateTime.now(),
        ));
      }
      
      await _conversationService.saveConversations(_conversations);
      await _conversationService.saveCurrentConversationId(_currentConversationId);
    }
  }

  // Voice toggle
  Future<void> toggleVoice() async {
    _voiceEnabled = !_voiceEnabled;
    await _conversationService.saveVoiceEnabled(_voiceEnabled);
    notifyListeners();
  }

  // Start voice recording
  Future<void> startRecording() async {
    if (!_isConnected || _isRecording) return;

    try {
      await _speechService.startListening(
        onResult: (transcription) {
          if (transcription.isNotEmpty) {
            textController.text = transcription;
            notifyListeners();
          }
        },
        onFinalResult: () {
          stopRecording();
        },
      );
      _isRecording = true;
      _status = 'Listening...';
      notifyListeners();
    } catch (e) {
      _status = 'Recording failed';
      notifyListeners();
    }
  }

  // Stop voice recording
  Future<void> stopRecording() async {
    await _speechService.stopListening();
    _isRecording = false;
    _status = 'Ready';
    notifyListeners();
  }

  // Send message (text or voice)
  Future<void> sendMessage(String text) async {
    final trimmedText = text.trim();
    if (trimmedText.isEmpty) return;

    _isProcessing = true;
    _status = 'Thinking...';
    notifyListeners();

    try {
      // Add user message
      _messages.add(ChatMessage.create(
        content: trimmedText,
        isFromUser: true,
      ));
      await _updateCurrentConversation();
      notifyListeners();

      // Convert messages to API format
      final history = _messages.map((msg) => {
        'role': msg.isFromUser ? 'user' : 'assistant',
        'content': msg.content,
      }).toList();

      // Get AI response from API
      final response = await _apiService.sendChatMessage(
        message: trimmedText,
        history: history,
      );
      
      final aiResponse = response['response'] as String;
      
      // Add AI response
      _messages.add(ChatMessage.create(
        content: aiResponse,
        isFromUser: false,
      ));
      await _updateCurrentConversation();
      notifyListeners();

      // Speak if enabled
      if (_voiceEnabled) {
        await _speechService.speak(aiResponse);
      }

      _status = 'Ready';
    } catch (e) {
      _status = 'Error: $e';
    }

    _isProcessing = false;
    notifyListeners();
  }

  // Process image
  Future<void> processImage(String imagePath, {String? userMessage}) async {
    _isProcessing = true;
    _status = 'Processing image...';
    notifyListeners();

    try {
      // Add user image message
      _messages.add(ChatMessage.create(
        content: imagePath,
        isFromUser: true,
        imageText: userMessage,
      ));
      await _updateCurrentConversation();
      notifyListeners();

      // Convert messages to API format
      final history = _messages.map((msg) => {
        'role': msg.isFromUser ? 'user' : 'assistant',
        'content': msg.content,
      }).toList();

      // Get AI response from API
      final response = await _apiService.processImage(
        imageFile: File(imagePath),
        message: userMessage ?? 'What do you see in this image?',
        history: history,
      );
      
      final aiResponse = response['response'] as String;
      
      // Add AI response
      _messages.add(ChatMessage.create(
        content: aiResponse,
        isFromUser: false,
      ));
      await _updateCurrentConversation();
      notifyListeners();

      // Speak if enabled
      if (_voiceEnabled) {
        await _speechService.speak(aiResponse);
      }

      _status = 'Ready';
    } catch (e) {
      _status = 'Error: $e';
    }

    _isProcessing = false;
    notifyListeners();
  }

  // Load conversation
  Future<void> loadConversation(Conversation conversation) async {
    _messages.clear();
    _messages.addAll(conversation.messages);
    _currentConversationId = conversation.id;
    await _conversationService.saveCurrentConversationId(_currentConversationId);
    notifyListeners();
  }

  // Delete conversation
  Future<void> deleteConversation(Conversation conversation) async {
    _conversations.remove(conversation);
    await _conversationService.saveConversations(_conversations);
    
    // If we deleted the current conversation, clear it
    if (_currentConversationId == conversation.id) {
      _messages.clear();
      _currentConversationId = null;
      await _conversationService.saveCurrentConversationId(null);
    }
    notifyListeners();
  }

  // Clear current chat
  Future<void> clearChat() async {
    _messages.clear();
    _currentConversationId = null;
    await _conversationService.saveCurrentConversationId(null);
    notifyListeners();
  }

  // Test connection
  Future<bool> testConnection() async {
    try {
      final health = await _apiService.checkHealth();
      return health['status'] == 'healthy';
    } catch (e) {
      return false;
    }
  }

  @override
  void dispose() {
    _speechService.dispose();
    textController.dispose();
    super.dispose();
  }
} 