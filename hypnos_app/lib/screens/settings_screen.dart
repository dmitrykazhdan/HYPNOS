import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/hypnos_chat_provider.dart';
import '../utils/theme.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.darkBackground,
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: AppTheme.darkSurface,
        foregroundColor: AppTheme.darkOnSurface,
        elevation: 0,
      ),
      body: Consumer<HypnosChatProvider>(
        builder: (context, provider, child) {
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _buildVoiceoverSection(provider),
            ],
          );
        },
      ),
    );
  }

  Widget _buildVoiceoverSection(HypnosChatProvider provider) {
    return Container(
      decoration: AppTheme.glassMorphismDecoration,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.volume_up,
                  color: AppTheme.primaryOrange,
                  size: 24,
                ),
                const SizedBox(width: 12),
                Text(
                  'Voice Settings',
                  style: TextStyle(
                    color: AppTheme.darkOnSurface,
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            _buildVoiceoverTile(provider),
          ],
        ),
      ),
    );
  }

  Widget _buildVoiceoverTile(HypnosChatProvider provider) {
    return GestureDetector(
      onTap: () {
        provider.toggleVoice();
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppTheme.darkSurfaceVariant,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.1),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Icon(
              provider.voiceEnabled ? Icons.volume_up : Icons.volume_off,
              color: provider.voiceEnabled 
                  ? AppTheme.primaryOrange
                  : AppTheme.darkOnSurfaceVariant,
              size: 20,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Voice Responses',
                    style: TextStyle(
                      color: AppTheme.darkOnSurface,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    provider.voiceEnabled 
                        ? 'AI will speak responses aloud'
                        : 'AI will only show text responses',
                    style: TextStyle(
                      color: AppTheme.darkOnSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            Switch(
              value: provider.voiceEnabled,
              onChanged: (value) {
                provider.toggleVoice();
              },
              activeColor: AppTheme.primaryOrange,
            ),
          ],
        ),
      ),
    );
  }
} 