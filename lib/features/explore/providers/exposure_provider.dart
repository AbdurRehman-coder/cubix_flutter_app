import 'package:cubix_app/features/home/models/subject_details_model.dart';
import 'package:cubix_app/core/utils/app_exports.dart';

final subjectDetailProvider = FutureProvider.family<SubjectDetail?, String>((
  ref,
  subjectId,
) async {
  final homeServices = locator.get<HomeServices>();
  return await homeServices.getSubjectDetail(subjectId);
});

final sectionLoadingProvider = StateProvider.family<bool, String>(
  (ref, title) => false,
);

Future<void> createSectionAndRefresh({
  required WidgetRef ref,
  required BuildContext context,
  required String subjectId,
  required String sectionTitle,
}) async {
  final loading = ref.read(sectionLoadingProvider(sectionTitle).notifier);
  loading.state = true;

  try {
    final homeServices = locator.get<HomeServices>();
    final result = await homeServices.addSubjectSection(
      subjectId: subjectId,
      sectionTitle: sectionTitle,
    );

    if (result != null) {
      // ✅ Invalidate the provider to trigger a refetch
      ref.invalidate(subjectDetailProvider(subjectId));
      loading.state = false;
    } else {
      loading.state = false;
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Failed to generate section"),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    }
  } catch (e) {
    loading.state = false;
    debugPrint("Error generating section: $e");

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Failed to generate section"),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }
}
