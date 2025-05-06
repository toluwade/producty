class RequestOtpDto {
  final String email;

  RequestOtpDto({required this.email});

  Map<String, dynamic> toJson() => {'email': email};
}
