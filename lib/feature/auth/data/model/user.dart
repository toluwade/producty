import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../../../core/constants/hive_constants.dart';

part 'user.g.dart';

@HiveType(typeId: HiveConstants.userHiveId)
@JsonSerializable()
class User {
  @HiveField(0)
  @JsonKey(name: 'id')
  final String? id;

  @HiveField(1)
  @JsonKey(name: 'email')
  final String? email;

  @HiveField(2)
  @JsonKey(name: 'name')
  final String? name;

  @HiveField(3)
  @JsonKey(name: 'phone')
  final String? phone;

  @HiveField(4)
  @JsonKey(name: 'countryCode')
  final String? countryCode;

  @HiveField(5)
  @JsonKey(name: 'usagePurpose')
  final UsagePurpose? usagePurpose;

  @HiveField(6)
  @JsonKey(name: 'loginProvider')
  final LoginProvider? loginProvider;

  @HiveField(7)
  @JsonKey(name: 'createdAt')
  final DateTime? createdAt;

  @HiveField(8)
  @JsonKey(name: 'updatedAt')
  final DateTime? updatedAt;

  const User({
    this.id,
    this.email,
    this.name,
    this.phone,
    this.countryCode,
    this.usagePurpose,
    this.loginProvider,
    this.createdAt,
    this.updatedAt,
  });

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);
}

@HiveType(typeId: HiveConstants.usagePurposeHiveId)
enum UsagePurpose {
  @HiveField(0)
  @JsonValue('Personal')
  personal,

  @HiveField(1)
  @JsonValue('Work')
  work,

  @HiveField(2)
  @JsonValue('Education')
  education,
}

@HiveType(typeId: HiveConstants.loginProviderHiveId)
enum LoginProvider {
  @HiveField(0)
  @JsonValue('EMAIL')
  email,

  @HiveField(1)
  @JsonValue('GOOGLE')
  google,

  @HiveField(2)
  @JsonValue('APPLE')
  apple,
}
