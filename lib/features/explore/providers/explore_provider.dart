import 'dart:developer';
import 'package:cubix_app/core/utils/app_exports.dart';

final selectedCategoryProvider = StateProvider<CourseCategory>((ref) {
  return CourseCategory.creativity;
});

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

/// Global map to track active downloads for each subject-section
final Map<String, Future> _activeDownloads = {};

Future<void> createSectionAndRefresh({
  required WidgetRef ref,
  required BuildContext context,
  required String subjectId,
  required String sectionTitle,
}) async {
  final loading = ref.read(sectionLoadingProvider(sectionTitle).notifier);
  final key = "$subjectId|$sectionTitle";

  // If already downloading silently or manually, just wait for it
  if (_activeDownloads.containsKey(key)) {
    loading.state = true;
    await _activeDownloads[key];
    loading.state = false;
    return;
  }

  loading.state = true;

  final future = _downloadSection(
    ref: ref,
    context: context,
    subjectId: subjectId,
    sectionTitle: sectionTitle,
    showErrors: true,
  );

  _activeDownloads[key] = future;

  await future;
  _activeDownloads.remove(key);

  loading.state = false;
}

Future<void> createSectionSilently({
  required WidgetRef ref,
  required BuildContext context,
  required String subjectId,
  required String sectionTitle,
}) async {
  final key = "$subjectId|$sectionTitle";

  // If already downloading silently or manually, skip
  if (_activeDownloads.containsKey(key)) {
    return;
  }

  log('Section is downloading secretly');

  final future = _downloadSection(
    ref: ref,
    context: context,
    subjectId: subjectId,
    sectionTitle: sectionTitle,
    showErrors: false, // no snackbars in silent mode
  );

  _activeDownloads[key] = future;

  await future;
  _activeDownloads.remove(key);
}

Future<void> _downloadSection({
  required WidgetRef ref,
  required BuildContext context,
  required String subjectId,
  required String sectionTitle,
  required bool showErrors,
}) async {
  try {
    final homeServices = locator.get<HomeServices>();
    final result = await homeServices.addSubjectSection(
      subjectId: subjectId,
      sectionTitle: sectionTitle,
    );

    if (result != null) {
      locator.get<AnalyticServices>().logSubjectDownloaded(
        sectionTitle: sectionTitle,
        subjectId: subjectId,
      );
      ref.invalidate(subjectDetailProvider(subjectId));
    } else if (showErrors && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Failed to generate section. Please try again"),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  } catch (e) {
    debugPrint("Error generating section: $e");
    if (showErrors && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Failed to generate section. Please try again."),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }
}

final downloadManagerProvider =
    StateNotifierProvider<DownloadManager, Set<String>>((ref) {
      return DownloadManager(ref);
    });

class DownloadManager extends StateNotifier<Set<String>> {
  final Ref ref;
  final Map<String, Future> _active = {};

  DownloadManager(this.ref) : super({});

  Future<void> start(String subjectId, String sectionTitle) async {
    final key = "$subjectId|$sectionTitle";
    if (_active.containsKey(key)) return;

    state = {...state, key}; // mark as downloading

    final future = locator.get<HomeServices>().addSubjectSection(
      subjectId: subjectId,
      sectionTitle: sectionTitle,
    );

    _active[key] = future;

    final result = await future;
    _active.remove(key);

    state = {...state}..remove(key);

    if (result != null) {
      locator.get<AnalyticServices>().logSubjectDownloaded(
        sectionTitle: sectionTitle,
        subjectId: subjectId,
      );
      ref.invalidate(subjectDetailProvider(subjectId)); // safe refresh
    }
  }
}
