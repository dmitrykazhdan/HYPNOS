import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/hypnos_chat_provider.dart';
import '../../screens/settings_screen.dart';
import '../../utils/theme.dart';
import '../sphere/status_sphere_widget.dart';
import '../dialogs/new_chat_dialog.dart';
import '../dialogs/conversation_history_dialog.dart';
import '../dialogs/clear_history_dialog.dart';

class HypnosAppBar extends StatelessWidget {
  const HypnosAppBar({super.key});

  @override
  Widget build(BuildContext context) {
            return Consumer<HypnosChatProvider>(
      builder: (context, provider, child) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: AppTheme.darkSurface,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.3),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              // Animated status sphere
              const StatusSphereWidget(),
              const SizedBox(width: 12),
              
              // Title and status
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'HYPNOS',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppTheme.darkOnSurface,
                      ),
                    ),
                                         Text(
                       provider.status,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: provider.isProcessing 
                            ? AppTheme.primaryOrange 
                            : AppTheme.darkOnSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              
              // Action buttons in header
              Row(
                children: [
                  _buildActionButton(
                    context,
                    Icons.add,
                    () => _showNewChatDialog(context, provider),
                  ),
                  const SizedBox(width: 8),
                  _buildActionButton(
                    context,
                    Icons.history,
                    () => _showConversationHistoryDialog(context, provider),
                  ),
                  const SizedBox(width: 8),
                  _buildActionButton(
                    context,
                    Icons.clear_all,
                    () => _showClearHistoryDialog(context, provider),
                  ),
                  const SizedBox(width: 8),
                  _buildActionButton(
                    context,
                    Icons.settings,
                    () => _navigateToSettings(context),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildActionButton(
    BuildContext context,
    IconData icon,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: AppTheme.darkSurfaceVariant,
          border: Border.all(
            color: AppTheme.darkOnSurfaceVariant,
            width: 1,
          ),
        ),
        child: Icon(
          icon,
          color: AppTheme.darkOnSurfaceVariant,
          size: 16,
        ),
      ),
    );
  }

  void _showNewChatDialog(BuildContext context, HypnosChatProvider provider) {
    NewChatDialog.show(context, provider);
  }

  void _showConversationHistoryDialog(BuildContext context, HypnosChatProvider provider) {
    ConversationHistoryDialog.show(context, provider);
  }

  void _showClearHistoryDialog(BuildContext context, HypnosChatProvider provider) {
    ClearHistoryDialog.show(context, provider);
  }

  void _navigateToSettings(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const SettingsScreen(),
      ),
    );
  }
} 