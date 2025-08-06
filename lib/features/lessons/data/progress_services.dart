import 'dart:developer';

import 'package:cubix_app/core/services/api_client.dart';
import 'package:cubix_app/features/lessons/models/progress_model.dart';
import 'package:dio/dio.dart';

class ProgressServices {
  final ApiClient apiClient;

  ProgressServices({required this.apiClient});

  Future<List<ProgressModel>?> getAllProgress() async {
    const String url = "/progress?device_id=abcd1234";
    try {
      Response response = await apiClient.dio.get(url);

      if (response.statusCode == 200 && response.data['data'] != null) {
        final dataJson = response.data['data'];
        final progressData =
            (dataJson as List)
                .map((item) => ProgressModel.fromJson(item))
                .toList();

        return progressData;
      } else {
        return null;
      }
    } catch (e) {
      log('Failed to fetch subjects: $e');
      throw Exception("Failed to fetch subjects: $e");
    }
  }

  Future<bool> createProgress({
    required String deviceId,
    required String subjectId,
  }) async {
    const String url = "/progress";

    try {
      Response response = await apiClient.dio.post(
        url,
        data: {"device_id": deviceId, "subject_id": subjectId},
      );
      if (response.statusCode == 201) {
        log('Progress created successfully');
        return true;
      } else {
        log('Failed to create progress: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      log('Error while creating progress: $e');
      return false;
    }
  }

  Future<bool> updateProgress({
    required String progressId,
    required String title,
    required String type,
  }) async {
    const String url = "/progress";

    try {
      Response response = await apiClient.dio.post(
        url,
        data: {"progress_id": progressId, "title": title, "type": type},
      );
      if (response.statusCode == 201) {
        log('Progress updated successfully');
        return true;
      } else {
        log('Failed to update progress: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      log('Error while updating progress: $e');
      return false;
    }
  }
}
