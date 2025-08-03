import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:math';

import '../../providers/hypnos_chat_provider.dart';
import 'message_bubble_widget.dart';

class ChatMessagesWidget extends StatelessWidget {
  const ChatMessagesWidget({super.key});

  @override
  Widget build(BuildContext context) {
            return Consumer<HypnosChatProvider>(
      builder: (context, provider, child) {
        print('Building chat messages. Count: ${provider.messages.length}');
        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: provider.messages.length,
          itemBuilder: (context, index) {
            final message = provider.messages[index];
            print('Building message $index: ${message.content.substring(0, min(50, message.content.length))}...');
            return MessageBubbleWidget(message: message);
          },
        );
      },
    );
  }
} 