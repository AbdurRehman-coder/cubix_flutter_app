import 'dart:async';
import 'package:cubix_app/core/utils/app_exports.dart';

class DownloadingWidget extends StatefulWidget {
  const DownloadingWidget({super.key});

  @override
  State<DownloadingWidget> createState() => _DownloadingWidgetState();
}

class _DownloadingWidgetState extends State<DownloadingWidget> {
  String message = "Downloading ...";
  late Timer _timer;
  int _index = 0;

  final List<String> messages = ["Downloading ...", "May Take Up\nto 5 Min..."];

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 2), (timer) {
      setState(() {
        _index = (_index + 1) % messages.length;
        message = messages[_index];
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: Column(
        children: [
          const SizedBox(height: 10),
          Text(
            message,
            style: AppTextStyles.bodyTextStyle.copyWith(
              fontSize: 11,
              color: AppColors.primaryOrangeColor,
            ),
          ),
        ],
      ),
    );
  }
}
