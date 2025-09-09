import 'dart:developer';

import 'package:cubix_app/core/utils/app_exports.dart';
import 'package:cubix_app/features/ai_chatbot/data/chat_response_model.dart';

import 'package:cubix_app/features/ai_chatbot/data/sample_model.dart';
import 'package:cubix_app/features/ai_chatbot/services/chat_service.dart';
import 'package:cubix_app/main.dart';

/// Represent a single chat message
class ChatMessage {
  final String role;
  final String content;
  final bool isLoading;
  final bool isDownloading;
  final List<ChatOption>? options;
  final String? finalSubjectTitle;
  final String? subjectId;

  ChatMessage({
    required this.role,
    required this.content,
    this.isLoading = false,
    this.isDownloading = false,
    this.options,
    this.finalSubjectTitle,
    this.subjectId,
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
    final loadingMessage = ChatMessage(
      role: "assistant",
      content: "...",
      isLoading: true,
    );
    state = [...state, loadingMessage];

    try {
      final history =
          state
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
        state[loadingIndex] = ChatMessage(
          role: "assistant",
          content: "🚫 Error sending message",
        );
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

    // Add subject to global downloading list
    final container = ProviderScope.containerOf(navigatorKey.currentContext!);
    final downloadingSubjectsNotifier = container.read(
      downloadingSubjectsProvider.notifier,
    );
    downloadingSubjectsNotifier.state = [
      ...downloadingSubjectsNotifier.state,
      subjectTitle,
    ];

    try {
      final subjectId = await chatService.createCustomSubject(
        subjectTitle: subjectTitle,
        subjectTone: 'formal',
      );

      // Remove bubble
      state = state.where((m) => m != downloadingMessage).toList();

      // Remove from downloading list
      downloadingSubjectsNotifier.state =
          downloadingSubjectsNotifier.state
              .where((s) => s != subjectTitle)
              .toList();

      // Add success confirmation
      state = [
        ...state,
        ChatMessage(
          role: "system",
          content: "$subjectTitle downloaded successfully!",
          subjectId: subjectId,
          finalSubjectTitle: subjectTitle,
        ),
      ];
    } catch (e) {
      // Remove bubble
      state = state.where((m) => m != downloadingMessage).toList();

      // Remove from downloading list
      downloadingSubjectsNotifier.state =
          downloadingSubjectsNotifier.state
              .where((s) => s != subjectTitle)
              .toList();

      // Show error
      state = [
        ...state,
        ChatMessage(
          role: "system",
          content: "Failed to download $subjectTitle",
        ),
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

final downloadingSubjectsProvider = StateProvider<List<String>>((ref) => []);
