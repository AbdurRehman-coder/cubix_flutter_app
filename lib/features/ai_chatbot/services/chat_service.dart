import 'dart:developer';

import 'package:cubix_app/core/constants/api_endpoints.dart';
import 'package:cubix_app/core/utils/app_exports.dart';
import 'package:cubix_app/features/ai_chatbot/data/chat_response_model.dart';
import 'package:cubix_app/features/ai_chatbot/data/sample_model.dart';
import 'package:dio/dio.dart';

class ChatService {
  final ApiClient apiClient;

  ChatService({required this.apiClient});

  Future<List<AssistantSample>?> getInitialMessages() async {
    try {
      Response response = await apiClient.dio.get(ApiEndpoints.assistant);
      if (response.statusCode == 200 && response.data['data'] != null) {
        final dataJson = response.data['data'] as List<dynamic>;
        final initialMessages =
            dataJson.map((e) => AssistantSample.fromJson(e)).toList();
        log('Initial messages loaded successfully');
        return initialMessages;
      } else {
        return null;
      }
    } catch (e) {
      log('Failed to fetch initial messages: $e');
      throw Exception("Failed to fetch initial messages: $e");
    }
  }

  /// Send chat message
  Future<ChatResponse?> sendChatMessage(
    String message,
    List<Map<String, String>> history,
  ) async {
    try {
      final response = await apiClient.dio.post(
        ApiEndpoints.assistant,
        data: {"message": message, "messageHistory": history},
      );

      if (response.statusCode == 200 && response.data['data'] != null) {
        return ChatResponse.fromJson(response.data);
      }
      return null;
    } catch (e) {
      throw Exception("Failed to send chat message: $e");
    }
  }

  /// Create a new subject response
  Future<ChatResponse?> createCustomSubject({
    required String subjectTitle,
    required String subjectTone,
  }) async {
    try {
      final response = await apiClient.dio.post(
        ApiEndpoints.assistantSubject, // must be added in ApiEndpoints
        data: {
          "subject_title": subjectTitle,
          "subject_tone": subjectTone,
        },
      );

      if (response.statusCode == 200 && response.data['data'] != null) {
        return ChatResponse.fromJson(response.data);
      }
      return null;
    } catch (e) {
      log('Failed to create subject: $e');
      throw Exception("Failed to create subject: $e");
    }
  }

  /// Get a custom subject by ID
  Future<ChatResponse?> getCustomSubject(String id) async {
    try {
      final response = await apiClient.dio.get(
        "${ApiEndpoints.assistantSubject}/$id",
      );

      if (response.statusCode == 200 && response.data['data'] != null) {
        return ChatResponse.fromJson(response.data);
      }
      return null;
    } catch (e) {
      log('Failed to fetch custom subject: $e');
      throw Exception("Failed to fetch custom subject: $e");
    }
  }




}
