class GoogleSignInDto {
  final String idToken;

  GoogleSignInDto({required this.idToken});

  Map<String, dynamic> toJson() => {'idToken': idToken};
}
