import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:retry/retry.dart';

final networkRetryProvider =
    Provider<NetworkRetry>((ref) => NetworkRetryImpl());

abstract class NetworkRetry {
  Future<T> networkRetry<T>(FutureOr<T> Function() function);
}

class NetworkRetryImpl implements NetworkRetry {
  @override
  Future<T> networkRetry<T>(FutureOr<T> Function() function) {
    return retry(
      function,
      retryIf: (e) =>
          e is TimeoutException ||
          (e is DioException && e.type == DioExceptionType.connectionTimeout),
      maxAttempts: 2,
      delayFactor: const Duration(seconds: 2),
      maxDelay: const Duration(seconds: 10),
    );
  }
}
