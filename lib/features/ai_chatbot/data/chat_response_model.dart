import 'dart:convert';

ChatResponse chatResponseFromJson(String str) =>
    ChatResponse.fromJson(json.decode(str));

String chatResponseToJson(ChatResponse data) => json.encode(data.toJson());

class ChatResponse {
  final bool success;
  final String message;
  final ChatData? data;

  ChatResponse({required this.success, required this.message, this.data});

  factory ChatResponse.fromJson(Map<String, dynamic> json) => ChatResponse(
    success: json["success"] ?? false,
    message: json["message"] ?? "",
    data: json["data"] != null ? ChatData.fromJson(json["data"]) : null,
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "data": data?.toJson(),
  };
}

class ChatData {
  final String chatResponse;
  final List<ChatOption> options;
  final String? finalSubjectTitle;

  ChatData({
    required this.chatResponse,
    required this.options,
    this.finalSubjectTitle,
  });

  factory ChatData.fromJson(Map<String, dynamic> json) => ChatData(
    chatResponse: json["chat_response"] ?? "",
    options:
        (json["options"] as List<dynamic>?)
            ?.map((x) => ChatOption.fromJson(x))
            .toList() ??
        [],
    finalSubjectTitle: json["final_subject_title"],
  );

  Map<String, dynamic> toJson() => {
    "chat_response": chatResponse,
    "options": options.map((x) => x.toJson()).toList(),
    "final_subject_title": finalSubjectTitle,
  };
}

class ChatOption {
  final String buttonMessage;
  final String buttonColor;

  ChatOption({required this.buttonMessage, required this.buttonColor});

  factory ChatOption.fromJson(Map<String, dynamic> json) => ChatOption(
    buttonMessage: json["button_message"] ?? "",
    buttonColor: json["button_color"] ?? "",
  );

  Map<String, dynamic> toJson() => {
    "button_message": buttonMessage,
    "button_color": buttonColor,
  };
}
