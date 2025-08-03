import 'package:flutter/material.dart';

import '../../providers/hypnos_chat_provider.dart';
import '../../utils/theme.dart';

class ClearHistoryDialog {
  static void show(BuildContext context, HypnosChatProvider provider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.darkSurface,
        title: Text(
          'Clear Conversation',
          style: TextStyle(color: AppTheme.darkOnSurface),
        ),
        content: Text(
          'Are you sure you want to clear all conversation history?',
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
              backgroundColor: Colors.red,
            ),
            child: const Text('Clear'),
          ),
        ],
      ),
    );
  }
} 