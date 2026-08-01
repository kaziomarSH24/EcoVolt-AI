import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:ecovolt_ai/features/shop/providers/product_provider.dart';

import 'dart:typed_data';

class ChatMessage {
  final String text;
  final bool isUser;
  final DateTime timestamp;
  final Uint8List? imageBytes;

  ChatMessage({
    required this.text,
    required this.isUser,
    required this.timestamp,
    this.imageBytes,
  });
}

class ChatState {
  final List<ChatMessage> messages;
  final bool isTyping;

  ChatState({required this.messages, this.isTyping = false});

  ChatState copyWith({List<ChatMessage>? messages, bool? isTyping}) {
    return ChatState(
      messages: messages ?? this.messages,
      isTyping: isTyping ?? this.isTyping,
    );
  }
}

class ChatNotifier extends Notifier<ChatState> {
  ChatSession? _chatSession;
  final List<String> _availableModels = [
    'gemini-3.5-flash',
    'gemini-3.6-flash',
  ];
  int _currentModelIndex = 0;

  @override
  ChatState build() {
    // Initial message
    return ChatState(
      messages: [
        ChatMessage(
          text:
              "হ্যালো! আমি EcoVolt AI Consultant. আজ আমি আপনাকে কীভাবে সাহায্য করতে পারি?\n\nআপনি চাইলে আমাকে নিচের তথ্যগুলো জানাতে পারেন:\n• আপনার বাসায় কয়টি ফ্যান, লাইট বা টিভি চলে?\n• আপনার বাজেট কত?\n• কতক্ষণ ব্যাকআপ চাচ্ছেন?\n\nতথ্যগুলো জানালে আমি আপনার জন্য সঠিক সোলার বা আইপিএস সাজেস্ট করব!",
          isUser: false,
          timestamp: DateTime.now(),
        ),
      ],
    );
  }

  void _initChatSession({Iterable<Content>? history}) {
    final apiKey = dotenv.env['GEMINI_API_KEY'];
    if (apiKey == null ||
        apiKey.isEmpty ||
        apiKey == 'YOUR_GEMINI_API_KEY_HERE') {
      print('Warning: Gemini API Key is missing or invalid.');
      return;
    }

    final products = ref.read(productProvider).value ?? [];
    final inventoryList = products
        .map((p) => '- Name: ${p.title} (Price: ${p.price}, ID: ${p.id})')
        .join('\n');

    final systemInstruction =
        '''
You are EcoVolt AI Consultant, a friendly, mathematically brilliant power solutions expert in Bangladesh.
You help users calculate their power load and recommend Solar, IPS, Batteries, or Generators.
You MUST communicate purely in Bengali.

Here is the current inventory of products available in the EcoVolt app:
$inventoryList

IMPORTANT INSTRUCTIONS FOR SMART CALCULATIONS & RECOMMENDATIONS:
1. SMART CALCULATOR: If the user provides a monthly electricity bill or a load shed duration, YOU MUST act as a Smart Calculator. 
   - For Solar: Calculate 5-year savings (Monthly bill * 12 * 5). Explain the Return on Investment (ROI).
   - For Generators: Calculate fuel cost over 5 years and compare it with the one-time cost of Solar/IPS to show which is better.
   - For IPS/Battery: Explain the "value of uninterrupted power" and how much money/time they save by not stopping their work.
   Always break down the math step-by-step using bullet points so it's easy for the user to understand.
2. Only recommend products from the inventory list above that fit their calculated budget and load.
3. If the user does not provide enough details (e.g., they just say "Hi"), politely ASK THEM clarifying questions (e.g., "আপনার মাসিক বিদ্যুৎ বিল কত?", "আপনার কি জেনারেটরের তেলের খরচ বেশি মনে হচ্ছে?").
4. If you recommend a specific product, you MUST format it exactly like this in your response on a NEW LINE:
[PRODUCT:product_id_here]
For example: [PRODUCT:12345]
5. CRITICAL: NEVER place the [PRODUCT:id] syntax inside a Markdown table or next to pipes (|). It will break the UI. ALWAYS put [PRODUCT:id] on a completely new line by itself.
6. Do NOT use markdown links for products. ONLY use the exact [PRODUCT:id] syntax.
''';

    final model = GenerativeModel(
      model: _availableModels[_currentModelIndex],
      apiKey: apiKey,
      systemInstruction: Content.system(systemInstruction),
    );

    _chatSession = model.startChat(history: history?.toList());
  }

  Future<void> sendMessage(String text, {Uint8List? imageBytes}) async {
    if (text.trim().isEmpty && imageBytes == null) return;

    // Add user message
    final userMessage = ChatMessage(
      text: text,
      isUser: true,
      timestamp: DateTime.now(),
      imageBytes: imageBytes,
    );

    state = state.copyWith(
      messages: [...state.messages, userMessage],
      isTyping: true,
    );

    // Reset to the primary fastest model for every new message
    if (_currentModelIndex != 0) {
      _currentModelIndex = 0;
      _initChatSession(history: _chatSession?.history);
    } else if (_chatSession == null) {
      _initChatSession();
    }

    try {
      if (_chatSession == null) {
        throw Exception(
          "API Key is missing. Please add your GEMINI_API_KEY to the .env file.",
        );
      }

      final content = imageBytes != null
          ? Content.multi([
              TextPart(text.isNotEmpty ? text : "Describe this image"),
              DataPart('image/jpeg', imageBytes),
            ])
          : Content.text(text);

      await _attemptSendMessage(content);
    } catch (e) {
      final eStr = e.toString();
      String errorText =
          "দুঃখিত, কোনো একটি সমস্যা হয়েছে। দয়া করে আবার চেষ্টা করুন।";

      if (eStr.contains('Quota exceeded') || eStr.contains('429')) {
        errorText =
            "দুঃখিত, আপনি খুব দ্রুত মেসেজ দিচ্ছেন! গুগলের ফ্রি লিমিট অনুযায়ী দয়া করে ১০-১৫ সেকেন্ড অপেক্ষা করে আবার মেসেজ দিন।";
      } else if (eStr.contains('high demand') || eStr.contains('503')) {
        errorText =
            "বর্তমানে সার্ভারে অনেক চাপ রয়েছে। দয়া করে কিছুক্ষণ পর আবার চেষ্টা করুন।";
      } else {
        errorText = "Error: $eStr";
      }

      final errorMessage = ChatMessage(
        text: errorText,
        isUser: false,
        timestamp: DateTime.now(),
      );
      state = state.copyWith(
        messages: [...state.messages, errorMessage],
        isTyping: false,
      );
    }
  }

  Future<void> _attemptSendMessage(Content content) async {
    try {
      final stream = _chatSession!.sendMessageStream(content);

      var aiMessage = ChatMessage(
        text: "",
        isUser: false,
        timestamp: DateTime.now(),
      );

      bool isFirstChunk = true;

      await for (final chunk in stream) {
        if (chunk.text != null) {
          aiMessage = ChatMessage(
            text: aiMessage.text + chunk.text!,
            isUser: false,
            timestamp: aiMessage.timestamp,
          );

          if (isFirstChunk) {
            state = state.copyWith(
              messages: [...state.messages, aiMessage],
              isTyping: false,
            );
            isFirstChunk = false;
          } else {
            final updatedMessages = List<ChatMessage>.from(state.messages);
            updatedMessages[updatedMessages.length - 1] = aiMessage;
            state = state.copyWith(messages: updatedMessages);
          }
        }
      }
    } catch (e) {
      final eStr = e.toString();
      // If we encounter a rate limit or high demand error, and we have more models to try:
      if ((eStr.contains('Quota exceeded') ||
              eStr.contains('429') ||
              eStr.contains('high demand') ||
              eStr.contains('503')) &&
          _currentModelIndex < _availableModels.length - 1) {
        print(
          "Model \${_availableModels[_currentModelIndex]} failed. Switching to next...",
        );
        _currentModelIndex++;

        // Re-initialize with the new model but keep the old history
        _initChatSession(history: _chatSession?.history);

        // Retry
        await _attemptSendMessage(content);
      } else {
        // No more models to try, or different error
        rethrow;
      }
    }
  }
}

final chatProvider = NotifierProvider<ChatNotifier, ChatState>(() {
  return ChatNotifier();
});
