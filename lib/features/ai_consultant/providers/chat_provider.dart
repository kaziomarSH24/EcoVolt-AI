import 'package:flutter_riverpod/flutter_riverpod.dart';

class ChatMessage {
  final String text;
  final bool isUser;
  final DateTime timestamp;
  final Map<String, dynamic>? productData; // Generative UI payload

  ChatMessage({
    required this.text,
    required this.isUser,
    required this.timestamp,
    this.productData,
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
  @override
  ChatState build() {
    return ChatState(
      messages: [
        ChatMessage(
          text: "Hello! I am your EcoVolt AI Consultant. How can I help you optimize your power solutions today?",
          isUser: false,
          timestamp: DateTime.now(),
        ),
      ],
    );
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

    // Mock AI processing delay
    await Future.delayed(const Duration(seconds: 2));

    // Mock AI response
    final aiResponse = _getMockResponse(text);
    final aiMessage = ChatMessage(
      text: aiResponse['text'],
      isUser: false,
      timestamp: DateTime.now(),
      productData: aiResponse['productData'],
    );

    state = state.copyWith(
      messages: [...state.messages, aiMessage],
      isTyping: false,
    );
  }

  Map<String, dynamic> _getMockResponse(String userText) {
    final lower = userText.toLowerCase();
    if (lower.contains('load') || lower.contains('fan') || lower.contains('light')) {
      return {
        'text': "Based on typical loads, a fan uses ~70W and a light uses ~15W. If you have 3 fans and 5 lights, your total load is around 285W. I recommend a 600VA IPS setup. Here is a great option for you:",
        'productData': {
          'title': 'EcoVolt 600VA Smart IPS',
          'price': '\$120.00',
          'imagePath': 'assets/images/ev1.png',
          'specs': 'Backup: 4 Hours • Battery: 12V 100Ah',
        }
      };
    } else if (lower.contains('solar') || lower.contains('save')) {
      return {
        'text': "Going solar can save you up to 80% on your monthly electricity bill! With a standard 1KW system, your Return on Investment (ROI) is typically achieved in just 3-4 years.",
        'productData': null,
      };
    } else {
      return {
        'text': "That's a great question! I am still in training, but I can help you calculate your load, find the right battery capacity, or estimate solar savings. What would you like to do?",
        'productData': null,
      };
    }
  }
}

final chatProvider = NotifierProvider<ChatNotifier, ChatState>(() {
  return ChatNotifier();
});
