import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart' show Iconsax;
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:producty/config/router/app_router.gr.dart';
import 'package:producty/feature/auth/data/model/auth_session.dart';
import 'package:producty/feature/auth/presentation/providers/auth_notifier.dart';
import 'package:producty/feature/auth/presentation/providers/auth_state.dart';

import '../../../../common/components/index.dart';
import '../../../../config/router/app_router.dart';
import '../../../../widgets/custom_toast.dart';
import '../../data/dto/request_otp_dto.dart';
import '../../data/dto/verify_otp_dto.dart';
import '../widgets/otp_pin_field.dart';

@RoutePage()
class OTPScreen extends HookConsumerWidget {
  final String email;
  const OTPScreen({
    super.key,
    //  this.email = "bamideledavid.femi@gmail.com",

    required this.email,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final controller = useTextEditingController();
    final isDark = theme.brightness == Brightness.dark;
    final otpCode = useState('');
    final countdown = useState(60);
    final errorController = useMemoized(
      () => StreamController<ErrorAnimationType>(),
    );
    final hasError = useState(false);

    bool isLoading() => ref.watch(authStateNotifierProvider) is AuthLoading;

    final timerRef = useRef<Timer?>(null);

    // Start or restart the countdown timer
    void startTimer() {
      timerRef.value?.cancel();
      countdown.value = 30;
      timerRef.value = Timer.periodic(const Duration(seconds: 1), (t) {
        if (countdown.value > 0) {
          countdown.value -= 1;
        } else {
          t.cancel();
        }
      });
    }

    useEffect(() {
      startTimer();
      return () => timerRef.value?.cancel();
    }, []);

    ref.listen(
      authStateNotifierProvider,
      (prev, next) {
        if (next is AuthFailure || next is ResendOtpFailure) {
          final failure = (next as dynamic).failure;

          showToast(failure.message, context, isError: true);
        } else if (next is AuthSuccess) {
          final isExisting = next.session.status == AuthStatus.existing;

          Nav.replace(context, SuccessRoute(isExisting: isExisting));
        }
      },
    );

    Future<void> resendOtp() async {
      await ref.read(authStateNotifierProvider.notifier).resendOtp(
            RequestOtpDto(email: email),
          );
    }

    void onVerify() {
      if (otpCode.value.length != 6) {
        errorController.add(ErrorAnimationType.shake);
        hasError.value = true;
      } else {
        final otp = VerifyOtpDto(email: email, code: otpCode.value);
        ref.read(authStateNotifierProvider.notifier).verifyOtp(otp);
      }
    }

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: isDark ? const Color(0xFF28282A) : Colors.white,
        appBar: AppBar(
          backgroundColor: isDark ? const Color(0xFF28282A) : Colors.white,
          leading: IconButton(
            icon: Icon(
              Iconsax.arrow_left,
              color: isDark ? Colors.white : const Color(0xFF3D3D3D),
            ),
            onPressed: () => context.router.pop(),
          ),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Enter OTP',
                style: theme.textTheme.displaySmall?.copyWith(
                  color: isDark ? Colors.white : const Color(0xFF3D3D3D),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                "We've sent a verification code to",
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: isDark
                      ? const Color(0xFF7B7B80)
                      : const Color(0xFF616161),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                email,
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: isDark ? Colors.white : const Color(0xFF3D3D3D),
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 32),
              OtpPinField(
                controller: controller,
                onChanged: (value) {
                  hasError.value = false;
                  otpCode.value = value;
                },
                errorController: errorController,
                onCompleted: (value) {
                  otpCode.value = value;
                  //  ref.read(otpVerificationProvider.notifier).verifyOtp(value);
                },
              ),
              if (hasError.value)
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Text(
                    'Invalid code. Please try again.',
                    style: TextStyle(color: theme.colorScheme.error),
                  ),
                ),
              const SizedBox(height: 32),
              AppButton(
                onPressed: onVerify,
                text: isLoading() ? 'Verifying...' : 'Verify',
                isLoading: isLoading(),
                color: const Color(0xFF3D3D3D),
                labelColor: Colors.white,
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Didn't receive code? ",
                    style: GoogleFonts.dmSans(
                      fontSize: 14,
                      color: isDark
                          ? const Color(0xFF7B7B80)
                          : const Color(0xFF616161),
                    ),
                  ),
                  GestureDetector(
                    onTap: countdown.value > 0
                        ? null
                        : () {
                            startTimer();

                            resendOtp();
                          },
                    behavior: HitTestBehavior.translucent,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 2.0,
                        vertical: 8.0,
                      ), // expands tappable area
                      child: Text(
                        countdown.value > 0
                            ? 'Resend in ${countdown.value}s'
                            : 'Resend',
                        style: GoogleFonts.dmSans(
                          fontSize: 14,
                          color: countdown.value > 0
                              ? (isDark
                                  ? const Color(0xFF7B7B80)
                                  : const Color(0xFF616161))
                              : const Color(0xFF3D3D3D),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
