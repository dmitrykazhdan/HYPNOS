import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'providers/hypnos_chat_provider.dart';
import 'screens/voice_chat_screen.dart';
import 'utils/theme.dart';

void main() async {
  // Load environment variables
  await dotenv.load(fileName: ".env");
  
  runApp(const HypnosApp());
}

class HypnosApp extends StatelessWidget {
  const HypnosApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => HypnosChatProvider(),
      child: MaterialApp(
        title: 'HYPNOS - AI Sleep Companion',
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.dark, // Force dark mode
        home: const VoiceChatScreen(),
      ),
    );
  }
}