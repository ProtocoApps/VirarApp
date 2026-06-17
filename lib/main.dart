import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart' as provider;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/providers/app_language_provider.dart';
import 'core/theme/app_theme.dart';
import 'core/services/supabase_service.dart';
import 'core/utils/app_scaffold_messenger.dart';
import 'features/auth/presentation/pages/welcome_screen.dart';
import 'features/auth/presentation/pages/login_screen.dart';
import 'features/auth/presentation/pages/register_screen.dart';
import 'features/auth/presentation/providers/auth_provider.dart';
import 'features/entrepreneur/home/pages/entrepreneur_home_screen.dart';
import 'features/citizen/navigation/pages/citizen_shell_screen.dart';
import 'features/citizen/navigation/pages/accessibility_shell_screen.dart';
import 'core/providers/text_scale_provider.dart';
import 'core/widgets/global_zoom_fab.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Supabase
  await SupabaseService.initialize();
  
  // Set preferred orientations
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  
  // Set system UI overlay style (sem cores - gerenciado pelo enableEdgeToEdge no Android 15+)
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  );
  
  runApp(
    const ProviderScope(
      child: VirarApp(),
    ),
  );
}

class VirarApp extends StatelessWidget {
  const VirarApp({super.key});

  @override
  Widget build(BuildContext context) {
    return provider.MultiProvider(
      providers: [
        provider.ChangeNotifierProvider(create: (context) => AuthProvider()),
        provider.ChangeNotifierProvider(create: (context) => AppLanguageProvider()),
        provider.ChangeNotifierProvider(create: (context) => TextScaleProvider()),
      ],
      child: provider.Consumer2<AppLanguageProvider, TextScaleProvider>(
        builder: (context, languageProvider, textScaleProvider, child) {
          return MediaQuery(
            data: MediaQuery.of(context).copyWith(
              textScaler: TextScaler.linear(textScaleProvider.scale),
            ),
            child: MaterialApp(
              scaffoldMessengerKey: rootScaffoldMessengerKey,
              title: 'Virar Conecta',
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
              builder: (context, child) {
                return child ?? const SizedBox.shrink();
              },
              initialRoute: '/',
              routes: {
                '/': (context) => const WelcomeScreen(),
                // Sempre direcionar para a Home Acessível
                '/home': (context) => const AccessibilityShellScreen(initialIndex: 0),
                '/login': (context) => const LoginScreen(),
                '/register': (context) => const RegisterScreen(),
                '/citizen/login': (context) => const LoginScreen(),
                '/citizen/home': (context) => const AccessibilityShellScreen(initialIndex: 0),
                '/entrepreneur/login': (context) => const LoginScreen(),
                '/entrepreneur/home': (context) => const AccessibilityShellScreen(initialIndex: 0),
                '/search': (context) => const CitizenShellScreen(initialIndex: 1),
                '/map': (context) => const CitizenShellScreen(initialIndex: 2),
                '/accessibility/home': (context) => const AccessibilityShellScreen(initialIndex: 0),
                // Alias para navegações existentes apontarem para a Home Acessível
                '/citizen_home': (context) => const AccessibilityShellScreen(initialIndex: 0),
              },
            ),
          );
        },
      ),
    );
  }
}
