import 'package:cubix_app/core/utils/app_exports.dart';
import 'package:cubix_app/features/lessons/data/progress_services.dart';

import '../models/progress_model.dart';

final progressProvider = FutureProvider<List<ProgressModel>?>((ref) async {
  final progressServices = locator.get<ProgressServices>();
  return await progressServices.getAllProgress();
});

final selectedTabProvider = StateProvider<int>((ref) => 0);
