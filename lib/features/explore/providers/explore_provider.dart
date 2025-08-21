import 'dart:developer';
import 'package:cubix_app/core/utils/app_exports.dart';
import 'dart:async';
import 'dart:collection';
import 'package:cubix_app/main.dart';

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
    StateNotifierProvider<DownloadManager, Set<String>>(
      (ref) => DownloadManager(ref),
    );

class _Task {
  final String subjectId, sectionTitle;
  final bool silent;
  final Completer<void> completer = Completer();
  _Task(this.subjectId, this.sectionTitle, this.silent);
}

class DownloadManager extends StateNotifier<Set<String>> {
  final Ref ref;
  final _queues = <String, Queue<_Task>>{};
  final _running = <String>{};
  final _inflight = <String>{};

  DownloadManager(this.ref) : super({});

  Future<void> start(String subjectId, String sectionTitle) =>
      _enqueue(subjectId, sectionTitle, silent: false);

  Future<void> startSilent(String subjectId, String sectionTitle) =>
      _enqueue(subjectId, sectionTitle, silent: true);

  Future<void> _enqueue(
    String subjectId,
    String sectionTitle, {
    required bool silent,
  }) {
    final key = "$subjectId|$sectionTitle";
    if (_inflight.contains(key)) return Future.value();

    _inflight.add(key);
    if (!silent) state = {...state, key};

    final q = _queues.putIfAbsent(subjectId, () => Queue<_Task>());
    final task = _Task(subjectId, sectionTitle, silent);
    q.add(task);

    _runQueue(subjectId);
    return task.completer.future;
  }

  Future<void> _runQueue(String subjectId) async {
    if (_running.contains(subjectId)) return;
    _running.add(subjectId);

    final home = locator.get<HomeServices>();
    final analytics = locator.get<AnalyticServices>();

    try {
      final q = _queues[subjectId]!;
      while (q.isNotEmpty) {
        final t = q.removeFirst();
        final key = "${t.subjectId}|${t.sectionTitle}";

        try {
          final result = await home.addSubjectSection(
            subjectId: t.subjectId,
            sectionTitle: t.sectionTitle,
          );

          if (result != null) {
            analytics.logSubjectDownloaded(
              subjectId: t.subjectId,
              sectionTitle: t.sectionTitle,
            );

            // ✅ refresh immediately after each successful section
            await ref.refresh(subjectDetailProvider(t.subjectId).future);
          } else if (!t.silent) {
            _showErrorSnackbar("Failed to generate section. Please try again.");
          }
        } catch (_) {
          if (!t.silent) {
            _showErrorSnackbar("Failed to generate section. Please try again.");
          }
        } finally {
          _inflight.remove(key);
          if (!t.silent) state = {...state}..remove(key);
          if (!t.completer.isCompleted) t.completer.complete();
        }
      }
    } finally {
      _running.remove(subjectId);
      if ((_queues[subjectId]?.isNotEmpty ?? false)) {
        scheduleMicrotask(() => _runQueue(subjectId));
      }
    }
  }

  void _showErrorSnackbar(String msg) {
    final context = navigatorKey.currentContext;
    if (context != null && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(msg), backgroundColor: Colors.redAccent),
      );
    }
  }
}
