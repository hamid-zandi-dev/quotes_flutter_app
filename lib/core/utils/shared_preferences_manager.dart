import 'constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesManager {

  final SharedPreferences _sharedPreferences;
  SharedPreferencesManager(this._sharedPreferences);

  String? getCurrentTheme() {
    String? themeName = _sharedPreferences.getString(SharedPreferencesKeys.currentTheme);
    return themeName;
  }

  void changeCurrentTheme(String theme)  {
    _sharedPreferences.setString(SharedPreferencesKeys.currentTheme, theme);
  }

  String? getCurrentLanguage() {
    String? currentLanguage = _sharedPreferences.getString(SharedPreferencesKeys.currentLanguage);
    return currentLanguage;
  }

  void setCurrentLanguage(String language)  {
    _sharedPreferences.setString(SharedPreferencesKeys.currentLanguage, language);
  }

  String? getCurrentFont() {
    String? currentFont = _sharedPreferences.getString(SharedPreferencesKeys.currentFont);
    return currentFont;
  }

  void setCurrentFont(String font)  {
    _sharedPreferences.setString(SharedPreferencesKeys.currentFont, font);
  }
}