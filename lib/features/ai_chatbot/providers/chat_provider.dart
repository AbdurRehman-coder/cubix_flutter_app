import 'package:cubix_app/core/utils/app_exports.dart';
import 'package:cubix_app/features/ai_chatbot/data/chat_response_model.dart';

import 'package:cubix_app/features/ai_chatbot/data/sample_model.dart';
import 'package:cubix_app/features/ai_chatbot/services/chat_service.dart';

/// Represent a single chat message
class ChatMessage {
  final String role; // "user" or "assistant" or "system"
  final String content;
  final bool isLoading; // for typing indicator
  final bool isDownloading; // new for downloads
  final List<ChatOption>? options;
  final String? finalSubjectTitle;

  ChatMessage({
    required this.role,
    required this.content,
    this.isLoading = false,
    this.isDownloading = false,
    this.options,
    this.finalSubjectTitle,
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

    // Add assistant typing/loading bubble
    final loadingMessage = ChatMessage(role: "assistant", content: "...", isLoading: true);
    state = [...state, loadingMessage];

    try {
      final history = state
          .where((m) => !m.isLoading)
          .map((m) => {"role": m.role, "content": m.content})
          .toList();

      final response = await chatService.sendChatMessage(message, history);

      // Replace loading bubble with actual assistant message
      final loadingIndex = state.indexOf(loadingMessage);
      if (loadingIndex != -1) {
        state[loadingIndex] = ChatMessage(
          role: "assistant",
          content: response?.data?.chatResponse ?? "No response",
          options: response?.data?.options,
          finalSubjectTitle: response?.data?.finalSubjectTitle,
        );
        state = [...state]; // trigger state update
      }
    } catch (e) {
      final loadingIndex = state.indexOf(loadingMessage);
      if (loadingIndex != -1) {
        state[loadingIndex] = ChatMessage(role: "assistant", content: "🚫 Error sending message");
        state = [...state];
      }
    }
  }

  /// Show a “Downloading…” indicator for a specific subject/message
  Future<void> startDownloading(String subjectTitle) async {
    // Add downloading bubble
    final downloadingMessage = ChatMessage(
      role: "system",
      content: "Downloading $subjectTitle...",
      isDownloading: true,
    );
    state = [...state, downloadingMessage];

    try {
      // Trigger your service or simulate download
      await chatService.createCustomSubject(
        subjectTitle: subjectTitle,
        subjectTone: 'formal',
      );

      // Remove downloading bubble after completion
      state = state.where((m) => m != downloadingMessage).toList();

      // Optionally add a success confirmation
      state = [
        ...state,
        ChatMessage(role: "system", content: "$subjectTitle downloaded successfully!"),
      ];
    } catch (e) {
      // Remove downloading bubble and show error
      state = state.where((m) => m != downloadingMessage).toList();
      state = [
        ...state,
        ChatMessage(role: "system", content: "Failed to download $subjectTitle"),
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


