import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'dart:io';

class SpeechService {
  final SpeechToText _speechToText = SpeechToText();
  final FlutterTts _tts = FlutterTts();

  bool _isInitialized = false;
  bool _isSpeaking = false;

  bool get isInitialized => _isInitialized;
  bool get isSpeaking => _isSpeaking;

  Future<bool> initialize() async {
    final available = await _speechToText.initialize();
    if (available) {
      await _initializeTts();
      _isInitialized = true;
    }
    return _isInitialized;
  }

  Future<void> _initializeTts() async {
    if (Platform.isIOS || Platform.isMacOS) {
      await _tts.setVoice({
        "name": AppConfig.DEFAULT_VOICE_NAME, 
        "locale": AppConfig.DEFAULT_VOICE_LOCALE
      });
    }
    await _tts.setLanguage(AppConfig.DEFAULT_VOICE_LOCALE);
    await _tts.setSpeechRate(AppConfig.DEFAULT_SPEECH_RATE);
    await _tts.setVolume(AppConfig.DEFAULT_VOLUME);
    
    _tts.setStartHandler(() {
      _isSpeaking = true;
    });
    
    _tts.setCompletionHandler(() {
      _isSpeaking = false;
    });
  }

  Future<void> startListening({
    required Function(String) onResult,
    required Function() onFinalResult,
  }) async {
    if (!_isInitialized) return;

    try {
      await _speechToText.listen(
        onResult: (result) {
          final transcription = result.recognizedWords;
          if (transcription.isNotEmpty) {
            onResult(transcription);
          }
          
          if (result.finalResult) {
            onFinalResult();
          }
        },
        listenFor: const Duration(seconds: 30),
        pauseFor: const Duration(seconds: 3),
        localeId: 'en_US',
      );
    } catch (e) {
      debugPrint('Error starting speech recognition: $e');
    }
  }

  Future<void> stopListening() async {
    try {
      await _speechToText.stop();
    } catch (e) {
      debugPrint('Error stopping speech recognition: $e');
    }
  }

  Future<void> cancelListening() async {
    try {
      await _speechToText.cancel();
    } catch (e) {
      debugPrint('Error canceling speech recognition: $e');
    }
  }

  Future<void> speak(String text) async {
    if (!_isInitialized) return;
    
    try {
      await _tts.speak(text);
    } catch (e) {
      debugPrint('Error speaking text: $e');
    }
  }

  Future<void> stopSpeaking() async {
    try {
      await _tts.stop();
    } catch (e) {
      debugPrint('Error stopping speech: $e');
    }
  }

  void dispose() {
    _speechToText.cancel();
    _tts.stop();
  }
} 