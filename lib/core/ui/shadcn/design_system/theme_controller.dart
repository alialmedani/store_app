import 'package:flutter/widgets.dart' as fw;
import 'package:shared_preferences/shared_preferences.dart';
import 'app_design_tokens.dart';

enum AppThemeMode { system, light, dark }

/// Holds the user's theme choice (persisted) and keeps
/// [AppDesignTokens.isDark] in sync with the effective brightness.
class ThemeController extends fw.ChangeNotifier {
  ThemeController._();
  static final ThemeController instance = ThemeController._();

  static const _key = 'app_theme_mode';
  AppThemeMode _mode = AppThemeMode.dark;
  AppThemeMode get mode => _mode;

  Future<void> load() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final saved = prefs.getString(_key);
      _mode = AppThemeMode.values.firstWhere(
        (m) => m.name == saved,
        orElse: () => AppThemeMode.dark,
      );
    } catch (_) {
      _mode = AppThemeMode.dark;
    }
    apply(fw.WidgetsBinding.instance.platformDispatcher.platformBrightness);
  }

  Future<void> setMode(AppThemeMode mode) async {
    if (_mode == mode) return;
    _mode = mode;
    apply(fw.WidgetsBinding.instance.platformDispatcher.platformBrightness);
    notifyListeners();
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_key, mode.name);
    } catch (_) {}
  }

  bool resolveDark(fw.Brightness platform) {
    switch (_mode) {
      case AppThemeMode.light:
        return false;
      case AppThemeMode.dark:
        return true;
      case AppThemeMode.system:
        return platform == fw.Brightness.dark;
    }
  }

  /// Updates the global token flag. Returns true when it changed.
  bool apply(fw.Brightness platform) {
    final dark = resolveDark(platform);
    final changed = AppDesignTokens.isDark != dark;
    AppDesignTokens.isDark = dark;
    return changed;
  }
}
