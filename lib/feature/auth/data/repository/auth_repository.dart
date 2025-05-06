import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/error_strings.dart';
import '../../../../core/failures/failures.dart';
import '../../../../core/network_info/network_info.dart';
import '../../../../core/runner/service_runner.dart';
import '../datasource/remote_datasource.dart';
import '../dto/request_otp_dto.dart';
import '../dto/verify_otp_dto.dart';
import '../model/auth_session.dart';

abstract class AuthRepository {
  // Auth
  Future<Either<Failure, String>> requestOtp(RequestOtpDto dto);
  Future<Either<Failure, AuthSession>> verifyOtp(VerifyOtpDto dto);
  // Future<Either<Failure, AuthenticatedUser>> login(String email, String pin);
  // Future<Either<Failure, AuthenticatedUser>> accountVerification(String code);
  // Future<Either<Failure, ResponseModel>> resendVerificationCode(String email);
  // Future<Either<Failure, ResponseModel>> checkAccount(String email);
  //
  // // Pin
  // Future<Either<Failure, AuthenticatedUser>> createPin(String pin);
  // Future<Either<Failure, ResponseModel>> resetPin(String pin);
  // Future<Either<Failure, ResponseModel>> forgotPin(String email);
  // Future<Either<Failure, ResponseModel>> resendForgotPin(String email);
  //
  // Future<Either<Failure, ResponseModel>> verifyCode(String code);
}

class AuthRepositoryImpl implements AuthRepository {
  final NetworkInfo _networkInfo;
  final AuthRemoteDataSource _authRemoteDataSource;

  AuthRepositoryImpl(Ref ref)
      : _authRemoteDataSource = ref.read(authRemoteSourceProvider),
        _networkInfo = ref.read(networkInfoProvider);

  // Auth
  @override
  Future<Either<Failure, String>> requestOtp(RequestOtpDto dto) async {
    ServiceRunner<Failure, String> sR = ServiceRunner(_networkInfo);

    return sR.tryRemoteAndCatch(
      call: _authRemoteDataSource.requestOtp(dto),
      errorTitle: ErrorStrings.SEND_OTP_ERROR,
    );
  }

  @override
  Future<Either<Failure, AuthSession>> verifyOtp(VerifyOtpDto dto) async {
    ServiceRunner<Failure, AuthSession> sR = ServiceRunner(_networkInfo);

    return await sR.tryRemoteAndCatch(
      call: _authRemoteDataSource.verifyOtp(dto),
      errorTitle: ErrorStrings.SEND_OTP_ERROR,
    );
  }
}

final authRepositoryProvider = Provider<AuthRepository>(
  (ref) => AuthRepositoryImpl(ref),
);
