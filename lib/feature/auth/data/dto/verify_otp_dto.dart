class VerifyOtpDto {
  final String email;
  final String code;

  VerifyOtpDto({required this.email, required this.code});

  Map<String, dynamic> toJson() => {'email': email, 'code': code};
}
