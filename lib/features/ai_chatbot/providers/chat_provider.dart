import 'package:cubix_app/core/utils/app_exports.dart';
import 'package:cubix_app/features/ai_chatbot/data/chat_response_model.dart';

import 'package:cubix_app/features/ai_chatbot/data/sample_model.dart';
import 'package:cubix_app/features/ai_chatbot/services/chat_service.dart';

/// Represent a single chat message
class ChatMessage {
  final String role; // "user" or "assistant"
  final String content;
  final bool isLoading;
  final List<ChatOption>? options; // <-- add this

  ChatMessage({
    required this.role,
    required this.content,
    this.isLoading = false,
    this.options,
  });
}

class ChatNotifier extends StateNotifier<List<ChatMessage>> {
  final ChatService chatService;

  ChatNotifier(this.chatService) : super([]);

  /// Load initial system messages (tiles)
  Future<List<AssistantSample>?> getInitialMessages() async {
    return await chatService.getInitialMessages();
  }

  /// Send a user message and fetch assistant response
  Future<void> sendMessage(String message) async {
    // Add user message
    state = [...state, ChatMessage(role: "user", content: message)];

    // Add placeholder assistant loading bubble
    state = [
      ...state,
      ChatMessage(role: "assistant", content: "...", isLoading: true),
    ];

    try {
      final history =
          state
              .where((m) => !m.isLoading)
              .map((m) => {"role": m.role, "content": m.content})
              .toList();

      final response = await chatService.sendChatMessage(message, history);

      // Remove loading bubble
      state = [...state..removeLast()];

      // Add assistant response
      if (response != null) {
        state = [
          ...state,
          ChatMessage(
            role: "assistant",
            content: response.data?.chatResponse ?? "No response",
            options: response.data?.options,
          ),
        ];
      }
    } catch (e) {
      // Replace loading with error bubble
      state = [
        ...state..removeLast(),
        ChatMessage(role: "assistant", content: "❌ Failed to load response"),
      ];
    }
  }
}

/// Riverpod providers
final chatProvider = StateNotifierProvider<ChatNotifier, List<ChatMessage>>(
  (ref) => ChatNotifier(locator.get<ChatService>()),
);

final initialMessagesProvider = FutureProvider<List<AssistantSample>?>((
  ref,
) async {
  final service = locator.get<ChatService>();
  return await service.getInitialMessages();
});
