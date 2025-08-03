import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/hypnos_chat_provider.dart';
import '../../utils/theme.dart';

class PulsatingSphereWidget extends StatefulWidget {
  const PulsatingSphereWidget({super.key});

  @override
  State<PulsatingSphereWidget> createState() => _PulsatingSphereWidgetState();
}

class _PulsatingSphereWidgetState extends State<PulsatingSphereWidget>
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
        final isRecording = provider.isRecording;

        return GestureDetector(
          onTap: () {
            print('Center mic tapped. Current state: recording=$isRecording, processing=$isProcessing');
            if (!provider.isProcessing) {
              if (provider.isRecording) {
                print('Stopping recording...');
                provider.stopRecording();
              } else {
                print('Starting recording...');
                provider.startRecording();
              }
            } else {
              print('Cannot toggle mic while processing');
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
                        width: 120,
                        height: 120,
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
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        gradient: isRecording 
                            ? LinearGradient(
                                colors: [Colors.red.withOpacity(0.8), Colors.red.withOpacity(0.6)],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              )
                            : AppTheme.sphereGradient,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: (isRecording ? Colors.red : AppTheme.primaryOrange).withValues(alpha: 0.4),
                            blurRadius: 20,
                            spreadRadius: 5,
                          ),
                        ],
                      ),
                      child: Icon(
                        isRecording ? Icons.mic : Icons.mic_none,
                        color: isRecording ? Colors.white : Colors.white,
                        size: 40,
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