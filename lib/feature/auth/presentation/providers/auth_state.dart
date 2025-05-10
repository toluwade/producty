import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:producty/feature/auth/data/model/auth_session.dart';

import '../../../../core/failures/failures.dart';

part 'auth_state.freezed.dart';

@freezed
class AuthState with _$AuthState {
  const factory AuthState.initial() = AuthInitial;
  const factory AuthState.loading() = AuthLoading;
  const factory AuthState.failure(Failure failure) = AuthFailure;
  const factory AuthState.success(AuthSession session) = AuthSuccess;
  const factory AuthState.otpSendLoading() = OtpSendloading;
  const factory AuthState.otpSentSuccess(String message) = OtpSentSuccess;
  const factory AuthState.otpSendFailure(Failure failure) = OtpSendFailure;

  const factory AuthState.resendOtpLoading() = ResendOtpLoading;
  const factory AuthState.resendOtpSuccess(String message) = ResendOtpSuccess;
  const factory AuthState.resendOtpFailure(Failure failure) = ResendOtpFailure;
}
