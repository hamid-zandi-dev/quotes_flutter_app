import 'dart:ui';

abstract class CustomColor{
  dynamic primaryColor;
  dynamic primaryColorLight;
  dynamic primaryColorDark;

  dynamic secondaryColor;
  dynamic secondaryColorLight;
  dynamic secondaryColorDark;

  dynamic backgroundColor;
  dynamic primaryTextColor;
  dynamic secondaryTextColor;
  dynamic textColorOnPrimary;

  dynamic unselectedColor;
  dynamic selectedColor;
  dynamic navigationBottomBackground;
  dynamic searchBoxBackground;
  dynamic searchBoxIconTint;
  dynamic hintColor;
  dynamic promotionTextColor;
  dynamic borderColor;
  dynamic tintOnPrimaryColor;
  dynamic dividerColor;
  dynamic dotUnselectedIndicator;
  dynamic dotSelectedIndicator;
  dynamic iconTintColor;
  dynamic iconTintSecondaryColor;
  dynamic placeHolderBackgroundColor;
  dynamic secondaryBackgroundColor;
}

class LightColor implements CustomColor{
  @override
  var primaryColor = const Color(0xFFF63D67);
  @override
  var primaryColorLight = const Color(0xFFFF6F60);
  @override
  var primaryColorDark = const Color(0xFFAB000D);

  @override
  var secondaryColor = const Color(0xFFF63D67);
  @override
  var secondaryColorLight = const Color(0xFFFF6F60);
  @override
  var secondaryColorDark = const Color(0xFFAB000D);

  @override
  var backgroundColor = const Color(0xFFffffff);

  @override
  var primaryTextColor = const Color(0xFF444444);

  @override
  var secondaryTextColor = const Color(0XFFBABABA);

  @override
  var textColorOnPrimary = const Color(0xFFFFFFFF);

  @override
  var unselectedColor = const Color(0XFF9A9A9A);

  @override
  var selectedColor = const Color(0xFF444444);

  @override
  var navigationBottomBackground = const Color(0XFFFFFFFF);

  @override
  var searchBoxBackground = const Color(0XFFF0F0F0);

  @override
  var hintColor = const Color(0XFFC9C9C9);

  @override
  var searchBoxIconTint = const Color(0XFFBABABA);

  @override
  var promotionTextColor = const Color(0xFFffffff);

  @override
  var borderColor = const Color(0XFFD0D5DD);

  @override
  var tintOnPrimaryColor = const Color(0xFFFFFFFF);

  @override
  var dividerColor = const Color(0XFFF4F4F4);

  @override
  var dotUnselectedIndicator = const Color(0XFFD5D5D5);

  @override
  var dotSelectedIndicator = const Color(0XFFFFFFFF);

  @override
  var iconTintColor = const Color(0XFF667085);

  @override
  var iconTintSecondaryColor = const Color(0XFF888888);

  @override
  var placeHolderBackgroundColor = const Color(0XFFEFEFEF);

  @override
  var secondaryBackgroundColor = const Color(0XFFFAFAFA);
}

class DarkColor implements CustomColor{
  @override
  var primaryColor = const Color(0xFF212121);
  @override
  var primaryColorLight = const Color(0xFF484848);
  @override
  var primaryColorDark = const Color(0xFF000000);

  @override
  var secondaryColor = const Color(0xFF212121);
  @override
  var secondaryColorLight = const Color(0xFF484848);
  @override
  var secondaryColorDark = const Color(0xFF000000);

  @override
  var backgroundColor = const Color(0xFF000000);
  @override
  var primaryTextColor = const Color(0xFFFFFFFF);

  @override
  var secondaryTextColor = const Color(0XFFBABABA);

  @override
  var textColorOnPrimary = const Color(0xFFFFFFFF);

  @override
  var unselectedColor = const Color(0XFF9A9A9A);

  @override
  var selectedColor = const Color(0xFF000000);

  @override
  var navigationBottomBackground = const Color(0XFFF0F0F0);

  @override
  var searchBoxBackground = const Color(0XFFF0F0F0);

  @override
  var hintColor = const Color(0XFFC9C9C9);

  @override
  var searchBoxIconTint = const Color(0XFFBABABA);

  @override
  var promotionTextColor = const Color(0xFFffffff);

  @override
  var borderColor = const Color(0XFFD0D5DD);

  @override
  var tintOnPrimaryColor = const Color(0xFFFFFFFF);

  @override
  var dividerColor = const Color(0XFFF4F4F4);

  @override
  var dotUnselectedIndicator = const Color(0XFFD5D5D5);

  @override
  var dotSelectedIndicator = const Color(0XFFFFFFFF);

  @override
  var iconTintColor = const Color(0XFF667085);

  @override
  var iconTintSecondaryColor = const Color(0XFF888888);

  @override
  var placeHolderBackgroundColor = const Color(0XFFEFEFEF);

  @override
  var secondaryBackgroundColor = const Color(0XFFFAFAFA);
}