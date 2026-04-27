import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/theme/app_theme.dart';
import 'core/services/supabase_service.dart';
import 'features/auth/presentation/providers/auth_provider.dart';
import 'features/auth/presentation/pages/register_screen_simple.dart' as auth;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Supabase
  await SupabaseService.initialize();
  
  runApp(const VirarApp());
}

class VirarApp extends StatelessWidget {
  const VirarApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AuthProvider(),
      child: MaterialApp(
        title: 'VIRAR',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.darkTheme,
        home: auth.RegisterScreenSimple(),
      ),
    );
  }
}
