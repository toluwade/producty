// Rename to avoid confusion with actual user model
import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../../../core/constants/hive_constants.dart';
import 'user.dart';

part 'auth_session.g.dart';

enum AuthStatus { newUser, existing }

@HiveType(typeId: HiveConstants.authSessionHiveId)
@JsonSerializable()
class AuthSession {
  @HiveField(0)
  @JsonKey(name: 'accessToken')
  final String? accessToken;

  @HiveField(1)
  @JsonKey(name: 'refreshToken')
  final String? refreshToken;

  @HiveField(2)
  @JsonKey(name: 'user')
  final User? user;

  @JsonKey(fromJson: _parseStatus, toJson: _statusToString)
  final AuthStatus? status;

  AuthSession({
    this.accessToken,
    this.refreshToken,
    this.user,
    this.status,
  });

  factory AuthSession.fromJson(Map<String, dynamic> json) =>
      _$AuthSessionFromJson(json);

  Map<String, dynamic> toJson() => _$AuthSessionToJson(this);

  static AuthStatus _parseStatus(String? status) {
    switch (status?.toLowerCase()) {
      case 'new':
        return AuthStatus.newUser;
      case 'existing':
        return AuthStatus.existing;
      default:
        throw Exception('Unknown auth status: $status');
    }
  }

  static String _statusToString(AuthStatus? status) {
    return status == AuthStatus.newUser ? 'new' : 'existing';
  }

  AuthSession copyWith({
    String? accessToken,
    String? refreshToken,
    User? user,
    AuthStatus? status,
  }) {
    return AuthSession(
      accessToken: accessToken ?? this.accessToken,
      refreshToken: refreshToken ?? this.refreshToken,
      user: user ?? this.user,
      status: status ?? this.status,
    );
  }
}
