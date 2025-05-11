import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hive/hive.dart';
import 'package:producty/core/constants/hive_constants.dart';

import '../model/auth_session.dart';
import '../model/user.dart';

abstract class AuthLocalDataSource {
  Future<AuthSession?> getAuthSession();
  Future<void> saveAuthSession(AuthSession session);
  Future<void> clearAuthSession();
  Stream<User?> streamUserStatus();
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  static const String _userBox = HiveConstants.userBox;
  static const String _userKey = HiveConstants.userKey;

  static const _accessTokenKey = SecureStorage.accessTokenKey;
  static const _refreshTokenKey = SecureStorage.refreshTokenKey;

  final _secureStorage = const FlutterSecureStorage();

  Future<Box<T>> _openBox<T>(String boxName) async =>
      await Hive.openBox<T>(boxName);

  @override
  Future<AuthSession?> getAuthSession() async {
    final accessToken = await _secureStorage.read(key: _accessTokenKey);
    final refreshToken = await _secureStorage.read(key: _refreshTokenKey);

    if (accessToken == null || refreshToken == null) return null;

    final userBox = await _openBox<User>(_userBox);
    final user = userBox.get(_userKey);

    if (user == null) return null;

    return AuthSession(
      accessToken: accessToken,
      refreshToken: refreshToken,
      user: user,
    );
  }

  @override
  Future<void> saveAuthSession(AuthSession session) async {
    await _secureStorage.write(
      key: _accessTokenKey,
      value: session.accessToken,
    );
    await _secureStorage.write(
      key: _refreshTokenKey,
      value: session.refreshToken,
    );

    final userBox = await _openBox<User?>(_userBox);
    await userBox.put(_userKey, session.user);
  }

  @override
  Future<void> clearAuthSession() async {
    await _secureStorage.deleteAll();

    final userBox = await _openBox<User>(_userBox);
    await userBox.delete(_userKey);
  }

  @override
  Stream<User?> streamUserStatus() async* {
    final userBox = await _openBox<User>(_userBox);
    yield userBox.get(_userKey);
    yield* userBox.watch(key: _userKey).map((event) => event.value as User?);
  }
}
