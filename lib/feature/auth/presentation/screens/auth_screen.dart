import 'dart:async';

import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:producty/config/router/app_router.gr.dart';
import 'package:producty/feature/auth/presentation/extensions/string_extensions.dart';
import 'package:producty/feature/auth/presentation/providers/auth_notifier.dart';
import 'package:producty/feature/auth/presentation/providers/auth_state.dart';
import 'package:producty/feature/auth/presentation/widgets/authentication_container.dart';
import 'package:producty/widgets/custom_toast.dart';

import '../../../../common/components/index.dart';
import '../../../../config/router/app_router.dart';
import '../../../../config/theme/theme.dart';
import '../../../../core/constants/assets.dart';
import '../../../../core/constants/colors.dart';
import '../../data/dto/request_otp_dto.dart';
import '../widgets/banner_slider.dart';
import '../widgets/help_bottom_sheet.dart';
import '../widgets/social_icon_button.dart';

part 'intro_slides.dart';

@RoutePage()
class AuthenticationScreen extends HookConsumerWidget {
  const AuthenticationScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;

    final emailFocusNode = useFocusNode();
    final email = useTextEditingController();

    final formKey = useMemoized(() => GlobalKey<FormState>());
    final rememberMe = useState(false);

    Timer? autoPlayTimer; // dispose this

    final currentPage = useState(0);
    final pageController = usePageController();

    void onPageChanged(index) => currentPage.value = index;

    void startAutoPlay() {
      autoPlayTimer?.cancel();

      if (_introSlides.isEmpty) return;

      autoPlayTimer = Timer.periodic(const Duration(seconds: 3), (timer) {
        final nextPage = (currentPage.value + 1) % _introSlides.length;
        if (pageController.hasClients) {
          pageController.animateToPage(
            nextPage,
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOut,
          );
        }
      });
    }

    Future<void> handleContinue() async {
      if (!formKey.currentState!.validate()) return;

      final requestDto = RequestOtpDto(
        email: email.text.trim().toLowerCase(),
      );

      await ref.read(authStateNotifierProvider.notifier).sendOtp(requestDto);
    }

    useEffect(() {
      startAutoPlay();
      return () {
        autoPlayTimer?.cancel();
      };
    }, []);

    ref.listen(
      authStateNotifierProvider,
      (prev, next) {
        if (next is OtpSendFailure) {
          showToast(next.failure.message, context, isError: true);
        } else if (next is OtpSentSuccess) {
          Nav.push(context, OTPRoute(email: email.text.trim().toLowerCase()));
        }
      },
    );

    bool isLoading() => ref.watch(authStateNotifierProvider) is OtpSendloading;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: AppTheme.background(context),
        appBar: AppBar(
          backgroundColor: AppTheme.background(context),
          elevation: 0,
          leadingWidth: 123,
          leading: Padding(
            padding: const EdgeInsets.only(left: 20),
            child: SvgPicture.asset(
              theme.brightness == Brightness.dark
                  ? AppAssets.logoDark
                  : AppAssets.logo,
              width: 103,
              height: 30,
              fit: BoxFit.contain,
            ),
          ),
          actions: [
            Container(
              margin: const EdgeInsets.only(right: 20),
              child: Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: theme.brightness == Brightness.dark
                      ? AppColors.darkSurface
                      : AppColors.darkText,
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  icon: Icon(
                    Iconsax.message_question,
                    color: theme.colorScheme.onSurface,
                    size: 20,
                  ),
                  onPressed: () => handleNeedHelp(context),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ),
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: size.height * 0.33,
                      child: PageView.builder(
                        controller: pageController,
                        onPageChanged: onPageChanged,
                        itemCount: _introSlides.length,
                        itemBuilder: (context, index) {
                          final slide = _introSlides[index];
                          return SingleChildScrollView(
                            child: BannerView(
                              image: slide.image,
                              title: slide.title,
                              description: slide.description,
                              brightness: theme.brightness,
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 30, top: 4),
                child: Dots(
                  currentPage: currentPage.value,
                  length: _introSlides.length,
                ),
              ),
              AuthenticationContainer(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Email address',
                      style: GoogleFonts.dmSans(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: theme.brightness == Brightness.dark
                            ? const Color(0xFF99999F)
                            : const Color(0xFF3D3D3D),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Form(
                      key: formKey,
                      child: AppTextField(
                        controller: email,
                        focusNode: emailFocusNode,
                        placeholder: 'Enter your email',
                        icon: Iconsax.sms,
                        keyboardType: TextInputType.emailAddress,
                        validator: (email) => email?.trim().validateEmail(),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 24,
                          height: 24,
                          child: Checkbox(
                            value: rememberMe.value,
                            onChanged: (value) =>
                                rememberMe.value = value ?? false,
                            activeColor: AppTheme.surface(context),
                            checkColor: AppTheme.surface(context, invert: true),
                            side: BorderSide(
                              color: AppTheme.surface(context),
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Remember me',
                          style: GoogleFonts.dmSans(
                            fontSize: 14,
                            color: const Color(0xFF8E8E93),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    AppButton(
                      onPressed: handleContinue,
                      text: 'Login/Signup',
                      isLoading: isLoading(),
                      color: AppColors.dark,
                      labelColor: Colors.white,
                    ),
                    const SizedBox(height: 24),
                    Row(
                      children: [
                        Expanded(
                          child: Divider(
                            color: theme.brightness == Brightness.dark
                                ? AppColors.dark
                                : const Color(0xFFE5E5EA),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Text(
                            'or continue with',
                            style: GoogleFonts.dmSans(
                              fontSize: 14,
                              color: const Color(0xFF8E8E93),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Divider(
                            color: theme.brightness == Brightness.dark
                                ? AppColors.dark
                                : const Color(0xFFE5E5EA),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          children: [
                            SocialIconButton(
                              onPressed: () {
                                // Handle Google sign in
                              },
                              icon: FontAwesomeIcons.google,
                            ),
                            const SizedBox(width: 16),
                            SocialIconButton(
                              onPressed: () {
                                // Handle Facebook sign in
                              },
                              icon: FontAwesomeIcons.facebook,
                            ),
                          ],
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
