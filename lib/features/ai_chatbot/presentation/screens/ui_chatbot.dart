import '../../../../core/utils/app_exports.dart';

class ChatBotScreen extends StatefulWidget {
  const ChatBotScreen({super.key});

  @override
  State<ChatBotScreen> createState() => _ChatBotScreenState();
}

class _ChatBotScreenState extends State<ChatBotScreen> {
  final TextEditingController controller = TextEditingController();

  final List<String> preDefinedMessages = [
    "A Goal You Want To\nReach",
    "A Skill You Want To\nImprove",
    "A Subject Or Topic You Want To Learn",
    "A Textbook Or Non-Fiction\nBook You Want To Learn\nFrom",
  ];

  final List<String> messages = [];

  void _sendMessage() {
    if (controller.text.isNotEmpty) {
      setState(() {
        messages.add(controller.text);
        controller.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: AppColors.backgroundColor,
      bottomNavigationBar: Padding(
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
          suffixIcon: InkWell(
            onTap: _sendMessage,
            child: Icon(
              Icons.send_rounded,
              color:
                  controller.text.isNotEmpty
                      ? AppColors.primaryOrangeColor
                      : AppColors.textTertiaryColor,
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          child: messages.isEmpty ? _buildDefaultView() : _buildChatView(),
        ),
      ),
    );
  }

  Widget _buildDefaultView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Text(
                'What Do You Want To\nLearn Today?',
                style: AppTextStyles.bodyTextStyle.copyWith(
                  color: AppColors.lightBlackColor,
                  fontWeight: FontWeight.w700,
                  fontSize: 28,
                ),
              ),
            ),
            GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Icon(
                Icons.close_sharp,
                size: 27,
                color: AppColors.lightBlackColor,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Text(
          'Let’s Build A Learning Path Together',
          style: AppTextStyles.bodyTextStyle.copyWith(
            color: AppColors.textTertiaryColor,
            fontWeight: FontWeight.w400,
            fontSize: 14,
          ),
        ),
        const Spacer(),
        Center(
          child: Image.asset(
            AppAssets.appLogoAnimation,
            height: getProportionateScreenHeight(120),
          ),
        ),
        const Spacer(),
        Text(
          'Try Telling Me',
          style: AppTextStyles.bodyTextStyle.copyWith(
            color: AppColors.lightBlackColor,
            fontWeight: FontWeight.w700,
            fontSize: 22,
          ),
        ),
        const SizedBox(height: 20),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 15,
            crossAxisSpacing: 15,
            childAspectRatio: 1.75,
          ),
          itemCount: preDefinedMessages.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                setState(() {
                  controller.text = preDefinedMessages[index];
                });
              },
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.whiteColor,
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 15,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SvgPicture.asset(AppAssets.starsIcon),
                    const SizedBox(height: 4),
                    Text(
                      preDefinedMessages[index],
                      style: AppTextStyles.bodyTextStyle.copyWith(
                        color: AppColors.lightBlackColor,
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildChatView() {
    return Column(
      children: [
        Align(
          alignment: Alignment.topRight,
          child: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Icon(
              Icons.close_sharp,
              size: 27,
              color: AppColors.lightBlackColor,
            ),
          ),
        ),
        SizedBox(height: 20),
        Expanded(
          child: ListView.builder(
            padding: EdgeInsets.zero,
            shrinkWrap: true,
            itemCount: messages.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.whiteColor,
                      borderRadius: BorderRadius.circular(10),
                    ),

                    child: Text(
                      messages[index],
                      style: AppTextStyles.bodyTextStyle.copyWith(
                        color: AppColors.lightBlackColor,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
