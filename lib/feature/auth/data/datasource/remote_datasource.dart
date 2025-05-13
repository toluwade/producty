import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/api/endpoints.dart';
import '../../../../core/network/network.dart';
import '../dto/google_signin_dto.dart';
import '../dto/request_otp_dto.dart';
import '../dto/verify_otp_dto.dart';
import '../model/auth_session.dart';

abstract class AuthRemoteDataSource {
  Future<String> requestOtp(RequestOtpDto dto);
  Future<AuthSession> verifyOtp(VerifyOtpDto dto);
  Future<AuthSession> googleSignIn(GoogleSignInDto dto);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final NetworkRequest networkRequest;
  final NetworkRetry networkRetry;

  AuthRemoteDataSourceImpl({
    required this.networkRequest,
    required this.networkRetry,
  });

  @override
  Future<String> requestOtp(RequestOtpDto dto) async {
    final response = await networkRetry.networkRetry(
      () => networkRequest.post(
        Endpoints.requestOtp,
        body: dto.toJson(),
      ),
    );

    final data = response.data;

    if (response.isSuccess) {
      return data["message"];
    } else {
      try {
        final errorMessage = data['message'] ?? 'Something went wrong';
        throw Exception(errorMessage);
      } catch (_) {
        rethrow;
      }
    }
  }

  @override
  Future<AuthSession> verifyOtp(VerifyOtpDto dto) async {
    final response = await networkRetry.networkRetry(
      () => networkRequest.post(
        Endpoints.verifyOtp,
        body: dto.toJson(),
      ),
    );

    final data = response.data;

    if (response.isSuccess) {
      return AuthSession.fromJson(data);
    } else {
      final errorMessage = data['message'] ?? 'OTP verification failed';
      throw Exception(errorMessage);
    }
  }

  @override
  Future<AuthSession> googleSignIn(GoogleSignInDto dto) async {
    final response = await networkRetry.networkRetry(
      () => networkRequest.post(
        Endpoints.googleSignIn,
        body: dto.toJson(),
      ),
    );

    final data = response.data;

    if (response.isSuccess) {
      return AuthSession.fromJson(data);
    } else {
      final errorMessage = data['message'] ?? 'Google Sign-In failed';
      throw Exception(errorMessage);
    }
  }
}

final authRemoteSourceProvider = Provider<AuthRemoteDataSource>(
  (ref) => AuthRemoteDataSourceImpl(
    networkRequest: ref.read(networkRequestProvider),
    networkRetry: ref.read(networkRetryProvider),
  ),
);
