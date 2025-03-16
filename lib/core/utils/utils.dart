import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'constants.dart';

class Utils {

  static void showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      behavior: SnackBarBehavior.floating,
      duration: const Duration(seconds: 1, milliseconds: 200),
      content: Text(message),
    ));
  }

  static Future<void> copyToClipboard(String text) async {
    await Clipboard.setData(ClipboardData(text: text));
  }

  static void changeStatusBarAndNavigationBarColor(
      Color statusBar, Color navigationBar) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: statusBar,
      systemNavigationBarColor: navigationBar,
      statusBarIconBrightness: Brightness.light, // For Android (dark icons)
      statusBarBrightness: Brightness.light, // For iOS (dark icons)
    ));
  }

  static ThemeType getThemeByName(String themeName) {
    return ThemeType.values.byName(themeName);
  }

  static getHeight(BuildContext context) {
    return MediaQuery.of(context).size.height;
  }

  static getWidth(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }

  static int getTotalPages(int items, int pageLimit){
    if (items > 0) {
      final totalPages = (items.toDouble() / pageLimit).ceil();
      return totalPages;
    }
    return 0;
  }

  static Future<bool> checkInternet() async {
    try {
      final dio = Dio();
      final response = await dio.get('https://www.google.com');
      return response.statusCode == 200;
    } catch (_) {
      return false;
    }
  }
}
