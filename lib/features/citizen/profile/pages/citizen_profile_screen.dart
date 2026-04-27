import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../../../../core/localization/app_localizations.dart';
import '../../../../../core/theme/app_theme.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../../../core/services/profile_service.dart';
import '../../../home/presentation/pages/map_screen.dart';
import '../../../search/presentation/pages/search_screen.dart';

class CitizenProfileScreen extends StatefulWidget {
  const CitizenProfileScreen({super.key});

  @override
  State<CitizenProfileScreen> createState() => _CitizenProfileScreenState();
}

class _CitizenProfileScreenState extends State<CitizenProfileScreen> {

  void _onNavTap(int index) {
    HapticFeedback.lightImpact();
    if (index == 0) {
      Navigator.pushReplacementNamed(context, '/home');
    } else if (index == 1) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const SearchScreen(),
        ),
      );
    } else if (index == 2) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const MapScreen(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final strings = context.t;
    
    return Scaffold(
      backgroundColor: AppColors.deepBlack,
      appBar: AppBar(
        backgroundColor: AppColors.deepBlack,
        elevation: 0,
        leading: Semantics(
          button: true,
          label: 'Voltar',
          hint: 'Toque para voltar para a tela anterior',
          child: IconButton(
            icon: Semantics(
              label: 'Ícone de voltar',
              child: const Icon(Icons.arrow_back, color: AppColors.gold),
            ),
            onPressed: () {
              HapticFeedback.lightImpact();
              Navigator.pop(context);
            },
          ),
        ),
        title: Semantics(
          header: true,
          label: strings.text('my_profile'),
          child: Text(
            strings.text('my_profile'),
            style: TextStyle(
              color: AppColors.gold,
              fontSize: 20,
              fontWeight: FontWeight.w600,
              fontFamily: 'Poppins',
            ),
          ),
        ),
        actions: [
          Semantics(
            button: true,
            label: 'Editar perfil',
            hint: 'Toque para editar seu perfil',
            child: IconButton(
              icon: Semantics(
                label: 'Ícone de editar',
                child: const Icon(Icons.edit, color: AppColors.gold),
              ),
              onPressed: () {
                HapticFeedback.lightImpact();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(strings.text('profile_edit_soon')),
                    backgroundColor: AppColors.gold,
                  ),
                );
              },
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Profile Header
              Semantics(
                label: 'Cabeçalho do perfil',
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: AppColors.darkBrown.withOpacity(0.6),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: AppColors.gold.withOpacity(0.2),
                      width: 1,
                    ),
                  ),
                  child: Column(
                    children: [
                      // Avatar
                      Semantics(
                        label: 'Foto de perfil',
                        image: true,
                        child: Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            color: AppColors.gold.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(40),
                          ),
                          child: const Icon(
                            Icons.person,
                            color: AppColors.gold,
                            size: 40,
                          ),
                        ),
                      ),
                      
                      const SizedBox(height: 16),
                      
                      // Name
                      Text(
                        authProvider.currentUser?.userMetadata?['full_name'] ?? strings.text('user'),
                        style: const TextStyle(
                          color: AppColors.softWhite,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Poppins',
                        ),
                      ),
                      
                      const SizedBox(height: 8),
                      
                      // Email
                      Text(
                        authProvider.currentUser?.email ?? 'email@exemplo.com',
                        style: TextStyle(
                          color: AppColors.lightGray.withOpacity(0.8),
                          fontSize: 16,
                          fontFamily: 'Poppins',
                        ),
                      ),
                      
                      const SizedBox(height: 16),
                      
                      // Profile Type
                      Semantics(
                        label: 'Tipo de perfil: Cidadão',
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            color: AppColors.gold.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Text(
                            'Cidadão',
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
                ),
              ),
            
              const SizedBox(height: 24),
            
              // Personal Information
              _buildSection(
                strings.text('personal_information'),
                [
                  _buildInfoItem(strings.text('complete_name'), authProvider.currentUser?.userMetadata?['full_name'] ?? strings.text('not_informed')),
                  _buildInfoItem(strings.text('email_label'), authProvider.currentUser?.email ?? strings.text('not_informed')),
                  _buildInfoItem(strings.text('phone'), authProvider.currentUser?.userMetadata?['phone'] ?? strings.text('not_informed')),
                ],
              ),
            
              const SizedBox(height: 24),
            
              // App Settings
              _buildSection(
                strings.text('app_settings'),
                [
                  _buildSettingItem(
                    strings.text('notifications'),
                    strings.text('receive_alerts'),
                    Icons.notifications_outlined,
                    true,
                  ),
                ],
              ),
            
              const SizedBox(height: 24),
            
              // Support
            _buildSection(
                strings.text('support'),
                [
                  _buildActionItem(
                    strings.text('help_center'),
                    strings.text('faq_support'),
                    Icons.help_outline,
                    () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(strings.text('feature_in_development')),
                          backgroundColor: AppColors.gold,
                        ),
                      );
                    },
                  ),
                  _buildActionItem(
                    strings.text('contact_us'),
                    strings.text('get_in_touch'),
                    Icons.message_outlined,
                    () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(strings.text('feature_in_development')),
                          backgroundColor: AppColors.gold,
                        ),
                      );
                    },
                  ),
                  _buildActionItem(
                    strings.text('privacy_policy'),
                    strings.text('privacy_policy_desc'),
                    Icons.privacy_tip_outlined,
                    () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(strings.text('feature_in_development')),
                          backgroundColor: AppColors.gold,
                        ),
                      );
                    },
                  ),
                  _buildActionItem(
                    strings.text('terms_of_use'),
                    strings.text('terms_of_use_desc'),
                    Icons.description_outlined,
                    () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(strings.text('feature_in_development')),
                          backgroundColor: AppColors.gold,
                        ),
                      );
                    },
                  ),
                ],
              ),
            
              const SizedBox(height: 24),
            
              // Logout Button
              Semantics(
                button: true,
                label: strings.text('logout'),
                hint: 'Toque para sair da sua conta',
                child: Container(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      HapticFeedback.heavyImpact();
                      _showLogoutDialog(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red.withOpacity(0.8),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      strings.text('logout'),
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Poppins',
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: AppColors.deepBlack,
          border: Border(
            top: BorderSide(color: AppColors.gold.withOpacity(0.3)),
          ),
        ),
        child: BottomNavigationBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          type: BottomNavigationBarType.fixed,
          currentIndex: 3,
          selectedItemColor: AppColors.gold,
          unselectedItemColor: AppColors.lightGray,
          onTap: _onNavTap,
          items: [
            BottomNavigationBarItem(
              icon: Semantics(
                label: 'Ícone de casa',
                child: const Icon(Icons.home),
              ),
              label: strings.text('home_nav'),
            ),
            BottomNavigationBarItem(
              icon: Semantics(
                label: 'Ícone de lupa',
                child: const Icon(Icons.search),
              ),
              label: strings.text('search_nav'),
            ),
            BottomNavigationBarItem(
              icon: Semantics(
                label: 'Ícone de mapa',
                child: const Icon(Icons.map_outlined),
              ),
              label: 'Mapa',
            ),
            BottomNavigationBarItem(
              icon: Semantics(
                label: 'Ícone de pessoa',
                child: const Icon(Icons.person),
              ),
              label: strings.text('profile_nav'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, List<Widget> children) {
    return Semantics(
      label: 'Seção: $title',
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.darkBrown.withOpacity(0.6),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: AppColors.gold.withOpacity(0.2),
            width: 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                color: AppColors.gold,
                fontSize: 18,
                fontWeight: FontWeight.w600,
                fontFamily: 'Poppins',
              ),
            ),
            const SizedBox(height: 16),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildInfoItem(String label, String value) {
    return Semantics(
      label: '$label: $value',
      child: Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 120,
              child: Text(
                label,
                style: TextStyle(
                  color: AppColors.gold.withOpacity(0.8),
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  fontFamily: 'Poppins',
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                value,
                style: TextStyle(
                  color: AppColors.lightGray.withOpacity(0.8),
                  fontSize: 14,
                  fontFamily: 'Poppins',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingItem(String title, String description, IconData icon, bool isEnabled) {
    return Semantics(
      button: true,
      label: '$title, $description',
      hint: isEnabled ? 'Ativado, toque para desativar' : 'Desativado, toque para ativar',
      onTap: () {
        HapticFeedback.lightImpact();
      },
      child: Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: Row(
          children: [
            Semantics(
              label: _getIconLabel(icon),
              child: Icon(
                icon,
                color: AppColors.gold.withOpacity(0.8),
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: AppColors.softWhite,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      fontFamily: 'Poppins',
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: TextStyle(
                      color: AppColors.lightGray.withOpacity(0.6),
                      fontSize: 12,
                      fontFamily: 'Poppins',
                    ),
                  ),
                ],
              ),
            ),
            Semantics(
              label: isEnabled ? 'Alternadora ativada' : 'Alternadora desativada',
              child: Switch(
                value: isEnabled,
                onChanged: (value) {
                  HapticFeedback.lightImpact();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(context.t.text('feature_in_development')),
                      backgroundColor: AppColors.gold,
                    ),
                  );
                },
                activeColor: AppColors.gold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionItem(String title, String subtitle, IconData icon, VoidCallback onTap) {
    return Semantics(
      button: true,
      label: title,
      hint: subtitle,
      onTap: () {
        HapticFeedback.lightImpact();
        onTap();
      },
      child: InkWell(
        onTap: () {
          HapticFeedback.lightImpact();
          onTap();
        },
        child: Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: Row(
            children: [
              Semantics(
                label: _getIconLabel(icon),
                child: Icon(
                  icon,
                  color: AppColors.gold.withOpacity(0.8),
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        color: AppColors.softWhite,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        fontFamily: 'Poppins',
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: TextStyle(
                        color: AppColors.lightGray.withOpacity(0.6),
                        fontSize: 12,
                        fontFamily: 'Poppins',
                      ),
                    ),
                  ],
                ),
              ),
              Semantics(
                label: 'Ícone de seta para frente',
                child: Icon(
                  Icons.arrow_forward_ios,
                  color: AppColors.gold.withOpacity(0.6),
                  size: 16,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => Semantics(
        label: 'Diálogo de confirmação de logout',
        child: AlertDialog(
          backgroundColor: AppColors.darkBrown,
          title: const Text(
            'Sair da Conta',
            style: TextStyle(
              color: AppColors.gold,
              fontSize: 18,
              fontWeight: FontWeight.w600,
              fontFamily: 'Poppins',
            ),
          ),
          content: const Text(
            'Tem certeza que deseja sair da sua conta?',
            style: TextStyle(
              color: AppColors.softWhite,
              fontSize: 16,
              fontFamily: 'Poppins',
            ),
          ),
          actions: [
            Semantics(
              button: true,
              label: 'Cancelar',
              hint: 'Toque para cancelar e permanecer na conta',
              child: TextButton(
                onPressed: () {
                  HapticFeedback.lightImpact();
                  Navigator.pop(context);
                },
                child: const Text(
                  'Cancelar',
                  style: TextStyle(
                    color: AppColors.gold,
                    fontSize: 16,
                    fontFamily: 'Poppins',
                  ),
                ),
              ),
            ),
            Semantics(
              button: true,
              label: 'Confirmar saída',
              hint: 'Toque para confirmar e sair da conta',
              child: ElevatedButton(
                onPressed: () {
                  HapticFeedback.heavyImpact();
                  Navigator.pop(context);
                  Provider.of<AuthProvider>(context, listen: false).signOut();
                  Navigator.pushReplacementNamed(context, '/');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red.withOpacity(0.8),
                  foregroundColor: Colors.white,
                ),
                child: const Text(
                  'Sair',
                  style: TextStyle(
                    fontSize: 16,
                    fontFamily: 'Poppins',
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getIconLabel(IconData icon) {
    if (icon == Icons.notifications_outlined) return 'Notificações';
    if (icon == Icons.help_outline) return 'Ajuda';
    if (icon == Icons.message_outlined) return 'Contato';
    if (icon == Icons.privacy_tip_outlined) return 'Privacidade';
    if (icon == Icons.description_outlined) return 'Termos de uso';
    return 'Ícone';
  }
}
