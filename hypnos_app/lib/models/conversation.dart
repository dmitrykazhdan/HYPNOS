import 'chat_message.dart';

class Conversation {
  final String id;
  final String title;
  final List<ChatMessage> messages;
  final DateTime timestamp;

  Conversation({
    required this.id,
    required this.title,
    required this.messages,
    required this.timestamp,
  });

  factory Conversation.create({
    String? id,
    required String title,
    required List<ChatMessage> messages,
    DateTime? timestamp,
  }) {
    return Conversation(
      id: id ?? DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      messages: messages,
      timestamp: timestamp ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'messages': messages.map((msg) => msg.toJson()).toList(),
      'timestamp': timestamp.toIso8601String(),
    };
  }

  factory Conversation.fromJson(Map<String, dynamic> json) {
    return Conversation(
      id: json['id'],
      title: json['title'],
      messages: (json['messages'] as List)
          .map((msgJson) => ChatMessage.fromJson(msgJson))
          .toList(),
      timestamp: DateTime.parse(json['timestamp']),
    );
  }
} 