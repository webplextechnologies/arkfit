import 'dart:convert';
import 'package:ark_fit_gym/view/api/api_services.dart';
import 'package:ark_fit_gym/view/api/api_urls.dart';
import 'package:ark_fit_gym/view/app/ai_chat/ai_consent_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

class ChatController extends GetxController {
  var messages = <Map<String, dynamic>>[].obs;

  TextEditingController messageController = TextEditingController();
  ScrollController scrollController = ScrollController();

  var isLoading = false.obs;
  var isTyping = false.obs;
  var isListening = false.obs;

  String userId = "";

  late stt.SpeechToText speech;
  late FlutterTts flutterTts;

  @override
  void onInit() {
    super.onInit();
    getUserId();

    speech = stt.SpeechToText();
    flutterTts = FlutterTts();
  }

  /// ================= USER ID =================
  Future<void> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    userId = prefs.getString("userId") ?? "";
    print("User ID: $userId");
  }

  /// ================= SPEECH =================
  Future<void> startListening() async {
    bool available = await speech.initialize();

    if (available) {
      isListening.value = true;

      speech.listen(
        onResult: (result) {
          messageController.text = result.recognizedWords;
        },
      );
    } else {
      Get.snackbar("Error", "Speech not available");
    }
  }

 Future<void> setMaleVoice() async {
  var voices = await flutterTts.getVoices;

  for (var v in voices) {
    final name = v["name"].toString().toLowerCase();

    if (name.contains("male") || name.contains("en")) {
      await flutterTts.setVoice({
        "name": v["name"].toString(),
        "locale": v["locale"].toString(),
      });
      break;
    }
  }
}

  Future<void> stopListening() async {
    isListening.value = false;
    await speech.stop();

    if (messageController.text.trim().isEmpty) return;

    await sendMessage(Get.context);

    /// Speak AI reply
    if (messages.isNotEmpty) {
      String reply = messages.last["message"];
      await flutterTts.stop();
     // await setMaleVoice();
      await flutterTts.speak(reply);
    }
  }

  /// ================= SEND MESSAGE =================
  Future<void> sendMessage(context) async {
  final accepted = await AiConsentHelper.showConsentDialog(context);

  if (!accepted) {
    return;
  }

    if (messageController.text.trim().isEmpty) return;

    String userMessage = messageController.text;

    /// Add user message
    messages.add({
      "message": userMessage,
      "isUser": true,
      "time": _getTime()
    });

    messageController.clear();
    _scrollToBottom();

    try {
      isLoading.value = true;
      isTyping.value = true;

      var body = {
        "user_id": userId,
        "message": userMessage,
        "mode": "nutrition",
        "provider": "gemini",
      };

      final response = await ApiServices.postRequest(
        ApiUrls.aiChat,
        body: body,
      );

      final jsonResponse = jsonDecode(response.body);

      if (response.statusCode == 200) {
        String reply = jsonResponse["data"]["reply"];

        messages.add({
          "message": reply,
          "isUser": false,
          "time": _getTime()
        });
        //await flutterTts.stop();
       // await flutterTts.speak(reply);
      } 
      
      else {
        
        print(response.statusCode);
        print(response.body);
        Get.snackbar("Error", jsonResponse['messages']['error']);
      }
    } catch (e) {
      Get.snackbar("Error", "Failed to get reply");
      print("❌ Error: $e");
    } finally {
      isLoading.value = false;
      isTyping.value = false;

      _scrollToBottom();
    }
  }

  /// ================= AUTO SCROLL =================
  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 300), () {
      if (scrollController.hasClients) {
        scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  /// ================= TIME =================
  String _getTime() {
    final now = DateTime.now();
    String min = now.minute.toString().padLeft(2, '0');
    return "${now.hour}:$min";
  }
}