class UserService {
  static final List<String> _existingUsers = [
    'mykel@gmail.com',
  ];

  static final List<String> _newUsers = [
    'test@gmail.com',
  ];

  static bool isExistingUser(String email) {
    return _existingUsers.contains(email.toLowerCase());
  }

  static bool isNewUser(String email) {
    return _newUsers.contains(email.toLowerCase());
  }
}
