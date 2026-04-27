import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

import 'core/providers/app_language_provider.dart';
import 'core/theme/app_theme.dart';
import 'core/services/supabase_service.dart';
import 'core/utils/app_scaffold_messenger.dart';
import 'features/auth/presentation/pages/welcome_screen.dart';
import 'features/home/presentation/pages/home_screen.dart';
import 'features/auth/presentation/pages/login_screen.dart';
import 'features/auth/presentation/pages/register_screen.dart';
import 'features/auth/presentation/providers/auth_provider.dart';
import 'features/entrepreneur/home/pages/entrepreneur_home_screen.dart';
import 'features/search/presentation/pages/search_screen.dart';
import 'features/home/presentation/pages/map_screen.dart';
import 'features/citizen/home/pages/accessibility_home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Supabase
  await SupabaseService.initialize();
  
  // Set preferred orientations
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  
  // Set system UI overlay style
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: AppColors.deepBlack,
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  );
  
  runApp(const VirarApp());
}

class VirarApp extends StatelessWidget {
  const VirarApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AuthProvider()),
        ChangeNotifierProvider(create: (context) => AppLanguageProvider()),
      ],
      child: Consumer<AppLanguageProvider>(
        builder: (context, languageProvider, child) {
          return MaterialApp(
            scaffoldMessengerKey: rootScaffoldMessengerKey,
            title: 'VIRAR',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.darkTheme,
            locale: languageProvider.locale,
            supportedLocales: const [
              Locale('pt'),
              Locale('en'),
              Locale('es'),
            ],
            localizationsDelegates: const [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            initialRoute: '/',
            routes: {
              '/': (context) => const WelcomeScreen(),
              '/home': (context) => const HomeScreen(),
              '/login': (context) => const LoginScreen(),
              '/register': (context) => const RegisterScreen(),
              '/citizen/login': (context) => const LoginScreen(),
              '/citizen/home': (context) => const HomeScreen(),
              '/entrepreneur/login': (context) => const LoginScreen(),
              '/entrepreneur/home': (context) => const EntrepreneurHomeScreen(),
              '/search': (context) => const SearchScreen(),
              '/map': (context) => const MapScreen(),
              '/accessibility/home': (context) => const AccessibilityHomeScreen(),
            },
          );
        },
      ),
    );
  }
}
