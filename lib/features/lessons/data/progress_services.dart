import 'dart:developer';

import 'package:cubix_app/core/services/api_client.dart';
import 'package:cubix_app/core/services/app_services.dart';
import 'package:cubix_app/core/services/shared_prefs_services.dart';
import 'package:cubix_app/features/lessons/models/progress_model.dart';
import 'package:dio/dio.dart';

class ProgressServices {
  final ApiClient apiClient;

  ProgressServices({required this.apiClient});

  Future<List<ProgressModel>?> getAllProgress() async {
    String accessToken =
        await locator.get<SharedPrefServices>().getAccessToken() ??
        '12345'; // access token used as deviceId for now, need to be replaced

    String url = "/progress?device_id=$accessToken";
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

  Future<ProgressModel?> createProgress({required String subjectId}) async {
    const String url = "/progress";
    String accessToken =
        await locator.get<SharedPrefServices>().getAccessToken() ??
        '12345'; // access token used as deviceId for now, need to be replaced

    try {
      Response response = await apiClient.dio.post(
        url,
        data: {"device_id": accessToken, "subject_id": subjectId},
      );
      if (response.statusCode == 201) {
        ProgressModel progress = ProgressModel.fromJson(response.data['data']);
        log('Progress created successfully');
        return progress;
      } else {
        log('Failed to create progress: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      log('Error while creating progress: $e');
      return null;
    }
  }

  Future<bool> updateProgress({
    required String progressId,
    required String title,
    required String type,
  }) async {
    const String url = "/progress";

    try {
      Response response = await apiClient.dio.patch(
        url,
        data: {"progress_id": progressId, "title": title, "type": type},
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
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
