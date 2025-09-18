import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yeong_clova_mood/models/settings_model.dart';
import 'package:yeong_clova_mood/repos/settings_repo.dart';

class SettingsViewModel extends Notifier<SettingsModel> {
  final SettingsRepository _repository;

  SettingsViewModel(this._repository);

  void setThemeMode({required bool followSystem, required bool darkMode}) {
    _repository.setFollowSystem(followSystem);
    _repository.setDarkMode(darkMode);
    state = SettingsModel(
      darkMode: darkMode,
      followSystem: followSystem,
    );
  }

  ThemeMode get themeMode {
    if (state.followSystem) {
      return ThemeMode.system;
    }
    return state.darkMode ? ThemeMode.dark : ThemeMode.light;
  }

  bool isDark(BuildContext context) {
    if (state.followSystem) {
      return Theme.of(context).brightness == Brightness.dark;
    }
    return state.darkMode;
  }

  @override
  SettingsModel build() {
    return SettingsModel(
      darkMode: _repository.isDarkMode(),
      followSystem: _repository.isFollowSystem(),
    );
  }
}

final settingsProvider = NotifierProvider<SettingsViewModel, SettingsModel>(
  () => throw UnimplementedError(),
);
