import 'package:cubix_app/core/services/app_services.dart';
import 'package:cubix_app/features/home/data/home_services.dart';
import 'package:cubix_app/features/home/models/subject_details_model.dart';
import 'package:cubix_app/features/home/models/subject_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cubix_app/core/utils/app_exports.dart';

final bannerPageProvider = StateProvider<int>((ref) => 0);

final subjectsProvider = FutureProvider<SubjectsData?>((ref) async {
  final homeServices = locator.get<HomeServices>();
  return await homeServices.getSubjects();
});
