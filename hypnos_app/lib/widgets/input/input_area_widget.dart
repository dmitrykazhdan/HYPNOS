import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';

import '../../providers/hypnos_chat_provider.dart';
import '../../utils/theme.dart';
import '../dialogs/image_text_dialog.dart';

class InputAreaWidget extends StatelessWidget {
  final FocusNode focusNode;

  const InputAreaWidget({
    super.key,
    required this.focusNode,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: AppTheme.darkSurface,
        border: Border(
          top: BorderSide(
            color: AppTheme.darkOnSurfaceVariant.withOpacity(0.2),
            width: 0.5,
          ),
        ),
      ),
      child: _buildWhatsAppStyleInput(context, context.read<HypnosChatProvider>()),
    );
  }

  Widget _buildWhatsAppStyleInput(BuildContext context, HypnosChatProvider provider) {
    return Consumer<HypnosChatProvider>(
      builder: (context, provider, child) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
          decoration: BoxDecoration(
            color: AppTheme.darkSurface,
            border: Border(
              top: BorderSide(
                color: AppTheme.darkOnSurfaceVariant.withOpacity(0.2),
                width: 0.5,
              ),
            ),
          ),
          child: Row(
            children: [
              // Camera button (far left, smaller)
              GestureDetector(
                onTap: () => _openCamera(context),
                child: Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: AppTheme.primaryOrange.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Icon(
                    Icons.camera_alt,
                    color: AppTheme.primaryOrange,
                    size: 18,
                  ),
                ),
              ),
              const SizedBox(width: 4),
              
              // Text input field (expanded)
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: AppTheme.darkSurfaceVariant.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(
                      color: AppTheme.darkOnSurfaceVariant.withOpacity(0.2),
                      width: 1,
                    ),
                  ),
                  child: TextField(
                    controller: provider.textController,
                    focusNode: focusNode,
                    style: TextStyle(
                      color: AppTheme.darkOnSurface,
                      fontSize: 16,
                    ),
                    decoration: InputDecoration(
                      hintText: 'Type a message...',
                      hintStyle: TextStyle(
                        color: AppTheme.darkOnSurfaceVariant,
                        fontSize: 16,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      border: InputBorder.none,
                    ),
                    onSubmitted: (text) {
                      if (text.trim().isNotEmpty) {
                        _sendMessage(provider, text);
                      }
                    },
                  ),
                ),
              ),
              const SizedBox(width: 4),
              
              // Send button (far right, smaller)
              GestureDetector(
                onTap: () {
                  if (provider.textController.text.trim().isNotEmpty) {
                    _sendMessage(provider, provider.textController.text);
                  }
                },
                child: Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: provider.textController.text.trim().isNotEmpty
                        ? AppTheme.primaryOrange
                        : AppTheme.primaryOrange.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Icon(
                    Icons.send,
                    color: provider.textController.text.trim().isNotEmpty
                        ? Colors.white
                        : AppTheme.primaryOrange.withOpacity(0.5),
                    size: 18,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _sendMessage(HypnosChatProvider provider, String text) {
    if (text.trim().isNotEmpty) {
      // Stop recording if active
      if (provider.isRecording) {
        provider.stopRecording();
      }
      
      // Send the message
      provider.sendMessage(text);
      
      // Clear the text field (listener will handle UI refresh)
      provider.textController.clear();
      
      // Unfocus to hide keyboard
      focusNode.unfocus();
    }
  }

  Future<void> _openCamera(BuildContext context) async {
    final ImagePicker picker = ImagePicker();
    final XFile? photo = await picker.pickImage(source: ImageSource.camera);
    
    if (photo != null) {
      // Show dialog for optional text input
      final String? userMessage = await ImageTextDialog.show(context);
      final provider = context.read<HypnosChatProvider>();
      await provider.processImage(photo.path, userMessage: userMessage);
    }
  }
} 