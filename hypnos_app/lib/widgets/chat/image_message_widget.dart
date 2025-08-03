import 'package:flutter/material.dart';
import 'dart:io';

import '../../utils/theme.dart';

class ImageMessageWidget extends StatelessWidget {
  final String imagePath;
  final String? imageText;

  const ImageMessageWidget({
    super.key,
    required this.imagePath,
    this.imageText,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Image
        Container(
          constraints: const BoxConstraints(
            maxWidth: 200,
            maxHeight: 200,
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.file(
              File(imagePath),
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  width: 200,
                  height: 150,
                  decoration: BoxDecoration(
                    color: AppTheme.darkSurfaceVariant,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.image_not_supported,
                    size: 50,
                    color: AppTheme.darkOnSurfaceVariant,
                  ),
                );
              },
            ),
          ),
        ),
        // Text (if provided)
        if (imageText != null && imageText!.isNotEmpty) ...[
          const SizedBox(height: 8),
          Text(
            imageText!,
            style: TextStyle(
              color: AppTheme.darkOnSurface,
              fontSize: 14,
            ),
          ),
        ],
      ],
    );
  }
} 