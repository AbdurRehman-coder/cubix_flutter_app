import 'package:cubix_app/core/utils/app_exports.dart';

final bannerPageProvider = StateProvider<int>((ref) => 0);

final subjectsProvider = FutureProvider<SubjectsData?>((ref) async {
  final homeServices = locator.get<HomeServices>();
  return await homeServices.getSubjects();
});
