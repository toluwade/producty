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
  static const String _authSessionBox = HiveConstants.authSessionBox;
  static const String _userBox = HiveConstants.userBox;
  static const String _sessionKey = HiveConstants.sessionKey;
  static const String _userKey = HiveConstants.userKey;

  Future<Box<T>> _openBox<T>(String boxName) async =>
      await Hive.openBox<T>(boxName);

  @override
  Future<AuthSession?> getAuthSession() async {
    final box = await _openBox<AuthSession>(_authSessionBox);
    return box.get(_sessionKey);
  }

  @override
  Future<void> saveAuthSession(AuthSession session) async {
    final sessionBox = await _openBox<AuthSession>(_authSessionBox);
    await sessionBox.put(_sessionKey, session);

    final userBox = await _openBox<User?>(_userBox);
    await userBox.put(_userKey, session.user);
  }

  @override
  Future<void> clearAuthSession() async {
    final sessionBox = await _openBox<AuthSession>(_authSessionBox);
    await sessionBox.delete(_sessionKey);

    final userBox = await _openBox<User>(_userBox);
    await userBox.delete(_userKey);
  }

  @override
  Stream<User?> streamUserStatus() async* {
    final box = await _openBox<User>(_userBox);
    yield box.get(_userKey);
    yield* box.watch(key: _userKey).map((event) => event.value as User?);
  }
}
