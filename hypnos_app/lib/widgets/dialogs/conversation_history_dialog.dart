import 'package:flutter/material.dart';

import '../../providers/hypnos_chat_provider.dart';
import '../../utils/theme.dart';

class ConversationHistoryDialog {
  static void show(BuildContext context, HypnosChatProvider provider) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: AppTheme.darkSurface,
        insetPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 40),
        child: Container(
          width: MediaQuery.of(context).size.width * 0.95,
          height: MediaQuery.of(context).size.height * 0.8,
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Previous Conversations',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: AppTheme.darkOnSurface,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: provider.conversations.isEmpty
                    ? Center(
                        child: Text(
                          'No previous conversations yet',
                          style: TextStyle(color: AppTheme.darkOnSurfaceVariant),
                        ),
                      )
                    : ListView.builder(
                        itemCount: provider.conversations.length,
                        itemBuilder: (context, index) {
                          final conversation = provider.conversations[index];
                          return Container(
                            margin: const EdgeInsets.only(bottom: 12),
                            decoration: BoxDecoration(
                              color: AppTheme.darkSurfaceVariant.withValues(alpha: 0.3),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                borderRadius: BorderRadius.circular(12),
                                onTap: () {
                                  provider.loadConversation(conversation);
                                  Navigator.pop(context);
                                },
                                child: Dismissible(
                                  key: Key(conversation.id),
                                  direction: DismissDirection.endToStart,
                                  background: Container(
                                    alignment: Alignment.centerRight,
                                    padding: const EdgeInsets.only(right: 20),
                                    decoration: BoxDecoration(
                                      color: Colors.red,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: const Icon(
                                      Icons.delete,
                                      color: Colors.white,
                                      size: 24,
                                    ),
                                  ),
                                  confirmDismiss: (direction) async {
                                    return await showDialog<bool>(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                        backgroundColor: AppTheme.darkSurface,
                                        title: Text(
                                          'Delete Conversation',
                                          style: TextStyle(color: AppTheme.darkOnSurface),
                                        ),
                                        content: Text(
                                          'Are you sure you want to delete this conversation?',
                                          style: TextStyle(color: AppTheme.darkOnSurfaceVariant),
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed: () => Navigator.pop(context, false),
                                            child: Text(
                                              'Cancel',
                                              style: TextStyle(color: AppTheme.darkOnSurfaceVariant),
                                            ),
                                          ),
                                          ElevatedButton(
                                            onPressed: () => Navigator.pop(context, true),
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors.red,
                                            ),
                                            child: const Text('Delete'),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                  onDismissed: (direction) {
                                    provider.deleteConversation(conversation);
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(16),
                                    child: Row(
                                      children: [
                                        Container(
                                          width: 48,
                                          height: 48,
                                          decoration: BoxDecoration(
                                            color: AppTheme.primaryOrange.withValues(alpha: 0.2),
                                            borderRadius: BorderRadius.circular(12),
                                          ),
                                          child: Icon(
                                            Icons.chat_bubble_outline,
                                            color: AppTheme.primaryOrange,
                                            size: 24,
                                          ),
                                        ),
                                        const SizedBox(width: 16),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                conversation.title,
                                                style: TextStyle(
                                                  color: AppTheme.darkOnSurface,
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 16,
                                                ),
                                              ),
                                              const SizedBox(height: 4),
                                              Text(
                                                '${conversation.messages.length} messages • ${_formatTime(conversation.timestamp)}',
                                                style: TextStyle(
                                                  color: AppTheme.darkOnSurfaceVariant,
                                                  fontSize: 14,
                                                ),
                                              ),
                                              if (conversation.messages.isNotEmpty) ...[
                                                const SizedBox(height: 8),
                                                Text(
                                                  conversation.messages.first.content,
                                                  maxLines: 2,
                                                  overflow: TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                    color: AppTheme.darkOnSurfaceVariant,
                                                    fontSize: 14,
                                                  ),
                                                ),
                                              ],
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text(
                      'Close',
                      style: TextStyle(color: AppTheme.darkOnSurfaceVariant),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  static String _formatTime(DateTime time) {
    final now = DateTime.now();
    final difference = now.difference(time);
    
    if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }
} 