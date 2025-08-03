import 'package:flutter/material.dart';

import '../../utils/theme.dart';
import '../sphere/pulsating_sphere_widget.dart';

class EmptyStateWidget extends StatelessWidget {
  const EmptyStateWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Pulsating sphere - always visible in empty state
          const PulsatingSphereWidget(),
          const SizedBox(height: 40),
          
          Text(
            'HYPNOS',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: AppTheme.darkOnSurface,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          
          Text(
            'Tap the sphere to start talking',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppTheme.darkOnSurfaceVariant,
            ),
          ),
          const SizedBox(height: 8),
          
          Text(
            'Or use text input',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: AppTheme.darkOnSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
} 