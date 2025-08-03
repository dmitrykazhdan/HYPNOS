import 'package:flutter/material.dart';

import '../../providers/hypnos_chat_provider.dart';
import '../../utils/theme.dart';

class NewChatDialog {
  static void show(BuildContext context, HypnosChatProvider provider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.darkSurface,
        title: Text(
          'Start New Chat',
          style: TextStyle(color: AppTheme.darkOnSurface),
        ),
        content: Text(
          'Are you sure you want to start a new chat? The current conversation will be cleared.',
          style: TextStyle(color: AppTheme.darkOnSurfaceVariant),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: TextStyle(color: AppTheme.darkOnSurfaceVariant),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              provider.clearChat();
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryOrange,
            ),
            child: const Text('New Chat'),
          ),
        ],
      ),
    );
  }
} 