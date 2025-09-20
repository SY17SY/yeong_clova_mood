import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yeong_clova_mood/models/g_settings_model.dart';
import 'package:yeong_clova_mood/repos/h_settings_repo.dart';

class SettingsViewModel extends StateNotifier<SettingsModel> {
  final SettingsRepository _repository;

  SettingsViewModel(this._repository)
      : super(SettingsModel(
          darkMode: _repository.isDarkMode(),
          followSystem: _repository.isFollowSystem(),
        ));

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
}

final settingsProvider =
    StateNotifierProvider<SettingsViewModel, SettingsModel>(
  (ref) => throw UnimplementedError(),
);
