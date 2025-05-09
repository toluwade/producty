import 'package:email_validator/email_validator.dart';

extension StringExtention on String? {
  String? validateEmail() {
    if (this != null && !EmailValidator.validate(this!)) {
      return 'Enter a valid email';
    }
    return null;
  }
}
