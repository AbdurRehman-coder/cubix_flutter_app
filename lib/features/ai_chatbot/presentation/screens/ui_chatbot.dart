import 'dart:developer';

import '../../../../core/utils/app_exports.dart';

class ChatBotScreen extends ConsumerStatefulWidget {
  const ChatBotScreen({super.key});

  @override
  ConsumerState<ChatBotScreen> createState() => _ChatBotScreenState();
}

class _ChatBotScreenState extends ConsumerState<ChatBotScreen> {
  final TextEditingController controller = TextEditingController();
  final ValueNotifier<bool> hasText = ValueNotifier(false);
  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    controller.addListener(() {
      hasText.value = controller.text.isNotEmpty;
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToBottom();
    });
  }

  @override
  void dispose() {
    controller.dispose();
    hasText.dispose();
    scrollController.dispose();
    super.dispose();
  }

  int _lastMessageCount = 0;

  @override
  Widget build(BuildContext context) {
    final initialMessagesAsync = ref.watch(initialMessagesProvider);
    final chatMessages = ref.watch(chatProvider);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_lastMessageCount != chatMessages.length) {
        _lastMessageCount = chatMessages.length;
        _scrollToBottom();
      }
    });

    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: AppColors.backgroundColor,
      bottomNavigationBar: initialMessagesAsync.maybeWhen(
        loading: () => const SizedBox.shrink(),
        orElse:
            () => Padding(
              padding: EdgeInsets.only(
                left: 16,
                right: 16,
                bottom: MediaQuery.of(context).viewInsets.bottom + 10,
              ),
              child: CustomTextField(
                controller: controller,
                borderColor: AppColors.whiteColor,
                maxLines: 1,
                fillColor: AppColors.whiteColor,
                hintText: 'Tell Me Your Idea',
                borderRadius: 8,
                suffixIcon: ValueListenableBuilder<bool>(
                  valueListenable: hasText,
                  builder: (_, value, __) {
                    return InkWell(
                      onTap: value ? _sendMessage : null,
                      child: Icon(
                        Icons.send_rounded,
                        color:
                            value
                                ? AppColors.primaryOrangeColor
                                : AppColors.textTertiaryColor,
                      ),
                    );
                  },
                ),
              ),
            ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          child:
              chatMessages.isEmpty
                  ? initialMessagesAsync.when(
                    data:
                        (data) => DefaultChatView(
                          preDefinedMessages: data ?? [],
                          controller: controller,
                          hasText: hasText,
                        ),
                    loading: () => DefaultChatShimmer(),
                    error:
                        (err, _) => Center(
                          child: Text(
                            "Error loading: $err",
                            style: AppTextStyles.bodyTextStyle.copyWith(
                              fontSize: 14,
                              color: AppColors.textTertiaryColor,
                            ),
                          ),
                        ),
                  )
                  : _buildChatView(chatMessages),
        ),
      ),
    );
  }

  Widget _buildChatView(List<ChatMessage> chatMessages) {
    final currentIndex = ref.watch(bottomNavIndexProvider);
    final notifier = ref.read(bottomNavIndexProvider.notifier);
    return Column(
      children: [
        Align(
          alignment: Alignment.centerRight,
          child: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Icon(
              Icons.close_sharp,
              size: 30,
              color: AppColors.blackColor,
            ),
          ),
        ),
        Expanded(
          child: ListView.builder(
            controller: scrollController,
            padding: EdgeInsets.zero,
            itemCount: chatMessages.length,
            itemBuilder: (context, index) {
              final msg = chatMessages[index];
              final isUser = msg.role == "user";

              // 👇 scroll after the last item (text + options) is rendered
              if (index == chatMessages.length - 1) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  _scrollToBottom();
                });
              }

              return Padding(
                padding: EdgeInsets.only(
                  top: 20,
                  bottom: 6,
                  left: isUser ? 72 : 0,
                  right: isUser ? 0 : 42,
                ),
                child: Align(
                  alignment:
                      isUser ? Alignment.centerRight : Alignment.centerLeft,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      msg.isDownloading
                          ? Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 10,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.whiteColor,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: AppColors.primaryOrangeColor,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Flexible(
                                  child: Text(
                                    msg.content,
                                    style: AppTextStyles.bodyTextStyle.copyWith(
                                      color: AppColors.blackColor,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )
                          : msg.content.contains("downloaded successfully")
                          ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                msg.content,
                                style: AppTextStyles.bodyTextStyle.copyWith(
                                  color: AppColors.blackColor,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(height: 8),
                              GestureDetector(
                                onTap: () {
                                  if (msg.subjectId == null) return;
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder:
                                          (context) => CourseDetailsScreen(
                                            subjectId: msg.subjectId ?? '',
                                            isAssistantSubject: true,
                                          ),
                                    ),
                                  );
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 10,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppColors.blueColor,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Text(
                                    'Go to Course',
                                    style: AppTextStyles.bodyTextStyle.copyWith(
                                      color: AppColors.whiteColor,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          )
                          : msg.isLoading
                          ? Image.asset(
                            'assets/gifs/typing_indicator.gif',
                            height: 50,
                          )
                          : Container(
                            padding: const EdgeInsets.all(15),
                            decoration: BoxDecoration(
                              color:
                                  isUser
                                      ? AppColors.whiteColor
                                      : Colors.transparent,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              msg.content,
                              style: AppTextStyles.bodyTextStyle.copyWith(
                                color: AppColors.blackColor,
                                fontSize: 16,
                              ),
                            ),
                          ),
                      if (msg.options?.isNotEmpty ?? false) ...[
                        const SizedBox(height: 8),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children:
                              msg.options!.map((option) {
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 12),
                                  child: CustomOptionCard(
                                    chatOption: option,
                                    onTap: () async {
                                      if (option.buttonColor == 'primary') {
                                        ref
                                            .read(chatProvider.notifier)
                                            .startDownloading(
                                              msg.finalSubjectTitle ??
                                                  'Subject',
                                            );
                                        if (currentIndex != 1) {
                                          notifier.state = 1;
                                        }
                                        Navigator.pop(context);
                                      } else {
                                        controller.text = option.buttonMessage;
                                        hasText.value = true;
                                        _sendMessage();
                                      }
                                    },
                                  ),
                                );
                              }).toList(),
                        ),
                      ],
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  void _sendMessage() {
    if (controller.text.isNotEmpty) {
      ref.read(chatProvider.notifier).sendMessage(controller.text);
      controller.clear();
      hasText.value = false;
      _scrollToBottom();
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (scrollController.hasClients) {
        Future.delayed(const Duration(milliseconds: 100), () {
          if (scrollController.hasClients) {
            scrollController.animateTo(
              scrollController.position.maxScrollExtent,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOut,
            );
          }
        });
      }
    });
  }
}
