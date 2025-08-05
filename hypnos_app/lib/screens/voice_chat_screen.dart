import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../utils/theme.dart';
import '../widgets/app_bar/hypnos_app_bar.dart';
import '../widgets/chat/chat_content_widget.dart';
import '../widgets/input/input_area_widget.dart';

import '../providers/hypnos_chat_provider.dart';

class VoiceChatScreen extends StatefulWidget {
  const VoiceChatScreen({super.key});

  @override
  State<VoiceChatScreen> createState() => _VoiceChatScreenState();
}

class _VoiceChatScreenState extends State<VoiceChatScreen> {
  final FocusNode _textFocusNode = FocusNode();

  @override
  void dispose() {
    _textFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<HypnosChatProvider>(
      builder: (context, chatProvider, child) {
        return Scaffold(
          backgroundColor: AppTheme.darkBackground,
          resizeToAvoidBottomInset: true,
          body: Stack(
            children: [
              SafeArea(
                child: Column(
                                  children: [
                  // Modern App Bar
                  const HypnosAppBar(),
                    
                    // Main Content Area
                    Expanded(
                      child: GestureDetector(
                        onVerticalDragEnd: (details) {
                          // Swipe down to dismiss keyboard
                          if (details.primaryVelocity! > 300) {
                            _textFocusNode.unfocus();
                          }
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                AppTheme.darkBackground,
                                AppTheme.darkBackground.withOpacity(0.8),
                              ],
                            ),
                          ),
                          child: const ChatContentWidget(),
                        ),
                      ),
                    ),
                    
                    // Bottom Input Area
                    InputAreaWidget(focusNode: _textFocusNode),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
} 