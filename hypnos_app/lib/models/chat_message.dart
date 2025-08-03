class ChatMessage {
  final String content;
  final bool isFromUser;
  final DateTime timestamp;
  final String? imageText;

  ChatMessage({
    required this.content,
    required this.isFromUser,
    required this.timestamp,
    this.imageText,
  });

  factory ChatMessage.create({
    required String content,
    required bool isFromUser,
    String? imageText,
  }) {
    return ChatMessage(
      content: content,
      isFromUser: isFromUser,
      timestamp: DateTime.now(),
      imageText: imageText,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'content': content,
      'isFromUser': isFromUser,
      'timestamp': timestamp.toIso8601String(),
      'imageText': imageText,
    };
  }

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      content: json['content'],
      isFromUser: json['isFromUser'],
      timestamp: DateTime.parse(json['timestamp']),
      imageText: json['imageText'],
    );
  }
} 