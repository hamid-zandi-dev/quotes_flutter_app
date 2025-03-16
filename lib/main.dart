import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:quotes/features/quote_list/presentation/bloc/quote_list_bloc.dart';
import 'package:quotes/features/quote_list/presentation/screen/quotes_screen.dart';
import 'core/color/colors.dart';
import 'core/di/locator.dart';
import 'core/theme/theme_manager.dart';
import 'core/utils/constants.dart';
import 'core/utils/shared_preferences_manager.dart';
import 'core/utils/utils.dart';

SharedPreferencesManager _sharedPreferencesManager = locator();
late ThemeManager _themeManager;
ThemeType themeType = ThemeType.light;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  await setupInjection();
  _setupThemeManager();
  runApp(const MyApp());
}

void _setupThemeManager() {
  String? locale = _sharedPreferencesManager.getCurrentLanguage();
  String font = _getFont(locale ?? Locales.englishLocale.locale);

  HashMap<ThemeType, CustomColor> hashMap = HashMap();
  hashMap.putIfAbsent(ThemeType.light, () => LightColor());
  hashMap.putIfAbsent(ThemeType.dark, () => DarkColor());
  _themeManager = ThemeManager(hashMap, font);
}

ThemeType _getCurrentTheme() {
  String currentThemeName = _sharedPreferencesManager.getCurrentTheme() ?? ThemeType.light.name;
  ThemeType themeType;
  try {
    themeType = Utils.getThemeByName(currentThemeName);
  }
  catch (e) {
    themeType = ThemeType.light;
  }
  return themeType;
}

String _getFont(String locale) {
  String font = FontFamily.openSans.font;
  if (locale == Locales.englishLocale.locale) {
    font = FontFamily.openSans.font;
  }
  return font;
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final currentTheme = _themeManager.getTheme(_getCurrentTheme());
    
    return MaterialApp(
      title: 'Quotes',
      debugShowCheckedModeBanner: false,
      initialRoute: AppRoutes.quoteListRoute,
      theme: currentTheme,
      routes: {
        AppRoutes.quoteListRoute: (context) => BlocProvider(
          create: (context) => locator<QuoteListBloc>(),
          child: const QuotesScreen(),
        ),
      },
      locale: Locale(Locales.englishLocale.locale),
    );
  }
}
