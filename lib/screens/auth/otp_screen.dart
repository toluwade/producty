import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_toast.dart';

class OTPScreen extends StatefulWidget {
  final String email;
  final bool isExisting;
  
  const OTPScreen({
    super.key,
    required this.email,
    required this.isExisting,
  });

  @override
  State<OTPScreen> createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  final List<TextEditingController> _controllers = List.generate(
    6,
    (index) => TextEditingController(),
  );
  final List<FocusNode> _focusNodes = List.generate(
    6,
    (index) => FocusNode(),
  );
  
  Timer? _resendTimer;
  int _resendCountdown = 30;
  bool _isLoading = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _startResendTimer();
    
    // Add listeners to focus nodes
    for (var i = 0; i < _focusNodes.length; i++) {
      _focusNodes[i].addListener(() {
        setState(() {});
      });
    }
  }

  @override
  void dispose() {
    _resendTimer?.cancel();
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  void _startResendTimer() {
    _resendTimer?.cancel();
    setState(() {
      _resendCountdown = 30;
    });
    
    _resendTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_resendCountdown > 0) {
        setState(() {
          _resendCountdown--;
        });
      } else {
        timer.cancel();
      }
    });
  }

  Future<void> _handleVerify() async {
    final otp = _controllers.map((c) => c.text).join();
    
    if (otp.length != 6) {
      setState(() {
        _error = 'Please enter all digits';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      // For testing, accept any 6-digit OTP
      await Future.delayed(const Duration(milliseconds: 500));
      
      if (!mounted) return;

      // Get isExisting from preferences
      final prefs = await SharedPreferences.getInstance();
      final isExisting = prefs.getBool('is_existing') ?? false;
      
      // Navigate to success screen with appropriate message
      if (mounted) {
        Navigator.pushReplacementNamed(
          context,
          '/success',
          arguments: {
            'isExisting': isExisting,
            'email': widget.email,
          },
        );
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = 'Invalid OTP. Please try again.';
        _isLoading = false;
      });
    }
  }

  void _handleResend() {
    if (_resendCountdown > 0) return;
    
    CustomToast.show(context, 'OTP resent successfully');
    _startResendTimer();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF28282A) : Colors.white,
      appBar: AppBar(
        backgroundColor: isDark ? const Color(0xFF28282A) : Colors.white,
        leading: IconButton(
          icon: Icon(
            Iconsax.arrow_left,
            color: isDark ? Colors.white : const Color(0xFF3D3D3D),
          ),
          onPressed: () => Navigator.pop(context),
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
                color: isDark ? const Color(0xFF7B7B80) : const Color(0xFF616161),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              widget.email,
              style: theme.textTheme.bodyLarge?.copyWith(
                color: isDark ? Colors.white : const Color(0xFF3D3D3D),
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(6, (index) {
                return Container(
                  width: 48,
                  height: 56,
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF1C1C1E) : const Color(0xFFF3F3F3),
                    borderRadius: BorderRadius.circular(12),
                    border: _focusNodes[index].hasFocus
                        ? Border.all(
                            color: isDark
                                ? const Color(0xFF3D3D3D)
                                : const Color(0xFFDEDEDE),
                            width: 1,
                          )
                        : null,
                  ),
                  child: TextField(
                    controller: _controllers[index],
                    focusNode: _focusNodes[index],
                    textAlign: TextAlign.center,
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(1),
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                    style: GoogleFonts.dmSans(
                      fontSize: 20,
                      color: isDark ? Colors.white : const Color(0xFF3D3D3D),
                    ),
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      counterText: '',
                    ),
                    onChanged: (value) {
                      if (value.isNotEmpty && index < 5) {
                        _focusNodes[index + 1].requestFocus();
                      }
                      setState(() {
                        _error = null;
                      });
                    },
                  ),
                );
              }),
            ),
            if (_error != null) ...[
              const SizedBox(height: 16),
              Text(
                _error!,
                style: GoogleFonts.dmSans(
                  fontSize: 14,
                  color: Colors.red,
                ),
              ),
            ],
            const SizedBox(height: 32),
            CustomButton(
              onPressed: _handleVerify,
              text: _isLoading ? 'Verifying...' : 'Verify',
              isLoading: _isLoading,
              color: const Color(0xFF3D3D3D),
              labelColor: Colors.white,
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Didn't receive code? ",
                  style: GoogleFonts.dmSans(
                    fontSize: 14,
                    color: isDark ? const Color(0xFF7B7B80) : const Color(0xFF616161),
                  ),
                ),
                TextButton(
                  onPressed: _handleResend,
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: Text(
                    _resendCountdown > 0
                        ? 'Resend in ${_resendCountdown}s'
                        : 'Resend',
                    style: GoogleFonts.dmSans(
                      fontSize: 14,
                      color: _resendCountdown > 0
                          ? (isDark ? const Color(0xFF7B7B80) : const Color(0xFF616161))
                          : const Color(0xFF3D3D3D),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
