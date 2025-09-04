import 'package:cubix_app/core/utils/app_exports.dart';
import 'dart:async';
import 'dart:collection';
import 'package:cubix_app/main.dart';

import 'package:equatable/equatable.dart';

class SubjectParams extends Equatable {
  final String subjectId;
  final bool isAssistant;

  const SubjectParams({required this.subjectId, required this.isAssistant});

  @override
  List<Object?> get props => [subjectId, isAssistant];
}


final selectedCategoryProvider = StateProvider<CourseCategory>((ref) {
  return CourseCategory.creativity;
});



final subjectDetailProvider = FutureProvider.autoDispose
    .family<SubjectDetail?, SubjectParams>((ref, params) async {
  final homeServices = locator.get<HomeServices>();
  return await homeServices.getSubjectDetail(params);
});


final sectionLoadingProvider = StateProvider.family<bool, String>(
  (ref, title) => false,
);

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

  Future<void> start(String subjectId, String sectionTitle, {required bool isAssistant}) =>
      _enqueue(subjectId, sectionTitle, silent: false, isAssistant: isAssistant);

  Future<void> startSilent(String subjectId, String sectionTitle, {required bool isAssistant}) =>
      _enqueue(subjectId, sectionTitle, silent: true, isAssistant: isAssistant);

  Future<void> _enqueue(
    String subjectId,
    String sectionTitle, {
    required bool silent,
        required bool isAssistant
  }) {
    final key = "$subjectId|$sectionTitle";

    if (_inflight.contains(key)) {
      if (!silent) {
        state = {...state, key};
      }
      return Future.value();
    }

    if (_inflight.contains(key)) return Future.value();

    _inflight.add(key);
    if (!silent) state = {...state, key};

    final q = _queues.putIfAbsent(subjectId, () => Queue<_Task>());
    final task = _Task(subjectId, sectionTitle, silent);
    q.add(task);

    _runQueue(subjectId, isAssistant);
    return task.completer.future;
  }

  Future<void> _runQueue(String subjectId, bool isAssistant) async {
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
            subjectType: isAssistant ? "custom": "default"
          );

          if (result != null) {
            analytics.logSubjectDownloaded(
              subjectId: t.subjectId,
              sectionTitle: t.sectionTitle,
            );

            // ✅ refresh immediately after each successful section
            // ignore: unused_result
            await ref.refresh(subjectDetailProvider(SubjectParams(subjectId: t.subjectId, isAssistant: isAssistant)).future);
          } else if (!t.silent) {
            _showErrorSnackbar("Failed to generate section. Please try again.");
          }
        } catch (_) {
          if (!t.silent) {
            _showErrorSnackbar("Failed to generate section. Please try again.");
          }
        } finally {
          _inflight.remove(key);

          // ✅ Always remove from state if it was marked loading (silent or not)
          if (state.contains(key)) {
            state = {...state}..remove(key);
          }

          if (!t.completer.isCompleted) {
            t.completer.complete();
          }
        }
      }
    } finally {
      _running.remove(subjectId);
      if ((_queues[subjectId]?.isNotEmpty ?? false)) {
        scheduleMicrotask(() => _runQueue(subjectId, isAssistant));
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
