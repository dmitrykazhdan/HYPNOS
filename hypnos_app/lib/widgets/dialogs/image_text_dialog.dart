import 'package:flutter/material.dart';

import '../../utils/theme.dart';

class ImageTextDialog {
  static Future<String?> show(BuildContext context) async {
    final TextEditingController textController = TextEditingController();
    
    return showDialog<String>(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: AppTheme.darkSurface,
        insetPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 40),
        child: Container(
          width: MediaQuery.of(context).size.width * 0.95,
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Add a message (optional)',
                style: TextStyle(
                  color: AppTheme.darkOnSurface,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: textController,
                style: TextStyle(color: AppTheme.darkOnSurface),
                decoration: InputDecoration(
                  hintText: 'Describe what you want to know about the image...',
                  hintStyle: TextStyle(color: AppTheme.darkOnSurfaceVariant),
                  filled: true,
                  fillColor: AppTheme.darkSurfaceVariant.withOpacity(0.3),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.all(16),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text(
                      'Cancel',
                      style: TextStyle(color: AppTheme.darkOnSurfaceVariant),
                    ),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context, textController.text.trim()),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryOrange,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text('Send'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
} 