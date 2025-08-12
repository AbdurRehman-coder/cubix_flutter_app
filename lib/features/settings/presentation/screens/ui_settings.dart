import 'package:cubix_app/core/utils/app_exports.dart';
import 'package:cubix_app/core/utils/app_utils.dart';
import 'package:cubix_app/features/settings/providers/settings_provider.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  GoogleUserData? _googleUser;

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  Future<void> _loadUser() async {
    final googleService = GoogleAuthService();
    final user = await googleService.signInSilently();
    setState(() {
      _googleUser = user;
    });
  }

  @override
  Widget build(BuildContext context) {
    final notifications = ref.watch(notificationsProvider);
    final sounds = ref.watch(soundsProvider);
    final haptics = ref.watch(hapticsProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Header
        Container(
          decoration: BoxDecoration(
            color: AppColors.whiteColor,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(30),
              bottomRight: Radius.circular(30),
            ),
          ),
          padding: const EdgeInsets.fromLTRB(35, 56, 35, 21),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),
              Text(
                'Settings',
                style: AppTextStyles.headingTextStyle.copyWith(
                  fontSize: 30,
                  fontWeight: FontWeight.w700,
                  color: AppColors.blackColor,
                ),
              ),
              SizedBox(height: 4),
              Text(
                'Set up your account',
                style: AppTextStyles.bodyTextStyle.copyWith(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: AppColors.textSecondaryColor,
                ),
              ),
            ],
          ),
        ),

        Expanded(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Profile Section
                Padding(
                  padding: const EdgeInsets.all(30),
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.whiteColor,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: const EdgeInsets.all(16),
                    child: ListTile(
                      contentPadding: EdgeInsets.zero,
                      minTileHeight: getProportionateScreenHeight(48),

                      leading:
                          _googleUser?.account.photoUrl != null
                              ? CircleAvatar(
                                radius: 24,
                                backgroundImage: NetworkImage(
                                  _googleUser!.account.photoUrl!,
                                ),
                              )
                              : CircleAvatar(
                                radius: 24,
                                backgroundColor: AppColors.primaryOrangeColor,
                                child: Text(
                                  AppUtils().getInitials(
                                    _googleUser?.account.displayName,
                                  ),
                                  style: AppTextStyles.bodyTextStyle.copyWith(
                                    color: AppColors.whiteColor,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),

                      title: Text(
                        _googleUser?.account.displayName ?? 'Guest User',
                        style: AppTextStyles.bodyTextStyle.copyWith(
                          color: const Color(0xff282A37),
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),

                      subtitle: Text(
                        _googleUser?.account.email ?? '',
                        style: AppTextStyles.bodyTextStyle.copyWith(
                          color: const Color(0xff8E8E93),
                          fontSize: 11,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ),
                ),

                // General Section
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 31),
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.whiteColor,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'GENERAL',
                          style: AppTextStyles.bodyTextStyle.copyWith(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: Color(0xff8E8E93),
                          ),
                        ),

                        // Notifications
                        _buildToggleItem(
                          icon: 'assets/icons/notification_icon.svg',
                          title: 'Notifications',
                          value: notifications,
                          onChanged: (value) {
                            // ref.read(notificationsProvider.notifier).state =
                            //     value;
                          },
                        ),

                        const Divider(
                          height: 1,
                          indent: 0,
                          color: Color(0xffF6F7F9),
                        ),

                        // Sounds
                        _buildToggleItem(
                          icon: 'assets/icons/sounds_icon.svg',
                          title: 'Sounds',
                          value: sounds,
                          onChanged: (value) {
                            ref.read(soundsProvider.notifier).state = value;
                          },
                        ),

                        const Divider(
                          height: 1,
                          indent: 0,
                          color: Color(0xffF6F7F9),
                        ),

                        // Haptics
                        _buildToggleItem(
                          icon: 'assets/icons/heptic_icon.svg',
                          title: 'Haptics',
                          value: haptics,
                          onChanged: (value) {
                            ref.read(hapticsProvider.notifier).state = value;
                          },
                        ),

                        const Divider(
                          height: 1,
                          indent: 0,
                          color: Color(0xffF6F7F9),
                        ),

                        // Support Email
                        _buildNavigationItem(
                          icon: 'assets/icons/support_icon.svg',
                          title: 'Support Email',
                          onTap: () {
                            // Handle support email tap
                          },
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // Legal Section
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 31),
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.whiteColor,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'LEGAL',
                          style: AppTextStyles.bodyTextStyle.copyWith(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: Color(0xff8E8E93),
                          ),
                        ),
                        SizedBox(height: 4),
                        // Privacy Policy
                        _buildNavigationItem(
                          icon: 'assets/icons/privacy_icon.svg',
                          title: 'Privacy Policy',
                          onTap: () {
                            // Handle privacy policy tap
                          },
                        ),

                        const Divider(
                          height: 1,
                          indent: 0,
                          color: Color(0xffF6F7F9),
                        ),

                        // Terms & Conditions
                        _buildNavigationItem(
                          icon: 'assets/icons/file_icon.svg',
                          title: 'Terms & Conditions',
                          onTap: () {
                            // Handle terms tap
                          },
                        ),

                        const Divider(
                          height: 1,
                          indent: 0,
                          color: Color(0xffF6F7F9),
                        ),

                        // Delete Account
                        _buildNavigationItem(
                          icon: 'assets/icons/delete_icon.svg',
                          title: 'Delete Account',
                          onTap: () {
                            showDeleteDialog(context);
                          },
                        ),
                      ],
                    ),
                  ),
                ),

                // Logout Button
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 48,
                    vertical: 35,
                  ),
                  child: PrimaryButton(
                    borderRadius: 12,
                    height: 48,
                    backgroundColor: AppColors.blueColor,
                    icon: Padding(
                      padding: const EdgeInsets.only(right: 5),
                      child: const Icon(
                        Icons.logout,
                        color: AppColors.whiteColor,
                        size: 20,
                      ),
                    ),
                    iconLeading: false,
                    text: 'Logout',
                    onPressed: () {
                      showLogoutDialog(context);
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildToggleItem({
    required String icon,
    required String title,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 9),
      child: Row(
        children: [
          SvgPicture.asset(
            icon,
            colorFilter: ColorFilter.mode(
              AppColors.blackColor,
              BlendMode.srcIn,
            ),
            height: 24,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              title,
              style: AppTextStyles.bodyTextStyle.copyWith(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: AppColors.whiteColor,
            activeTrackColor: AppColors.primaryOrangeColor,
            inactiveThumbColor: AppColors.whiteColor,
            inactiveTrackColor: AppColors.greyColor.withValues(alpha: 0.3),
          ),
        ],
      ),
    );
  }

  Widget _buildNavigationItem({
    required String icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Row(
          children: [
            SvgPicture.asset(
              icon,
              colorFilter: ColorFilter.mode(
                AppColors.blackColor,
                BlendMode.srcIn,
              ),
              height: 24,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                style: AppTextStyles.bodyTextStyle.copyWith(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const Icon(
              Icons.chevron_right,
              color: AppColors.greyColor,
              size: 24,
            ),
          ],
        ),
      ),
    );
  }

  void showDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (_) => CustomDialog(
            title: 'Delete Account',
            showBackIcon: true,
            icon: Center(
              child: SvgPicture.asset(
                'assets/icons/delete_icon.svg',
                height: getProportionateScreenHeight(88),
                width: getProportionateScreenWidth(92),
                colorFilter: ColorFilter.mode(
                  AppColors.primaryOrangeColor,
                  BlendMode.srcIn,
                ),
              ),
            ),
            description:
                'Are you sure you want to delete your account? This action cannot be undone.',
            buttonText: 'Delete',
            onPressed: () {
              locator.get<AuthServices>().handleDelete(context);
            },
          ),
    );
  }

  void showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (_) => CustomDialog(
            showBackIcon: true,
            title: 'Logout?',
            icon: Icon(
              Icons.logout_rounded,
              size: 90,
              color: AppColors.primaryOrangeColor,
            ),
            description: 'Are you sure you want to logout?',
            buttonText: 'Yes',
            onPressed: () {
              locator.get<AuthServices>().handleSignOut(context);
            },
          ),
    );
  }
}
