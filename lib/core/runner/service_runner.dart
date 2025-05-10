import 'dart:async';
import 'dart:io';

import 'package:dartz/dartz.dart';

import '../failures/failures.dart';
import '../network_info/network_info.dart';

class ServiceRunner<F extends Failure, T> {
  final NetworkInfo networkInfo;

  ServiceRunner(this.networkInfo);

  /// Wraps local data source calls with error handling.
  Future<Either<F, T>> tryLocalAndCatch({
    required Future<T> call,
    required String errorTitle,
  }) async {
    try {
      return Right(await call);
    } on Exception catch (e) {
      return Left(CacheFailure(
        title: errorTitle,
        message: _formatException(e),
      ) as F);
    }
  }

  /// Wraps remote data source calls with network check and error handling.
  Future<Either<F, T>> tryRemoteAndCatch({
    required Future<T> call,
    required String errorTitle,
    bool stopTimeout = false,
    bool navigateOut = true,
  }) async {
    if (!await networkInfo.isConnected) {
      return Left(InternetFailure(errorTitle, 'No Internet access') as F);
    }

    try {
      return Right(await call);
    } on HandshakeException catch (e) {
      return Left(
          InternetFailure('$errorTitle: No Internet access', e.message) as F);
    } on SocketException catch (e) {
      return Left(
          InternetFailure('$errorTitle: No Internet access', e.message) as F);
    } on FormatException catch (e) {
      return Left(InternetFailure(errorTitle, e.message) as F);
    } on Exception catch (e) {
      final errorMsg = _formatException(e);
      return Left(CommonFailure(errorTitle, errorMsg) as F);
    }
  }

  /// Formats an exception to remove boilerplate.
  String _formatException(Exception e) {
    return e.toString().replaceFirst('Exception: ', '').trim();
  }
}
