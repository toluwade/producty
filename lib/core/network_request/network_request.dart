import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

final networkRequestProvider =
    Provider<NetworkRequest>((ref) => NetworkRequestImpl());

abstract class NetworkRequest {
  Future<Response> get(
    String url, {
    Object? body,
    Map<String, String>? headers,
  });
  Future<Response> post(
    String url, {
    Map<String, String>? headers,
    Object? body,
    Encoding? encoding,
  });
  Future<Response> patch(
    String url, {
    Map<String, String>? headers,
    Object? body,
    Encoding? encoding,
  });
  Future<Response> put(
    String url, {
    Map<String, String>? headers,
    Object? body,
    Encoding? encoding,
  });
  Future<Response> delete(
    String url, {
    Map<String, String>? headers,
    Object? body,
    Encoding? encoding,
  });
}

class NetworkRequestImpl implements NetworkRequest {
  final Dio _dio;

  NetworkRequestImpl()
      : _dio = Dio(
          BaseOptions(
            connectTimeout: const Duration(seconds: 60),
            receiveTimeout: const Duration(seconds: 60),
            sendTimeout: const Duration(seconds: 60),
          ),
        ) {
    if (kDebugMode) {
      _dio.interceptors.add(
        PrettyDioLogger(
          requestHeader: true,
          requestBody: true,
          responseBody: true,
          responseHeader: false,
          error: true,
          compact: true,
          maxWidth: 90,
        ),
      );
    }

    // 2. 401 interceptor
    _dio.interceptors.add(
      InterceptorsWrapper(
        onError: (error, handler) {
          final statusCode = error.response?.statusCode;

          // if (statusCode == 401) {
          //   // Clear auth state
          //   AuthManager.instance.clearAuthenticatedUser();
          //
          //   // Navigate to login (replace with your own navigation logic)
          //   navigatorKey.currentState?.pushAndRemoveUntil(
          //     MaterialPageRoute(builder: (_) => const LoginScreen()),
          //     (_) => false,
          //   );
          // }

          return handler.next(error); // continue the error flow
        },
      ),
    );
  }

  @override
  Future<Response> get(
    String url, {
    Object? body,
    Map<String, String>? headers,
  }) {
    return _dio.get(url, options: Options(headers: headers));
  }

  @override
  Future<Response> post(
    String url, {
    Map<String, String>? headers,
    Object? body,
    Encoding? encoding,
  }) {
    return _dio.post(url, data: body, options: Options(headers: headers));
  }

  @override
  Future<Response> patch(
    String url, {
    Map<String, String>? headers,
    Object? body,
    Encoding? encoding,
  }) {
    return _dio.patch(url, data: body, options: Options(headers: headers));
  }

  @override
  Future<Response> put(
    String url, {
    Map<String, String>? headers,
    Object? body,
    Encoding? encoding,
  }) {
    return _dio.put(url, data: body, options: Options(headers: headers));
  }

  @override
  Future<Response> delete(
    String url, {
    Map<String, String>? headers,
    Object? body,
    Encoding? encoding,
  }) {
    return _dio.delete(url, data: body, options: Options(headers: headers));
  }
}
