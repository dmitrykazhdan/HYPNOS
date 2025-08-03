import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/hypnos_chat_provider.dart';
import '../../utils/theme.dart';

class StatusSphereWidget extends StatefulWidget {
  const StatusSphereWidget({super.key});

  @override
  State<StatusSphereWidget> createState() => _StatusSphereWidgetState();
}

class _StatusSphereWidgetState extends State<StatusSphereWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseAnimationController;

  @override
  void initState() {
    super.initState();
    _pulseAnimationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _pulseAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
            return Consumer<HypnosChatProvider>(
      builder: (context, provider, child) {
        final isSpeaking = provider.isSpeaking;
        final isProcessing = provider.isProcessing;
        final isConnected = provider.isConnected;
        
        // Determine status color and animation
        Color statusColor;
        bool shouldPulse = false;
        
        if (isSpeaking) {
          statusColor = AppTheme.primaryOrange;
          shouldPulse = true;
        } else if (isProcessing) {
          statusColor = AppTheme.accentBlue;
          shouldPulse = true;
        } else if (isConnected) {
          statusColor = AppTheme.primaryOrange; // Ready state is orange
          shouldPulse = false;
        } else {
          statusColor = Colors.red; // Broken state is red
          shouldPulse = false;
        }
        
        // Start pulse animation when needed
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (shouldPulse) {
            _pulseAnimationController.repeat(reverse: true);
          } else {
            _pulseAnimationController.stop();
            _pulseAnimationController.reset();
          }
        });

        return AnimatedBuilder(
          animation: _pulseAnimationController,
          builder: (context, child) {
            return Container(
              width: 16,
              height: 16,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: statusColor,
                boxShadow: shouldPulse
                    ? [
                        BoxShadow(
                          color: statusColor.withValues(alpha: 0.5),
                          blurRadius: 8 + (_pulseAnimationController.value * 4),
                          spreadRadius: 2 + (_pulseAnimationController.value * 2),
                        ),
                      ]
                    : [
                        BoxShadow(
                          color: statusColor.withValues(alpha: 0.3),
                          blurRadius: 4,
                          spreadRadius: 1,
                        ),
                      ],
              ),
            );
          },
        );
      },
    );
  }
} 