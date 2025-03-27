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

/// Application configuration provider
class AppConfig {
  final ThemeManager _themeManager;
  final SharedPreferencesManager _prefsManager;

  AppConfig({
    required ThemeManager themeManager,
    required SharedPreferencesManager prefsManager,
  }) : _themeManager = themeManager,
       _prefsManager = prefsManager;

  ThemeType getCurrentTheme() {
    final currentThemeName =
        _prefsManager.getCurrentTheme() ?? ThemeType.light.name;
    try {
      return Utils.getThemeByName(currentThemeName);
    } catch (_) {
      return ThemeType.light;
    }
  }

  ThemeData get currentTheme => _themeManager.getTheme(getCurrentTheme());
}

/// Root widget of the application
class QuotesApp extends StatelessWidget {
  final AppConfig appConfig;

  const QuotesApp({required this.appConfig, super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Quotes',
      debugShowCheckedModeBanner: false,
      theme: appConfig.currentTheme,
      initialRoute: AppRoutes.quoteListRoute,
      routes: _buildAppRoutes(),
      locale: Locale(Locales.englishLocale.locale),
    );
  }

  Map<String, WidgetBuilder> _buildAppRoutes() {
    return {
      AppRoutes.quoteListRoute:
          (_) => BlocProvider(
            create: (_) => locator<QuoteListBloc>(),
            child: const QuotesScreen(),
          ),
    };
  }
}

Future<void> main() async {
  // Do basic Flutter initialization
  WidgetsFlutterBinding.ensureInitialized();

  // Load environment variables and dependencies
  await dotenv.load(fileName: ".env");
  await setupInjection();

  // Get dependencies from locator (dependency injection container)
  final prefsManager = locator<SharedPreferencesManager>();

  // Build theme manager
  final themeManager = _buildThemeManager(prefsManager);

  // Create app configuration
  final appConfig = AppConfig(
    themeManager: themeManager,
    prefsManager: prefsManager,
  );

  // Launch the app
  runApp(QuotesApp(appConfig: appConfig));
}

/// Helper functions for initialization
ThemeManager _buildThemeManager(SharedPreferencesManager prefsManager) {
  final locale = prefsManager.getCurrentLanguage();
  final font = _getFontForLocale(locale ?? Locales.englishLocale.locale);
  final themeColors = _buildThemeColorMap();

  return ThemeManager(themeColors, font);
}

HashMap<ThemeType, CustomColor> _buildThemeColorMap() {
  return HashMap<ThemeType, CustomColor>()
    ..putIfAbsent(ThemeType.light, () => LightColor())
    ..putIfAbsent(ThemeType.dark, () => DarkColor());
}

String _getFontForLocale(String locale) {
  return FontFamily.openSans.font;
}
