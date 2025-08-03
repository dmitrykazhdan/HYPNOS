import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/hypnos_chat_provider.dart';
import 'empty_state_widget.dart';
import 'chat_messages_widget.dart';
import '../sphere/floating_sphere_widget.dart';

class ChatContentWidget extends StatelessWidget {
  const ChatContentWidget({super.key});

  @override
  Widget build(BuildContext context) {
            return Consumer<HypnosChatProvider>(
      builder: (context, provider, child) {
        if (provider.messages.isEmpty) {
          return const EmptyStateWidget();
        }
        
        return Stack(
          children: [
            const ChatMessagesWidget(),
            // Floating pulsating sphere when there are messages (top right)
            const Positioned(
              top: 20,
              right: 20,
              child: FloatingSphereWidget(),
            ),
          ],
        );
      },
    );
  }
} 