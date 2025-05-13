import '../data/datasource/local_datasource.dart';
import '../data/model/auth_session.dart';
import '../data/model/user.dart';

class AuthManager {
  static final instance = AuthManager._();
  final _localSource = AuthLocalDataSourceImpl();

  User? user;
  AuthSession? _session;

  AuthManager._() {
    init();
  }

  Future<void> init() async {
    _session = await _localSource.getAuthSession();
    user = _session?.user;
  }

  Future<AuthSession> saveAuthSession(AuthSession session) async {
    await _localSource.saveAuthSession(session);
    _session = session;
    user = _session?.user;
    return _session!;
  }

  Future<User?> refreshAuthenticatedUser() async {
    _session = await _localSource.getAuthSession();
    user = _session?.user;
    return user;
  }

  Future<void> clearAuthenticatedUser() async {
    user = null;
    _session = null;
    await _localSource.clearAuthSession();
  }

  Stream<User?> streamActiveUser() {
    return _localSource.streamUserStatus().map((event) {
      user = event;
      return event;
    });
  }

  Future<void> saveAccessToken(String accessToken) async {
    if (_session == null) return;

    _session = _session!.copyWith(accessToken: accessToken);
    await _localSource.saveAuthSession(_session!);
  }

  String? get refreshToken => _session?.refreshToken;
  String? get accessToken => _session?.accessToken;
  bool get isLoggedIn => _session?.accessToken != null;
}
