class HiveConstants {
  // Box Names
  static const String authSessionBox = 'auth_session_box';
  static const String userBox = 'user_box';
  static const String taskBox = 'task_box';
  static const String settingsBox = 'settings';

  static const String sessionKey = 'session';
  static const String userKey = 'user';
  static const String themeModeKey = 'theme_mode';

  // TypeAdapter Type IDs (must be unique)
  static const int authSessionHiveId = 0;
  static const int userHiveId = 1;
  static const int taskHiveId = 2;

  static const int usagePurposeHiveId = 3;
  static const int loginProviderHiveId = 4;

// Add more as needed
}
