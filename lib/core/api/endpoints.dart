class Endpoints {
  static const _base = 'http://localhost:3000';

  ////////////////////////////////////

  // Authentication Endpoint

  // Auth
  static const requestOtp = '$_base/auth/request-otp';

  static const verifyOtp = '$_base/auth/verify-otp';

  static const googleSignIn = '$_base/auth/google-signin';

  static const getRefreshToken = '$_base/auth/refresh-token';
}
