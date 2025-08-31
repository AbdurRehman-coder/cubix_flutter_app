import 'dart:developer';
import 'package:cubix_app/core/constants/api_endpoints.dart';
import 'package:cubix_app/core/services/api_client.dart';
import 'package:cubix_app/features/home/models/subject_details_model.dart';
import 'package:dio/dio.dart';

import '../models/subject_model.dart';

class HomeServices {
  final ApiClient apiClient;

  HomeServices({required this.apiClient});

  Future<SubjectsData?> getSubjects() async {
    try {
      Response response = await apiClient.dio.get(ApiEndpoints.subjects);
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
    final String url = ApiEndpoints.subjectDetail(subjectId);
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
    try {
      final response = await apiClient.dio.post(
        ApiEndpoints.subjectSections,
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
  Future<bool> createFeedback({required String description}) async {
    try {
      final response = await apiClient.dio.post(
        ApiEndpoints.feedbacks,
        data: {"description": description},
      );
      if ((response.statusCode == 200 || response.statusCode == 201) &&
          response.data['data'] != null) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      log("Failed to add section: $e");
      throw Exception("Failed to add section: $e");
    }
  }
}
