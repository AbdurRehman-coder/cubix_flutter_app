import 'dart:developer';
import 'package:cubix_app/core/services/api_client.dart';
import 'package:cubix_app/core/services/app_services.dart';
import 'package:cubix_app/core/services/shared_prefs_services.dart';
import 'package:cubix_app/features/home/models/subject_details_model.dart';
import 'package:dio/dio.dart';

import '../models/subject_model.dart';

class HomeServices {
  final ApiClient apiClient;

  HomeServices({required this.apiClient});

  Future<SubjectsData?> getSubjects() async {
    const String url = "/subjects";
    try {
      Response response = await apiClient.dio.get(url);

      if (response.statusCode == 200 && response.data['data'] != null) {
        final dataJson = response.data['data'];
        final subjectsData = SubjectsData.fromJson(dataJson);
        log('Subjects loaded successfully');
        return subjectsData;
      } else {
        return null;
      }
    } catch (e) {
      log('Failed to fetch subjects: $e');
      throw Exception("Failed to fetch subjects: $e");
    }
  }

  Future<SubjectDetail?> getSubjectDetail(String subjectId) async {
    final String url = "/subjects/$subjectId";
    try {
      final response = await apiClient.dio.get(url);
      if (response.statusCode == 200 && response.data['data'] != null) {
        final dataJson = response.data['data'];
        return SubjectDetail.fromJson(dataJson);
      }
      return null;
    } catch (e) {
      log("Failed to fetch subject detail: $e");
      throw Exception("Failed to fetch subject detail: $e");
    }
  }

  Future<SubjectDetail?> addSubjectSection({
    required String subjectId,
    required String sectionTitle,
  }) async {
    const String url = "/subjects/section";
    try {
      final response = await apiClient.dio.post(
        url,
        data: {"subject_id": subjectId, "section_title": sectionTitle},
      );
      if ((response.statusCode == 200 || response.statusCode == 201) &&
          response.data['data'] != null) {
        final dataJson = response.data['data'];
        return SubjectDetail.fromJson(dataJson);
      }
      return null;
    } catch (e) {
      log("Failed to add section: $e");
      throw Exception("Failed to add section: $e");
    }
  }

  ///
  ///  Create feedbacks
  Future<bool> sendFeedback({required String description}) async {
    const String url = "/feedbacks";
    String accessToken =
        await locator.get<SharedPrefServices>().getAccessToken() ??
        '12345'; // access token used as deviceId for now, need to be replaced
    try {
      final response = await apiClient.dio.post(
        url,
        data: {"device_id": accessToken, "description": description},
      );
      if ((response.statusCode == 200 || response.statusCode == 201) &&
          response.data['data'] != null) {
        return true;
      }
      return false;
    } catch (e) {
      log("Failed to add section: $e");
      throw Exception("Failed to add section: $e");
    }
  }

  ///
  ///  Create feedbacks
  Future<bool> createFeedback({required String description}) async {
    const String url = "/feedbacks";
    String accessToken =
        await locator.get<SharedPrefServices>().getAccessToken() ??
        '12345'; // access token used as deviceId for now, need to be replaced
    try {
      final response = await apiClient.dio.post(
        url,
        data: {"device_id": accessToken, "description": description},
      );
      if ((response.statusCode == 200 || response.statusCode == 201) &&
          response.data['data'] != null) {
        return true;
      }
      return false;
    } catch (e) {
      log("Failed to add section: $e");
      throw Exception("Failed to add section: $e");
    }
  }
}
