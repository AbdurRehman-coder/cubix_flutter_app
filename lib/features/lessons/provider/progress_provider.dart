import 'package:cubix_app/core/utils/app_exports.dart';

final progressProvider = FutureProvider.autoDispose<List<ProgressModel>?>((
  ref,
) async {
  final progressServices = locator.get<ProgressServices>();
  return await progressServices.getAllProgress();
});

final selectedTabProvider = StateProvider<int>((ref) => 0);
