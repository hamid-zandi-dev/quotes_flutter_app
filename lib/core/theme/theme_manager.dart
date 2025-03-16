import 'dart:collection';
import 'package:flutter/material.dart';

import '../color/colors.dart';
import '../utils/constants.dart';

class ThemeManager{
   final HashMap _hashMapThemeData = HashMap<ThemeType, ThemeData>();
   final HashMap<ThemeType, CustomColor> _hashMapColor;

  ThemeManager(this._hashMapColor, String font) {
    for(var item in _hashMapColor.keys) {
      if(_hashMapColor[item] != null) {
        _hashMapThemeData.putIfAbsent(item, () => _buildTheme(_hashMapColor[item]!, font));
      }
    }
  }

  ThemeData _buildTheme(CustomColor myColor, String font) {
    TextTheme textTheme = _getTextTheme(myColor , font);
    final ThemeData themeData = ThemeData(fontFamily: font);
    return themeData.copyWith(
      appBarTheme: AppBarTheme(color: myColor.primaryColor),

      primaryColor: myColor.primaryColor,
      primaryColorDark: myColor.primaryColorDark,
      primaryColorLight: myColor.primaryColorLight,

      buttonTheme: themeData.buttonTheme.copyWith(
        buttonColor: myColor.primaryColor,
        textTheme: ButtonTextTheme.primary,
      ),

      scaffoldBackgroundColor: myColor.backgroundColor,
      cardColor: myColor.backgroundColor,
      textSelectionTheme: TextSelectionThemeData(selectionColor: myColor.primaryColorLight),
      textTheme: textTheme,
      primaryTextTheme: textTheme,
      dividerColor: myColor.dividerColor,
      extensions: <ThemeExtension<dynamic>>[
        AppColor(
          secondaryTextColor: myColor.secondaryTextColor,
          dotUnselectedIndicatorColor: myColor.dotUnselectedIndicator,
          dotSelectedIndicatorColor: myColor.dotSelectedIndicator,
          backgroundColor: myColor.backgroundColor,
          secondaryBackgroundColor: myColor.secondaryBackgroundColor,
          primaryColor: myColor.primaryColor,
          iconTintColor: myColor.iconTintColor,
          iconTintSecondaryColor: myColor.iconTintSecondaryColor,
          hintColor: myColor.hintColor,
          borderColor: myColor.borderColor,
          dividerColor: myColor.dividerColor,
          tintOnPrimaryColor: myColor.tintOnPrimaryColor,
          placeHolderBackgroundColor: myColor.placeHolderBackgroundColor,
          selectedColor: myColor.selectedColor,
          unselectedColor: myColor.unselectedColor,
        ),
      ], colorScheme: ColorScheme.fromSwatch().copyWith(primary: myColor.primaryColor).copyWith(secondary: myColor.primaryColor).copyWith(surface: myColor.backgroundColor),
    );
  }

  TextTheme _getTextTheme(CustomColor myColor, String font) {
    return TextTheme(
      bodyLarge: TextStyle(color: myColor.primaryTextColor),
      bodyMedium: TextStyle(color: myColor.primaryTextColor),
      bodySmall: TextStyle(color: myColor.primaryTextColor),
      displayLarge: TextStyle(color: myColor.primaryTextColor),
      displayMedium: TextStyle(color: myColor.primaryTextColor),
      displaySmall: TextStyle(color: myColor.primaryTextColor),
      headlineLarge: TextStyle(color: myColor.primaryTextColor),
      headlineMedium: TextStyle(color: myColor.primaryTextColor),
      headlineSmall: TextStyle(color: myColor.primaryTextColor),
      labelLarge: TextStyle(color: myColor.primaryTextColor),
      labelMedium: TextStyle(color: myColor.primaryTextColor),
      labelSmall: TextStyle(color: myColor.primaryTextColor),
      titleLarge: TextStyle(color: myColor.primaryTextColor),
      titleMedium: TextStyle(color: myColor.primaryTextColor),
      titleSmall: TextStyle(color: myColor.primaryTextColor),
    ).apply(fontFamily: font);
  }

  ThemeData getTheme(ThemeType themeName) {
    return _hashMapThemeData[themeName] ?? ThemeType.light;
  }

  CustomColor getColor(ThemeType themeName) {
   return _hashMapColor[themeName] ?? LightColor();
  }

}

@immutable
class AppColor extends ThemeExtension<AppColor> {

  final Color secondaryTextColor;
  final Color dotUnselectedIndicatorColor;
  final Color dotSelectedIndicatorColor;
  final Color backgroundColor;
  final Color secondaryBackgroundColor;
  final Color primaryColor;
  final Color iconTintColor;
  final Color iconTintSecondaryColor;
  final Color hintColor;
  final Color borderColor;
  final Color dividerColor;
  final Color tintOnPrimaryColor;
  final Color placeHolderBackgroundColor;
  final Color selectedColor;
  final Color unselectedColor;

  const AppColor({
    required this.secondaryTextColor,
    required this.dotUnselectedIndicatorColor,
    required this.dotSelectedIndicatorColor,
    required this.backgroundColor,
    required this.secondaryBackgroundColor,
    required this.primaryColor,
    required this.iconTintColor,
    required this.iconTintSecondaryColor,
    required this.hintColor,
    required this.borderColor,
    required this.dividerColor,
    required this.tintOnPrimaryColor,
    required this.placeHolderBackgroundColor,
    required this.selectedColor,
    required this.unselectedColor,
  });

  @override
  AppColor copyWith({
    Color? secondaryTextColor,
    Color? dotUnselectedIndicatorColor,
    Color? dotSelectedIndicatorColor,
    Color? backgroundColor,
    Color? secondaryBackgroundColor,
    Color? primaryColor,
    Color? iconTintColor,
    Color? iconTintSecondaryColor,
    Color? hintColor,
    Color? borderColor,
    Color? dividerColor,
    Color? detailScreeBorderColor,
    Color? tintOnPrimaryColor,
    Color? discountCodeTextColor,
    Color? discountCodeBackgroundColor,
    Color? discountCodeBorderColor,
    Color? countDownTimerTextColor,
    Color? countDownTimerBackgroundColor,
    Color? placeHolderBackgroundColor,
    Color? selectedColor,
    Color? unselectedColor,
  }) {
    return AppColor(
      secondaryTextColor: secondaryTextColor ?? this.secondaryTextColor,
      dotUnselectedIndicatorColor: dotUnselectedIndicatorColor ?? this.dotUnselectedIndicatorColor,
      dotSelectedIndicatorColor: dotSelectedIndicatorColor ?? this.dotSelectedIndicatorColor,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      secondaryBackgroundColor: secondaryBackgroundColor ?? this.secondaryBackgroundColor,
      primaryColor: primaryColor ?? this.primaryColor,
      iconTintColor: iconTintColor ?? this.iconTintColor,
      iconTintSecondaryColor: iconTintSecondaryColor ?? this.iconTintSecondaryColor,
      hintColor: hintColor ?? this.hintColor,
      borderColor: borderColor ?? this.borderColor,
      dividerColor: dividerColor ?? this.dividerColor,
      tintOnPrimaryColor: tintOnPrimaryColor ?? this.tintOnPrimaryColor,
      placeHolderBackgroundColor: placeHolderBackgroundColor ?? this.placeHolderBackgroundColor,
      selectedColor: selectedColor ?? this.selectedColor,
      unselectedColor: unselectedColor ?? this.unselectedColor,
    );
  }

  @override
  ThemeExtension<AppColor> lerp(covariant ThemeExtension<AppColor>? other, double t) {
    return this;
  }
}