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

  @override
  Widget build(BuildContext context) {
    final initialMessagesAsync = ref.watch(initialMessagesProvider);
    final chatMessages = ref.watch(chatProvider);

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
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color:
                              isUser
                                  ? AppColors.whiteColor
                                  : Colors.transparent,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child:
                            msg.isLoading
                                ? Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: const [
                                    SizedBox(
                                      width: 6,
                                      height: 6,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                      ),
                                    ),
                                    SizedBox(width: 8),
                                    Text("Thinking..."),
                                  ],
                                )
                                : Text(
                                  msg.content,
                                  style: AppTextStyles.bodyTextStyle.copyWith(
                                    color: AppColors.lightBlackColor,
                                    fontSize: 14,
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
                                    onTap: () {
                                      controller.text = option.buttonMessage;
                                      hasText.value = true;
                                      _sendMessage();
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
        scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }
}
