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

  void _initChatSession() {
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
You are EcoVolt AI Consultant, a friendly and knowledgeable power solutions assistant in Bangladesh.
You help users calculate their power load (e.g. for fans, lights, appliances) and recommend Solar, IPS, Batteries, or Generators.
You MUST communicate purely in Bengali.

Here is the current inventory of products available in the EcoVolt app:
$inventoryList

IMPORTANT INSTRUCTIONS FOR RECOMMENDING PRODUCTS:
1. Only recommend products from the inventory list above.
2. If the user does not provide enough details (e.g., they just say "Hi" or "I need solar"), DO NOT just give a random list. Politely ASK THEM clarifying questions one by one (e.g., "আপনার বাসায় কয়টি ফ্যান ও লাইট চলবে?", "আপনার বাজেট কেমন?", "আপনার কি ব্যাকআপ বেশি প্রয়োজন?").
3. If you recommend a specific product, you MUST format it exactly like this in your response:
[PRODUCT:product_id_here]
For example, if you recommend a product with ID 12345, you must write: [PRODUCT:12345]. 
4. CRITICAL: NEVER place the [PRODUCT:id] syntax inside a Markdown table or next to pipes (|). It will break the UI. ALWAYS put [PRODUCT:id] on a completely new line by itself.
5. Do NOT use markdown links for products. ONLY use the exact [PRODUCT:id] syntax. The app will automatically convert this syntax into a beautiful UI card.
6. Keep your responses concise, helpful, and friendly. Use bullet points for load calculations to make it easy to read.
''';

    final model = GenerativeModel(
      model: 'gemini-3.5-flash',
      apiKey: apiKey,
      systemInstruction: Content.system(systemInstruction),
    );

    _chatSession = model.startChat();
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

    if (_chatSession == null) {
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

      final stream = _chatSession!.sendMessageStream(content);

      var aiMessage = ChatMessage(
        text: "",
        isUser: false,
        timestamp: DateTime.now(),
      );

      bool isFirstChunk = true;

      // Listen to the stream and update the message piece by piece
      await for (final chunk in stream) {
        if (chunk.text != null) {
          aiMessage = ChatMessage(
            text: aiMessage.text + chunk.text!,
            isUser: false,
            timestamp: aiMessage.timestamp,
          );
          
          if (isFirstChunk) {
            // Add the first message and turn off typing indicator
            state = state.copyWith(
              messages: [...state.messages, aiMessage],
              isTyping: false,
            );
            isFirstChunk = false;
          } else {
            // Update the last message in the list
            final updatedMessages = List<ChatMessage>.from(state.messages);
            updatedMessages[updatedMessages.length - 1] = aiMessage;
            state = state.copyWith(messages: updatedMessages);
          }
        }
      }
    } catch (e) {
      final errorMessage = ChatMessage(
        text: "Error: ${e.toString()}",
        isUser: false,
        timestamp: DateTime.now(),
      );
      state = state.copyWith(
        messages: [...state.messages, errorMessage],
        isTyping: false,
      );
    }
  }
}

final chatProvider = NotifierProvider<ChatNotifier, ChatState>(() {
  return ChatNotifier();
});
