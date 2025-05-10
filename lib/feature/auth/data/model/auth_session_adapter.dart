import 'package:hive/hive.dart';

import '../../../../core/constants/hive_constants.dart';
import 'auth_session.dart';

class AuthSessionAdapter extends TypeAdapter<AuthSession> {
  @override
  final int typeId = HiveConstants.authSessionHiveId;

  @override
  AuthSession read(BinaryReader reader) {
    return AuthSession(
      accessToken: reader.read(),
      refreshToken: reader.read(),
      user: reader.read(),
      status: AuthStatus.values[reader.read()],
    );
  }

  @override
  void write(BinaryWriter writer, AuthSession obj) {
    writer.write(obj.accessToken);
    writer.write(obj.refreshToken);
    writer.write(obj.user);
    writer.write(obj.status?.index ?? 0);
  }
}
