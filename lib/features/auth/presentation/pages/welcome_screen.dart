import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:app_settings/app_settings.dart';
import '../../../../../core/localization/app_language.dart';
import '../../../../../core/localization/app_localizations.dart';
import '../../../../../core/providers/app_language_provider.dart';
import '../../../../../core/theme/app_theme.dart';
import '../../../../../core/constants/app_constants.dart';
import '../../../../../core/widgets/global_zoom_fab.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  Future<void> _openAccessibilitySettings(BuildContext context) async {
    try {
      await AppSettings.openAppSettings(type: AppSettingsType.accessibility);
    } catch (_) {
      if (!context.mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Não foi possível abrir as configurações de acessibilidade.'),
        ),
      );
    }
  }

  Widget _buildLanguageButton({
    required AppLanguage language,
    required AppLanguage currentLanguage,
    required VoidCallback onTap,
    required String label,
    String? prefix,
    IconData? icon,
  }) {
    final isSelected = currentLanguage == language;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        height: 46,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isSelected ? AppColors.gold : Colors.transparent,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: isSelected ? AppColors.gold : AppColors.gold.withOpacity(0.26),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (prefix != null)
                  Text(
                    prefix,
                    style: const TextStyle(fontSize: 14),
                  ),
                if (prefix != null) const SizedBox(width: 6),
                if (icon != null)
                  Icon(
                    icon,
                    color: isSelected ? AppColors.deepBlack : AppColors.softWhite,
                    size: 16,
                  ),
                if (icon != null) const SizedBox(width: 6),
                Text(
                  label,
                  maxLines: 1,
                  style: TextStyle(
                    color: isSelected ? AppColors.deepBlack : AppColors.softWhite,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Poppins',
                  ),
                ),
              ],
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
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
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
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Poppins',
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.of(dialogContext).pop(),
                      icon: const Icon(
                        Icons.close,
                        color: AppColors.gold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                ClipRRect(
                  borderRadius: BorderRadius.circular(18),
                  child: Image.asset(
                    assetPath,
                    fit: BoxFit.contain,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final strings = context.t;
    final languageProvider = Provider.of<AppLanguageProvider>(context);
    final isLibrasSelected =
        languageProvider.currentLanguage == AppLanguage.libras;

    return Scaffold(
      floatingActionButton: const GlobalZoomFAB(),
      body: Stack(
        children: [
          // Background Image with Blur
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/Gemini_Generated_Image_2rcf452rcf452rcf.png'),
                fit: BoxFit.cover,
              ),
            ),
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    const Color(0xFF120F0D).withOpacity(0.58),
                    const Color(0xFF1A1614).withOpacity(0.76),
                    const Color(0xFF1A1614).withOpacity(0.92),
                  ],
                ),
              ),
            ),
          ),
          
          // Content
          SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 36),
                   
                  // Logo Section
                  Column(
                    children: [
                      Container(
                        width: 180,
                        height: 120,
                        alignment: Alignment.center,
                        child: Center(
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
                          fontSize: 34,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Poppins',
                          letterSpacing: 1.8,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        strings.text('app_tagline'),
                        style: TextStyle(
                          color: AppColors.softWhite.withOpacity(0.76),
                          fontSize: 12,
                          fontFamily: 'Poppins',
                          letterSpacing: 0.2,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                   
                  const SizedBox(height: 26),
                   
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 26),
                    padding: const EdgeInsets.fromLTRB(26, 30, 26, 28),
                    decoration: BoxDecoration(
                      color: const Color(0xFF2A1F1D).withOpacity(0.42),
                      borderRadius: BorderRadius.circular(28),
                      border: Border.all(
                        color: AppColors.gold.withOpacity(0.22),
                        width: 1,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.28),
                          blurRadius: 32,
                          offset: const Offset(0, 18),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          strings.text('welcome_title'),
                          style: TextStyle(
                            color: AppColors.softWhite,
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Poppins',
                            height: 1.22,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        
                        const SizedBox(height: 14),
                        
                        Text(
                          strings.text('welcome_description'),
                          style: TextStyle(
                            color: AppColors.softWhite.withOpacity(0.78),
                            fontSize: 15,
                            fontFamily: 'Poppins',
                            height: 1.6,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        
                        const SizedBox(height: 18),

                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: AppColors.deepBlack.withOpacity(0.28),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: isLibrasSelected
                                  ? AppColors.gold.withOpacity(0.70)
                                  : AppColors.gold.withOpacity(0.28),
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                'Acessibilidade',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: AppColors.softWhite,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                  fontFamily: 'Poppins',
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Ative o TalkBack para melhorar a acessibilidade visual.',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: AppColors.softWhite.withOpacity(0.78),
                                  fontSize: 13,
                                  fontFamily: 'Poppins',
                                  height: 1.5,
                                ),
                              ),
                              const SizedBox(height: 14),
                              Row(
                                children: [
                                  Expanded(
                                    child: SizedBox(
                                      height: 52,
                                      child: ElevatedButton.icon(
                                        onPressed: () async {
                                          HapticFeedback.mediumImpact();
                                          languageProvider.setLanguage(AppLanguage.libras);
                                          if (!context.mounted) {
                                            return;
                                          }

                                          ScaffoldMessenger.of(context).showSnackBar(
                                            const SnackBar(
                                              content: Text(
                                                'Você será redirecionado para as configurações de acessibilidade para ativar o TalkBack/VoiceOver.',
                                              ),
                                            ),
                                          );
                                          await _openAccessibilitySettings(context);
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: AppColors.gold,
                                          foregroundColor: AppColors.deepBlack,
                                          elevation: 0,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(18),
                                          ),
                                        ),
                                        icon: const Icon(Icons.record_voice_over),
                                        label: const Text(
                                          'Acessibilidade',
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w700,
                                            fontFamily: 'Poppins',
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              if (isLibrasSelected) ...[
                                const SizedBox(height: 10),
                                Text(
                                  'Modo acessível ativado.',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: AppColors.gold,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    fontFamily: 'Poppins',
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),

                        const SizedBox(height: 28),

                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: AppColors.deepBlack.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(24),
                            border: Border.all(
                              color: AppColors.gold.withOpacity(0.35),
                            ),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                          child: _buildLanguageButton(
                                            language: AppLanguage.portuguese,
                                            currentLanguage: languageProvider.currentLanguage,
                                            onTap: () => languageProvider.setLanguage(AppLanguage.portuguese),
                                            prefix: '🇧🇷',
                                            label: 'Português',
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Expanded(
                                          child: _buildLanguageButton(
                                            language: AppLanguage.english,
                                            currentLanguage: languageProvider.currentLanguage,
                                            onTap: () => languageProvider.setLanguage(AppLanguage.english),
                                            prefix: '🇬🇧',
                                            label: 'English',
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Expanded(
                                          child: _buildLanguageButton(
                                            language: AppLanguage.spanish,
                                            currentLanguage: languageProvider.currentLanguage,
                                            onTap: () => languageProvider.setLanguage(AppLanguage.spanish),
                                            prefix: '🇪🇸',
                                            label: 'Español',
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 10),
                                    _buildLanguageButton(
                                      language: AppLanguage.libras,
                                      currentLanguage: languageProvider.currentLanguage,
                                      onTap: () => languageProvider.setLanguage(AppLanguage.libras),
                                      icon: Icons.waving_hand,
                                      label: 'Libras',
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        
                        Column(
                          children: [
                            const SizedBox(height: 28),
                            Row(
                              children: [
                                Expanded(
                                  child: SizedBox(
                                    height: 60,
                                    child: OutlinedButton(
                                      onPressed: () {
                                        Navigator.pushNamed(context, '/register');
                                      },
                                      style: OutlinedButton.styleFrom(
                                        backgroundColor: Colors.transparent,
                                        side: BorderSide(color: AppColors.gold.withOpacity(0.75), width: 1.7),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(24),
                                        ),
                                      ),
                                      child: FittedBox(
                                        fit: BoxFit.scaleDown,
                                        child: Text(
                                          strings.text('welcome_start_service'),
                                          maxLines: 1,
                                          style: TextStyle(
                                            fontSize: isLibrasSelected ? 14 : 17,
                                            fontWeight: FontWeight.w600,
                                            fontFamily: 'Poppins',
                                            color: AppColors.gold,
                                            letterSpacing: isLibrasSelected ? 0 : 0.2,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                if (isLibrasSelected) ...[
                                  const SizedBox(width: 12),
                                  SizedBox(
                                    width: 60,
                                    height: 60,
                                    child: ElevatedButton(
                                      onPressed: () {
                                        _showLibrasVideo(
                                          context,
                                          'Cadastro em Libras',
                                          'assets/images/INSCRIÇÃO CADASTRO.gif',
                                        );
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: AppColors.gold,
                                        foregroundColor: const Color(0xFF1A1614),
                                        elevation: 10,
                                        shadowColor: AppColors.gold.withOpacity(0.38),
                                        padding: EdgeInsets.zero,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(22),
                                        ),
                                      ),
                                      child: const Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Icon(Icons.touch_app, size: 18),
                                          SizedBox(height: 2),
                                          Icon(Icons.ondemand_video, size: 18),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ],
                            ),
                            
                            const SizedBox(height: 18),
                            
                            Row(
                              children: [
                                Expanded(
                                  child: SizedBox(
                                    height: 60,
                                    child: OutlinedButton(
                                      onPressed: () {
                                        Navigator.pushNamed(context, '/login');
                                      },
                                      style: OutlinedButton.styleFrom(
                                        backgroundColor: Colors.transparent,
                                        side: BorderSide(color: AppColors.gold.withOpacity(0.75), width: 1.7),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(22),
                                        ),
                                      ),
                                      child: FittedBox(
                                        fit: BoxFit.scaleDown,
                                        child: Text(
                                          strings.text('welcome_already_registered'),
                                          maxLines: 1,
                                          style: TextStyle(
                                            fontSize: isLibrasSelected ? 14 : 17,
                                            fontWeight: FontWeight.w600,
                                            fontFamily: 'Poppins',
                                            color: AppColors.gold,
                                            letterSpacing: isLibrasSelected ? 0 : 0.2,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                if (isLibrasSelected) ...[
                                  const SizedBox(width: 12),
                                  SizedBox(
                                    width: 60,
                                    height: 60,
                                    child: OutlinedButton(
                                      onPressed: () {
                                        _showLibrasVideo(
                                          context,
                                          'Login em Libras',
                                          'assets/images/USUÁRIO.gif',
                                        );
                                      },
                                      style: OutlinedButton.styleFrom(
                                        backgroundColor: Colors.transparent,
                                        side: BorderSide(color: AppColors.gold.withOpacity(0.75), width: 1.7),
                                        padding: EdgeInsets.zero,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(22),
                                        ),
                                      ),
                                      child: const Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.touch_app,
                                            color: AppColors.gold,
                                            size: 18,
                                          ),
                                          SizedBox(height: 2),
                                          Icon(
                                            Icons.ondemand_video,
                                            color: AppColors.gold,
                                            size: 18,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 34),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
