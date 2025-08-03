import 'package:flutter/material.dart';

import '../../models/chat_message.dart';
import '../../utils/theme.dart';
import 'image_message_widget.dart';

class MessageBubbleWidget extends StatelessWidget {
  final ChatMessage message;

  const MessageBubbleWidget({
    super.key,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    final isUser = message.isFromUser;
    
    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.8,
        ),
        child: Column(
          crossAxisAlignment: isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            // Message bubble
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: isUser 
                  ? AppTheme.userMessageDecoration
                  : AppTheme.aiMessageDecoration,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [

                  Flexible(
                    child: message.imageText != null
                        ? ImageMessageWidget(
                            imagePath: message.content,
                            imageText: message.imageText,
                          )
                        : Text(
                            message.content,
                            style: TextStyle(
                              color: isUser ? Colors.white : AppTheme.darkOnSurface,
                            ),
                          ),
                  ),

                ],
              ),
            ),
            
            // Timestamp
            Padding(
              padding: EdgeInsets.only(
                top: 4,
                left: isUser ? 0 : 12,
                right: isUser ? 12 : 0,
              ),
              child: Text(
                _formatTime(message.timestamp),
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppTheme.darkOnSurfaceVariant,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }



  String _formatTime(DateTime time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }
} 