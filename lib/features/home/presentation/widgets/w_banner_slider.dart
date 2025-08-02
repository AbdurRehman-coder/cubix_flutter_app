import 'package:cubix_app/core/utils/app_exports.dart';
import 'package:cubix_app/features/home/data/home_mock_data.dart';
import 'package:cubix_app/features/home/models/home_banner_model.dart';
import 'package:cubix_app/features/home/presentation/widgets/w_dot_indicator.dart';
import 'package:cubix_app/features/home/providers/home_provider.dart';

import 'dart:async';

class HomeBannerSlider extends ConsumerStatefulWidget {
  const HomeBannerSlider({super.key});

  @override
  ConsumerState<HomeBannerSlider> createState() => _HomeBannerSliderState();
}

class _HomeBannerSliderState extends ConsumerState<HomeBannerSlider> {
  late PageController _controller;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _controller = PageController();

    _timer = Timer.periodic(const Duration(seconds: 3), (timer) {
      final currentIndex = _controller.page?.round() ?? 0;
      final nextPage = (currentIndex + 1) % homeBannerList.length;

      _controller.animateToPage(
        nextPage,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );

      ref.read(bannerPageProvider.notifier).state = nextPage;
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentPage = ref.watch(bannerPageProvider);

    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: SizedBox(
        height: getProportionateScreenHeight(170),
        child: PageView.builder(
          controller: _controller,

          itemCount: homeBannerList.length,
          onPageChanged:
              (index) => ref.read(bannerPageProvider.notifier).state = index,
          itemBuilder: (context, index) {
            final banner = homeBannerList[index];
            return Stack(
              fit: StackFit.expand,
              children: [
                ColoredBannerBackground(theme: banner.colorTheme),
                Positioned(
                  left: 45,
                  top: 45,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        banner.title,
                        style: AppTextStyles.bodyTextStyle.copyWith(
                          color: AppColors.whiteColor,
                          fontSize: 18,
                          wordSpacing: 1.5,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        banner.subtitle,
                        style: AppTextStyles.bodyTextStyle.copyWith(
                          color: AppColors.whiteColor,
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  bottom: 10,
                  right: 0,
                  left: 0,
                  child: DotIndicator(
                    currentIndex: currentPage,
                    length: homeBannerList.length,
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class ColoredBannerBackground extends StatelessWidget {
  final BannerThemeColor theme;
  const ColoredBannerBackground({super.key, required this.theme});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Stack(
        fit: StackFit.expand,
        children: [
          Container(color: theme.background),
          Positioned(
            right: 100,
            top: -20,
            child: Container(
              height: 386,
              width: 441,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: theme.circle1,
              ),
            ),
          ),
          Positioned(
            right: -85,
            top: -60,
            child: Container(
              height: 202,
              width: 182,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: theme.circle2,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
