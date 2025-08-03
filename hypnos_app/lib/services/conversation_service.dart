import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/chat_message.dart';
import '../models/conversation.dart';

class ConversationService {
  static const String _conversationsKey = 'hypnos_conversations';
  static const String _currentConversationKey = 'hypnos_current_conversation';
  static const String _voiceKey = 'voice_enabled';

  Future<bool> loadVoiceEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_voiceKey) ?? true;
  }

  Future<void> saveVoiceEnabled(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_voiceKey, enabled);
  }

  Future<List<Conversation>> loadConversations() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final conversationsJson = prefs.getString(_conversationsKey);
      if (conversationsJson != null) {
        final List<dynamic> data = jsonDecode(conversationsJson);
        return data.map((json) => Conversation.fromJson(json)).toList();
      }
    } catch (e) {
      debugPrint('Error loading conversations: $e');
    }
    return [];
  }

  Future<void> saveConversations(List<Conversation> conversations) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final conversationsJson = jsonEncode(conversations.map((conv) => conv.toJson()).toList());
      await prefs.setString(_conversationsKey, conversationsJson);
    } catch (e) {
      debugPrint('Error saving conversations: $e');
    }
  }

  Future<String?> loadCurrentConversationId() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString(_currentConversationKey);
    } catch (e) {
      debugPrint('Error loading current conversation ID: $e');
      return null;
    }
  }

  Future<void> saveCurrentConversationId(String? conversationId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      if (conversationId != null) {
        await prefs.setString(_currentConversationKey, conversationId);
      } else {
        await prefs.remove(_currentConversationKey);
      }
    } catch (e) {
      debugPrint('Error saving current conversation ID: $e');
    }
  }

  String generateConversationTitle(List<ChatMessage> messages) {
    if (messages.isEmpty) return 'New Chat';
    
    // Find first user message
    final firstUserMessage = messages.firstWhere(
      (msg) => msg.isFromUser,
      orElse: () => messages.first,
    );
    
    final content = firstUserMessage.content;
    if (content.length <= 30) return content;
    return '${content.substring(0, 30)}...';
  }
} 