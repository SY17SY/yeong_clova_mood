import 'package:shared_preferences/shared_preferences.dart';

class SettingsRepository {
  static const String _darkMode = 'darkMode';
  static const String _followSystem = 'followSystem';
  final SharedPreferences _preferences;

  SettingsRepository(this._preferences);

  bool isDarkMode() {
    return _preferences.getBool(_darkMode) ?? false;
  }

  bool isFollowSystem() {
    return _preferences.getBool(_followSystem) ?? true;
  }

  Future<void> setDarkMode(bool value) async {
    await _preferences.setBool(_darkMode, value);
  }

  Future<void> setFollowSystem(bool value) async {
    await _preferences.setBool(_followSystem, value);
  }
}
