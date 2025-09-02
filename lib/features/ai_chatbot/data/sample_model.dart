class AssistantSamplesResponse {
  final bool success;
  final String message;
  final List<AssistantSample> data;

  AssistantSamplesResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory AssistantSamplesResponse.fromJson(Map<String, dynamic> json) {
    return AssistantSamplesResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data:
          (json['data'] as List<dynamic>?)
              ?.map((e) => AssistantSample.fromJson(e))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'data': data.map((e) => e.toJson()).toList(),
    };
  }
}

class AssistantSample {
  final String interface;
  final String message;

  AssistantSample({required this.interface, required this.message});

  factory AssistantSample.fromJson(Map<String, dynamic> json) {
    return AssistantSample(
      interface: json['interface'] ?? '',
      message: json['message'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'interface': interface, 'message': message};
  }
}
