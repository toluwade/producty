import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:producty/core/api/endpoints.dart';

import '../../feature/auth/application/auth_manager.dart';

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
            //  validateStatus: (s) => s != null && s < 500,
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

    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final accessToken = AuthManager.instance.accessToken;

          if (accessToken != null) {
            options.headers['Authorization'] = 'Bearer $accessToken';
          }

          handler.next(options);
        },
        onError: (error, handler) async {
          final statusCode = error.response?.statusCode;

          if (statusCode == 401) {
            try {
              final refreshToken = AuthManager.instance.refreshToken;

              if (refreshToken == null) {
                throw Exception('No refresh token available');
              }

              final response = await _dio.post(
                Endpoints.getRefreshToken,
                data: {
                  'refreshToken': refreshToken,
                },
              );

              final newAccessToken = response.data['accessToken'];

              await AuthManager.instance.saveAccessToken(newAccessToken);

              // Retry the original request with the new access token
              final options = error.requestOptions;
              options.headers['Authorization'] = 'Bearer $newAccessToken';

              final clonedRequest = await _dio.request(
                options.path,
                options: Options(
                  method: options.method,
                  headers: options.headers,
                ),
                data: options.data,
                queryParameters: options.queryParameters,
              );

              return handler.resolve(clonedRequest);
            } catch (e) {
              await AuthManager.instance.clearAuthenticatedUser();

              return handler.next(error);
            }
          }

          return handler.next(error);
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

extension ResponseExtension on Response {
  bool get isSuccess =>
      statusCode != null && statusCode! >= 200 && statusCode! < 300;
}
