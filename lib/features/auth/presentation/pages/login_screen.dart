import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../../../../core/localization/app_localizations.dart';
import '../../../../../core/localization/app_language.dart';
import '../../../../../core/providers/app_language_provider.dart';
import '../../../../../core/theme/app_theme.dart';
import '../providers/auth_provider.dart';
import '../widgets/auth_text_field.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _announce(String message) {
    SemanticsService.announce(message, Directionality.of(context));
  }

  @override
  Widget build(BuildContext context) {
    final strings = context.t;
    final isLibrasSelected =
        context.watch<AppLanguageProvider>().currentLanguage == AppLanguage.libras;

    return Scaffold(
      backgroundColor: AppColors.deepBlack,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              Row(
                children: [
                  Semantics(
                    button: true,
                    label: 'Voltar',
                    hint: 'Toque para voltar à tela inicial',
                    child: IconButton(
                      onPressed: () {
                        HapticFeedback.lightImpact();
                        Navigator.pop(context);
                      },
                      icon: const Icon(
                        Icons.arrow_back,
                        color: AppColors.gold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              
              // Brand Logo
              Column(
                children: [
                  Semantics(
                    image: true,
                    label: 'Logo do aplicativo Virar',
                    child: Container(
                      width: 160,
                      height: 96,
                      alignment: Alignment.center,
                      child: Image.asset(
                        'assets/images/logo.png',
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'VIRAR',
                    style: TextStyle(
                      color: AppColors.gold,
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Poppins',
                      letterSpacing: 1.8,
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 40),
              
              // Welcome Text
              Text(
                strings.text('login_welcome'),
                style: TextStyle(
                  color: AppColors.softWhite,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Poppins',
                ),
                textAlign: TextAlign.center,
              ),
              
              const SizedBox(height: 8),
              
              Text(
                strings.text('login_subtitle'),
                style: TextStyle(
                  color: AppColors.lightGray.withOpacity(0.8),
                  fontSize: 16,
                  fontFamily: 'Poppins',
                ),
                textAlign: TextAlign.center,
              ),
              
              const SizedBox(height: 40),
              
              // Form Fields
              Form(
                key: _formKey,
                child: Column(
                  children: [
                  // Email Field
                  _buildFieldWithLibrasSupport(
                    isLibrasSelected: isLibrasSelected,
                    gifTitle: 'E-mail em Libras',
                    gifAssetPath: 'assets/images/E-MAIL.gif',
                    child: AuthTextField(
                      label: strings.text('email_label'),
                      hint: strings.text('email_hint_registered'),
                      icon: Icons.email_outlined,
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return strings.text('enter_email');
                        }
                        if (!value.contains('@')) {
                          return strings.text('enter_valid_email');
                        }
                        return null;
                      },
                    ),
                  ),
                  
                  const SizedBox(height: 20),
                  
                  // Password Field
                  _buildFieldWithLibrasSupport(
                    isLibrasSelected: isLibrasSelected,
                    gifTitle: 'Senha em Libras',
                    gifAssetPath: 'assets/images/SENHA.gif',
                    child: AuthTextField(
                      label: strings.text('password'),
                      hint: strings.text('password_hint'),
                      icon: Icons.lock_outline,
                      isPassword: true,
                      obscureText: _obscurePassword,
                      onTogglePassword: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                      controller: _passwordController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return strings.text('enter_password');
                        }
                        if (value.length < 6) {
                          return strings.text('password_min_length');
                        }
                        return null;
                      },
                    ),
                  ),
                  
                  const SizedBox(height: 16),
                  
                  Align(
                    alignment: Alignment.centerRight,
                    child: isLibrasSelected
                        ? Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              TextButton(
                                onPressed: () {
                                  HapticFeedback.lightImpact();
                                  _announce('Recuperação de senha em breve');
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Recuperação de senha em breve'),
                                    ),
                                  );
                                },
                                child: Text(
                                  strings.text('forgot_password'),
                                  style: TextStyle(
                                    color: AppColors.gold,
                                    fontSize: 14,
                                    fontFamily: 'Poppins',
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              _buildLibrasGifButton(
                                title: 'Esqueci minha senha em Libras',
                                assetPath: 'assets/images/ESQUECI MINHA SENHA.gif',
                              ),
                            ],
                          )
                        : TextButton(
                            onPressed: () {
                              HapticFeedback.lightImpact();
                              _announce('Recuperação de senha em breve');
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Recuperação de senha em breve'),
                                ),
                              );
                            },
                            child: Text(
                              strings.text('forgot_password'),
                              style: TextStyle(
                                color: AppColors.gold,
                                fontSize: 14,
                                fontFamily: 'Poppins',
                              ),
                            ),
                          ),
                  ),
                ],
              ),
              ),
              
              const SizedBox(height: 32),
              
              // Login Button
              Semantics(
                button: true,
                label: 'Entrar',
                hint: 'Toque para autenticar com e-mail e senha',
                child: SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: () async {
                    HapticFeedback.mediumImpact();
                    if (!_formKey.currentState!.validate()) {
                      _announce('Existem campos inválidos no formulário');
                      return;
                    }
                    
                    final authProvider = Provider.of<AuthProvider>(context, listen: false);
                    
                    final success = await authProvider.signIn(
                      _emailController.text.trim(),
                      _passwordController.text,
                    );
                    
                    if (success) {
                      _announce('Login realizado com sucesso');
                      final destination = isLibrasSelected
                          ? '/accessibility/home'
                          : '/citizen/home';
                      Navigator.pushReplacementNamed(context, destination);
                    } else {
                      _announce(authProvider.errorMessage ?? strings.text('login_error'));
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(authProvider.errorMessage ?? strings.text('login_error')),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.gold,
                      foregroundColor: AppColors.deepBlack,
                      elevation: 8,
                      shadowColor: AppColors.gold.withOpacity(0.4),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: Text(
                      strings.text('sign_in'),
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Poppins',
                        letterSpacing: 1,
                      ),
                    ),
                  ),
                ),
              ),
              
              const SizedBox(height: 24),
              
              // Sign Up Link
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    strings.text('no_account'),
                    style: TextStyle(
                      color: AppColors.lightGray.withOpacity(0.8),
                      fontSize: 14,
                      fontFamily: 'Poppins',
                    ),
                  ),
                  Semantics(
                    button: true,
                    label: strings.text('create_account'),
                    hint: 'Toque para abrir a tela de cadastro',
                    child: TextButton(
                      onPressed: () {
                        HapticFeedback.lightImpact();
                        Navigator.pushNamed(context, '/register');
                      },
                    child: Text(
                      strings.text('create_account'),
                      style: TextStyle(
                        color: AppColors.gold,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Poppins',
                      ),
                    ),
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 40),
              
              // Footer
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.star,
                        color: AppColors.gold,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Icon(
                        Icons.star,
                        color: AppColors.gold,
                        size: 20,
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'SERVIÇOS DE HONRA',
                    style: TextStyle(
                      color: AppColors.gold,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Poppins',
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildFieldWithLibrasSupport({
    required bool isLibrasSelected,
    required Widget child,
    required String gifTitle,
    required String gifAssetPath,
  }) {
    if (!isLibrasSelected) {
      return child;
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: child,
        ),
        const SizedBox(width: 12),
        _buildLibrasGifButton(
          title: gifTitle,
          assetPath: gifAssetPath,
        ),
      ],
    );
  }

  Widget _buildLibrasGifButton({
    required String title,
    required String assetPath,
  }) {
    return SizedBox(
      width: 52,
      height: 52,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _showLibrasVideo(context, title, assetPath),
          borderRadius: BorderRadius.circular(16),
          child: Ink(
            decoration: BoxDecoration(
              color: AppColors.gold.withOpacity(0.14),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.gold.withOpacity(0.5)),
              boxShadow: [
                BoxShadow(
                  color: AppColors.gold.withOpacity(0.12),
                  blurRadius: 12,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: const Center(
              child: Icon(
                Icons.touch_app,
                color: AppColors.gold,
                size: 24,
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showLibrasVideo(BuildContext context, String title, String assetPath) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return Dialog(
          backgroundColor: const Color(0xFF1A1614),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: const TextStyle(
                          color: AppColors.softWhite,
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          fontFamily: 'Poppins',
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.of(dialogContext).pop(),
                      icon: const Icon(Icons.close, color: AppColors.gold),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                ClipRRect(
                  borderRadius: BorderRadius.circular(18),
                  child: Image.asset(assetPath, fit: BoxFit.contain),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
