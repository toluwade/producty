import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../application/auth_manager.dart';
import '../../data/dto/request_otp_dto.dart';
import '../../data/dto/verify_otp_dto.dart';
import '../../data/repository/auth_repository.dart';
import 'auth_state.dart';

class AuthStateNotifier extends StateNotifier<AuthState> {
  final AuthRepository _authRepository;

  AuthStateNotifier(Ref ref)
      : _authRepository = ref.read(authRepositoryProvider),
        super(const AuthInitial());

  Future<void> sendOtp(RequestOtpDto dto) async {
    state = const OtpSendloading();

    final result = await _authRepository.requestOtp(dto);

    result.fold(
      (l) => state = OtpSendFailure(l),
      (r) => state = OtpSentSuccess(r),
    );
  }

  Future<void> resendOtp(RequestOtpDto dto) async {
    state = const ResendOtpLoading();

    final result = await _authRepository.requestOtp(dto);

    result.fold(
      (l) => state = ResendOtpFailure(l),
      (r) => state = ResendOtpSuccess(r),
    );
  }

  Future<void> verifyOtp(VerifyOtpDto dto) async {
    state = const AuthLoading();

    final result = await _authRepository.verifyOtp(dto);

    result.fold(
      (l) => state = AuthFailure(l),
      (r) async {
        state = AuthSuccess(
          await AuthManager.instance.saveAuthSession(r),
        );
      },
    );
  }

// ... other auth flows like Google Sign-In
}

final authStateNotifierProvider =
    StateNotifierProvider.autoDispose<AuthStateNotifier, AuthState>(
  (ref) => AuthStateNotifier(ref),
);
