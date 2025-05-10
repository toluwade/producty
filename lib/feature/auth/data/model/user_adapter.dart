import 'package:hive/hive.dart';

import '../../../../core/constants/hive_constants.dart';
import 'user.dart';

class UserAdapter extends TypeAdapter<User> {
  @override
  final int typeId = HiveConstants.userHiveId;

  @override
  User read(BinaryReader reader) {
    return User(
      id: reader.read(),
      email: reader.read(),
      name: reader.read(),
      phone: reader.read(),
      countryCode: reader.read(),
      usagePurpose: UsagePurpose.values[reader.read()],
      loginProvider: LoginProvider.values[reader.read()],
      createdAt: reader.read(),
      updatedAt: reader.read(),
    );
  }

  @override
  void write(BinaryWriter writer, User obj) {
    writer.write(obj.id);
    writer.write(obj.email);
    writer.write(obj.name);
    writer.write(obj.phone);
    writer.write(obj.countryCode);
    writer.write(obj.usagePurpose?.index ?? 0);
    writer.write(obj.loginProvider?.index ?? 0);
    writer.write(obj.createdAt);
    writer.write(obj.updatedAt);
  }
}

class UsagePurposeAdapter extends TypeAdapter<UsagePurpose> {
  @override
  final int typeId = HiveConstants.usagePurposeHiveId;

  @override
  UsagePurpose read(BinaryReader reader) {
    return UsagePurpose.values[reader.read()];
  }

  @override
  void write(BinaryWriter writer, UsagePurpose obj) {
    writer.write(obj.index);
  }
}

class LoginProviderAdapter extends TypeAdapter<LoginProvider> {
  @override
  final int typeId = HiveConstants.loginProviderHiveId;

  @override
  LoginProvider read(BinaryReader reader) {
    return LoginProvider.values[reader.read()];
  }

  @override
  void write(BinaryWriter writer, LoginProvider obj) {
    writer.write(obj.index);
  }
}
