import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/hypnos_chat_provider.dart';
import '../../utils/theme.dart';

class FloatingSphereWidget extends StatefulWidget {
  const FloatingSphereWidget({super.key});

  @override
  State<FloatingSphereWidget> createState() => _FloatingSphereWidgetState();
}

class _FloatingSphereWidgetState extends State<FloatingSphereWidget>
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
        
        // Start pulse animation when speaking or processing
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (isSpeaking || isProcessing) {
            _pulseAnimationController.repeat(reverse: true);
          } else {
            _pulseAnimationController.stop();
            _pulseAnimationController.reset();
          }
        });

        return GestureDetector(
          onTap: () {
            if (!provider.isProcessing) {
              if (provider.isRecording) {
                provider.stopRecording();
              } else {
                provider.startRecording();
              }
            }
          },
          child: AnimatedBuilder(
            animation: _pulseAnimationController,
            builder: (context, child) {
              return Stack(
                alignment: Alignment.center,
                children: [
                  // Pulse ring
                  if (isSpeaking || isProcessing)
                    Transform.scale(
                      scale: 1.0 + (_pulseAnimationController.value * 0.3),
                      child: Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: AppTheme.primaryOrange.withValues(
                              alpha: 1.0 - _pulseAnimationController.value,
                            ),
                            width: 2,
                          ),
                        ),
                      ),
                    ),
                  
                  // Main sphere
                  Transform.scale(
                    scale: 1.0,
                    child: Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        gradient: AppTheme.sphereGradient,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: AppTheme.primaryOrange.withValues(alpha: 0.4),
                            blurRadius: 15,
                            spreadRadius: 3,
                          ),
                        ],
                      ),
                      child: Icon(
                        provider.isRecording ? Icons.mic : Icons.mic_none,
                        color: provider.isRecording ? Colors.red : Colors.white,
                        size: 24,
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }
} 