import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:ecovolt_ai/features/shop/providers/product_provider.dart';

class ChatMessage {
  final String text;
  final bool isUser;
  final DateTime timestamp;

  ChatMessage({
    required this.text,
    required this.isUser,
    required this.timestamp,
  });
}

class ChatState {
  final List<ChatMessage> messages;
  final bool isTyping;

  ChatState({
    required this.messages,
    this.isTyping = false,
  });

  ChatState copyWith({
    List<ChatMessage>? messages,
    bool? isTyping,
  }) {
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
          text: "হ্যালো! আমি EcoVolt AI Consultant. আজ আমি আপনাকে কীভাবে সাহায্য করতে পারি? আপনি চাইলে আপনার বাসার ফ্যান ও লাইটের হিসাব দিতে পারেন, আমি আপনার জন্য সঠিক সোলার বা আইপিএস সাজেস্ট করব!",
          isUser: false,
          timestamp: DateTime.now(),
        ),
      ],
    );
  }

  void _initChatSession() {
    final apiKey = dotenv.env['GEMINI_API_KEY'];
    if (apiKey == null || apiKey.isEmpty || apiKey == 'YOUR_GEMINI_API_KEY_HERE') {
      print('Warning: Gemini API Key is missing or invalid.');
      return;
    }

    final products = ref.read(productProvider).value ?? [];
    final inventoryList = products.map((p) => '- Name: ${p.title} (Price: ${p.price}, ID: ${p.id})').join('\n');

    final systemInstruction = '''
You are EcoVolt AI Consultant, a friendly and knowledgeable power solutions assistant in Bangladesh.
You help users calculate their power load (e.g. for fans, lights, appliances) and recommend Solar, IPS, Batteries, or Generators.
You MUST communicate purely in Bengali.

Here is the current inventory of products available in the EcoVolt app:
$inventoryList

IMPORTANT INSTRUCTIONS FOR RECOMMENDING PRODUCTS:
1. Only recommend products from the inventory list above.
2. If you recommend a specific product, you MUST format it exactly like this in your response:
[PRODUCT:product_id_here]
For example, if you recommend a product with ID 12345, you must write: [PRODUCT:12345]. 
3. Do NOT use markdown links for products. ONLY use the exact [PRODUCT:id] syntax. The app will automatically convert this syntax into a beautiful UI card.
4. Keep your responses concise, helpful, and friendly. Use bullet points for load calculations to make it easy to read.
''';

    final model = GenerativeModel(
      model: 'gemini-1.5-flash-latest',
      apiKey: apiKey,
      systemInstruction: Content.system(systemInstruction),
    );

    _chatSession = model.startChat();
  }

  Future<void> sendMessage(String text) async {
    if (text.trim().isEmpty) return;

    // Add user message
    final userMessage = ChatMessage(
      text: text,
      isUser: true,
      timestamp: DateTime.now(),
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
        throw Exception("API Key is missing. Please add your GEMINI_API_KEY to the .env file.");
      }

      final response = await _chatSession!.sendMessage(Content.text(text));
      final responseText = response.text ?? "দুঃখিত, আমি আপনার কথা বুঝতে পারিনি।";

      final aiMessage = ChatMessage(
        text: responseText,
        isUser: false,
        timestamp: DateTime.now(),
      );

      state = state.copyWith(
        messages: [...state.messages, aiMessage],
        isTyping: false,
      );
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
