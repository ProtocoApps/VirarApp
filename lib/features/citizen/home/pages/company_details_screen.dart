import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../../core/theme/app_theme.dart';
import '../../profile/pages/citizen_profile_screen.dart';

class CompanyDetailsScreen extends StatelessWidget {
  final Map<String, dynamic> company;

  const CompanyDetailsScreen({
    super.key,
    required this.company,
  });

  @override
  Widget build(BuildContext context) {
    if (company['detailLayout'] == 'elite') {
      return _buildEliteLayout(context);
    }

    return Scaffold(
      backgroundColor: AppColors.deepBlack,
      body: CustomScrollView(
        slivers: [
          // App Bar com imagem
          SliverAppBar(
            expandedHeight: 250,
            pinned: true,
            backgroundColor: AppColors.deepBlack,
            flexibleSpace: FlexibleSpaceBar(
              background: Semantics(
                image: true,
                label: 'Imagem da empresa ${company['name']}',
                child: company['image'].toString().startsWith('http')
                  ? Image.network(
                      company['image'],
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: AppColors.gold.withOpacity(0.1),
                          child: Center(
                            child: Icon(
                              Icons.business,
                              color: AppColors.gold.withOpacity(0.4),
                              size: 80,
                            ),
                          ),
                        );
                      },
                    )
                  : Container(
                      color: AppColors.gold.withOpacity(0.1),
                      child: Center(
                        child: Icon(
                          Icons.business,
                          color: AppColors.gold.withOpacity(0.4),
                          size: 80,
                        ),
                      ),
                    ),
              ),
            ),
            leading: Semantics(
              button: true,
              label: 'Voltar',
              hint: 'Toque para voltar à tela anterior',
              child: IconButton(
                icon: const Icon(Icons.arrow_back, color: AppColors.gold),
                onPressed: () {
                  HapticFeedback.lightImpact();
                  Navigator.pop(context);
                },
              ),
            ),
            actions: [
              Semantics(
                button: true,
                label: 'Adicionar aos favoritos',
                hint: 'Toque para favoritar esta empresa',
                child: IconButton(
                  icon: const Icon(Icons.favorite_border, color: AppColors.gold),
                  onPressed: () {
                    HapticFeedback.lightImpact();
                  },
                ),
              ),
              Semantics(
                button: true,
                label: 'Compartilhar',
                hint: 'Toque para compartilhar esta empresa',
                child: IconButton(
                  icon: const Icon(Icons.share, color: AppColors.gold),
                  onPressed: () {
                    HapticFeedback.lightImpact();
                  },
                ),
              ),
            ],
          ),
          
          // Conteúdo
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Nome e categoria
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              company['name'],
                              style: const TextStyle(
                                color: AppColors.softWhite,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Poppins',
                              ),
                            ),
                            const SizedBox(height: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: AppColors.gold.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Text(
                                company['category'],
                                style: const TextStyle(
                                  color: AppColors.gold,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: 'Poppins',
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (company['is24h'] == true)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.green,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Text(
                            '24h',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              fontFamily: 'Poppins',
                            ),
                          ),
                        ),
                    ],
                  ),
                  
                  const SizedBox(height: 20),
                  
                  // Rating e reviews
                  Row(
                    children: [
                      Row(
                        children: [
                          const Icon(
                            Icons.star,
                            color: AppColors.gold,
                            size: 20,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            company['rating'].toString(),
                            style: const TextStyle(
                              color: AppColors.softWhite,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              fontFamily: 'Poppins',
                            ),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '(${company['reviews']} avaliações)',
                            style: TextStyle(
                              color: AppColors.lightGray.withOpacity(0.8),
                              fontSize: 14,
                              fontFamily: 'Poppins',
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Descrição
                  Text(
                    'Sobre',
                    style: const TextStyle(
                      color: AppColors.softWhite,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Poppins',
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    company['description'],
                    style: TextStyle(
                      color: AppColors.lightGray.withOpacity(0.9),
                      fontSize: 16,
                      fontFamily: 'Poppins',
                      height: 1.5,
                    ),
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Informações de contato
                  _buildInfoSection(
                    'Informações',
                    [
                      _buildInfoItem(Icons.phone, company['phone'], () async {
                        final Uri phoneUri = Uri(
                          scheme: 'tel',
                          path: company['phone'].toString().replaceAll(RegExp(r'\D'), ''),
                        );
                        if (await canLaunchUrl(phoneUri)) {
                          await launchUrl(phoneUri);
                        }
                      }),
                      _buildInfoItem(Icons.email, company['email'], () async {
                        final Uri emailUri = Uri(
                          scheme: 'mailto',
                          path: company['email'],
                        );
                        if (await canLaunchUrl(emailUri)) {
                          await launchUrl(emailUri);
                        }
                      }),
                      _buildInfoItem(Icons.language, company['website'], () async {
                        final Uri websiteUri = Uri(
                          scheme: 'https',
                          host: company['website'].toString().replaceFirst('www.', '').replaceFirst('https://', '').replaceFirst('http://', ''),
                        );
                        if (await canLaunchUrl(websiteUri)) {
                          await launchUrl(websiteUri);
                        }
                      }),
                      _buildInfoItem(Icons.location_on, company['address'], null),
                      _buildInfoItem(Icons.access_time, company['hours'], null),
                    ],
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Serviços
                  if (company['services'] != null)
                    _buildServicesSection(company['services']),
                  
                  const SizedBox(height: 32),
                  
                  // Botões de ação
                  Row(
                    children: [
                      Expanded(
                        child: Semantics(
                          button: true,
                          label: 'Ligar agora',
                          hint: 'Toque para ligar para ${company['name']}',
                          child: ElevatedButton(
                          onPressed: () async {
                            HapticFeedback.mediumImpact();
                            final Uri phoneUri = Uri(
                              scheme: 'tel',
                              path: company['phone'].toString().replaceAll(RegExp(r'\D'), ''),
                            );
                            if (await canLaunchUrl(phoneUri)) {
                              await launchUrl(phoneUri);
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.gold,
                            foregroundColor: const Color(0xFF1A1614),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text(
                            'Ligar Agora',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              fontFamily: 'Poppins',
                            ),
                          ),
                        ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Semantics(
                          button: true,
                          label: 'WhatsApp',
                          hint: 'Toque para iniciar conversa no WhatsApp com ${company['name']}',
                          child: OutlinedButton(
                            onPressed: () async {
                              HapticFeedback.mediumImpact();
                              final Uri whatsappUri = Uri(
                                scheme: 'https',
                                host: 'wa.me',
                                path: '55${company['phone'].toString().replaceAll(RegExp(r'\D'), '')}',
                              );
                              if (await canLaunchUrl(whatsappUri)) {
                                await launchUrl(whatsappUri);
                              }
                            },
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(color: AppColors.gold),
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: const Text(
                              'WhatsApp',
                              style: TextStyle(
                                color: AppColors.gold,
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
                  
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: AppColors.softWhite,
            fontSize: 18,
            fontWeight: FontWeight.w600,
            fontFamily: 'Poppins',
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.darkBrown.withOpacity(0.6),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: AppColors.gold.withOpacity(0.2),
              width: 1,
            ),
          ),
          child: Column(
            children: children,
          ),
        ),
      ],
    );
  }

  Widget _buildInfoItem(IconData icon, String text, VoidCallback? onTap) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Semantics(
        button: onTap != null,
        label: text,
        hint: onTap != null ? 'Toque para interagir' : null,
        child: InkWell(
        onTap: onTap,
        child: Row(
          children: [
            Icon(
              icon,
              color: AppColors.gold,
              size: 20,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                text,
                style: TextStyle(
                  color: onTap != null 
                      ? AppColors.softWhite 
                      : AppColors.lightGray.withOpacity(0.9),
                  fontSize: 16,
                  fontFamily: 'Poppins',
                ),
              ),
            ),
            if (onTap != null)
              Icon(
                Icons.arrow_forward_ios,
                color: AppColors.gold.withOpacity(0.6),
                size: 16,
              ),
          ],
        ),
        ),
      ),
    );
  }

  Widget _buildServicesSection(List<String> services) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Serviços',
          style: const TextStyle(
            color: AppColors.softWhite,
            fontSize: 18,
            fontWeight: FontWeight.w600,
            fontFamily: 'Poppins',
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.darkBrown.withOpacity(0.6),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: AppColors.gold.withOpacity(0.2),
              width: 1,
            ),
          ),
          child: Wrap(
            spacing: 8,
            runSpacing: 8,
            children: services.map((service) {
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.gold.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: AppColors.gold.withOpacity(0.3),
                    width: 1,
                  ),
                ),
                child: Text(
                  service,
                  style: const TextStyle(
                    color: AppColors.gold,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'Poppins',
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Scaffold _buildEliteLayout(BuildContext context) {
    final List<Map<String, dynamic>> eliteFeatures =
        (company['eliteFeatures'] as List<dynamic>? ?? const [])
            .whereType<Map<String, dynamic>>()
            .toList();
    const Color premiumGold = Color(0xFFFFD54A);
    const Color premiumGoldStrong = Color(0xFFFFC107);

    return Scaffold(
      backgroundColor: AppColors.deepBlack,
      bottomNavigationBar: _buildAppBottomNavigation(context),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 360,
              child: Stack(
                children: [
                  Positioned.fill(
                    child: company['image'].toString().startsWith('http')
                        ? Image.network(
                            company['image'],
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                color: premiumGold.withOpacity(0.16),
                                child: Center(
                                  child: Icon(
                                    Icons.business,
                                    color: premiumGoldStrong.withOpacity(0.72),
                                    size: 80,
                                  ),
                                ),
                              );
                            },
                          )
                        : Container(
                            color: premiumGold.withOpacity(0.16),
                            child: Center(
                              child: Icon(
                                Icons.business,
                                color: premiumGoldStrong.withOpacity(0.72),
                                size: 80,
                              ),
                            ),
                          ),
                  ),
                  Positioned.fill(
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            AppColors.deepBlack.withOpacity(0.10),
                            AppColors.deepBlack.withOpacity(0.04),
                            AppColors.deepBlack.withOpacity(0.72),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(12, 8, 12, 0),
                      child: Row(
                        children: [
                          Semantics(
                            button: true,
                            label: 'Voltar',
                            hint: 'Toque para voltar à tela anterior',
                            child: IconButton(
                              icon: const Icon(Icons.arrow_back, color: premiumGoldStrong),
                              onPressed: () {
                                HapticFeedback.lightImpact();
                                Navigator.pop(context);
                              },
                            ),
                          ),
                          Expanded(
                            child: Text(
                              company['brandName']?.toString() ?? '',
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: premiumGold,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                fontFamily: 'Poppins',
                              ),
                            ),
                          ),
                          Semantics(
                            button: true,
                            label: 'Compartilhar',
                            hint: 'Toque para compartilhar esta empresa',
                            child: IconButton(
                              icon: const Icon(Icons.share, color: premiumGoldStrong),
                              onPressed: () {
                                HapticFeedback.lightImpact();
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    left: 16,
                    right: 16,
                    bottom: 0,
                    child: Transform.translate(
                      offset: const Offset(0, 54),
                      child: Container(
                        padding: const EdgeInsets.fromLTRB(16, 16, 16, 18),
                        decoration: BoxDecoration(
                          color: AppColors.graphiteGray.withOpacity(0.48),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: premiumGoldStrong.withOpacity(0.92),
                            width: 1.2,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: premiumGoldStrong.withOpacity(0.24),
                              blurRadius: 18,
                              spreadRadius: 0,
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                              decoration: BoxDecoration(
                                color: premiumGoldStrong.withOpacity(0.24),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: premiumGoldStrong.withOpacity(0.95),
                                  width: 1,
                                ),
                              ),
                              child: Text(
                                company['category'],
                                style: const TextStyle(
                                  color: premiumGold,
                                  fontSize: 11,
                                  letterSpacing: 0.4,
                                  fontFamily: 'Poppins',
                                ),
                              ),
                            ),
                            const SizedBox(height: 14),
                            Text(
                              company['name'],
                              style: const TextStyle(
                                color: AppColors.softWhite,
                                fontSize: 26,
                                height: 1.12,
                                fontWeight: FontWeight.w700,
                                fontFamily: 'Poppins',
                              ),
                            ),
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                const Icon(
                                  Icons.star_rounded,
                                  color: premiumGoldStrong,
                                  size: 18,
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  company['rating']?.toString() ?? '-',
                                  style: const TextStyle(
                                    color: AppColors.softWhite,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    fontFamily: 'Poppins',
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  '(${company['reviews']?.toString() ?? '0'} avaliações)',
                                  style: TextStyle(
                                    color: premiumGold.withOpacity(0.94),
                                    fontSize: 12,
                                    fontFamily: 'Poppins',
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                const Icon(
                                  Icons.location_on,
                                  color: premiumGoldStrong,
                                  size: 15,
                                ),
                                const SizedBox(width: 6),
                                Expanded(
                                  child: Text(
                                    company['addressShort']?.toString() ?? company['address'].toString(),
                                    style: TextStyle(
                                      color: premiumGold.withOpacity(0.96),
                                      fontSize: 12,
                                      fontFamily: 'Poppins',
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 72),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildEliteSectionTitle('Sobre o Local'),
                  const SizedBox(height: 14),
                  Text(
                    company['eliteDescription']?.toString() ?? company['description'].toString(),
                    style: TextStyle(
                      color: AppColors.softWhite.withOpacity(0.88),
                      fontSize: 14,
                      height: 1.7,
                      fontFamily: 'Poppins',
                    ),
                  ),
                  const SizedBox(height: 28),
                  _buildEliteSectionTitle('Serviços'),
                  const SizedBox(height: 16),
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: eliteFeatures.length,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 12,
                      crossAxisSpacing: 12,
                      childAspectRatio: 1.2,
                    ),
                    itemBuilder: (context, index) {
                      final feature = eliteFeatures[index];
                      return _buildEliteFeatureTile(
                        feature['icon'] as IconData? ?? Icons.verified_outlined,
                        feature['label']?.toString() ?? '',
                      );
                    },
                  ),
                  const SizedBox(height: 24),
                  _buildEliteContactCard(),
                  const SizedBox(height: 18),
                  _buildEliteMapCard(context),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEliteSectionTitle(String title) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: AppColors.softWhite,
            fontSize: 22,
            fontWeight: FontWeight.w600,
            fontFamily: 'Poppins',
          ),
        ),
        const SizedBox(height: 6),
        Container(
          height: 2,
          width: 48,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [AppColors.gold, AppColors.lightGold.withOpacity(0.0)],
            ),
            borderRadius: BorderRadius.circular(2),
          ),
        ),
      ],
    );
  }

  Widget _buildEliteFeatureTile(IconData icon, String label) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.graphiteGray,
            AppColors.cardBackground,
          ],
        ),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: AppColors.gold.withOpacity(0.38),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.gold.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: AppColors.gold,
            size: 22,
          ),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: AppColors.softWhite,
                fontSize: 12,
                fontFamily: 'Poppins',
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEliteContactCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: AppColors.gold.withOpacity(0.40),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.gold.withOpacity(0.08),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Informações de Contato',
            style: TextStyle(
              color: AppColors.softWhite,
              fontSize: 16,
              fontWeight: FontWeight.w500,
              fontFamily: 'Poppins',
            ),
          ),
          const SizedBox(height: 16),
          _buildEliteMetaRow(
            Icons.phone,
            'TELEFONE PRINCIPAL',
            company['phone'].toString(),
          ),
          const SizedBox(height: 14),
          _buildEliteMetaRow(
            Icons.access_time,
            'HORÁRIO DE ATENDIMENTO',
            company['hours'].toString(),
          ),
          const SizedBox(height: 18),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: _launchPhone,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.gold,
                foregroundColor: AppColors.deepBlack,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(2),
                ),
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              icon: const Icon(Icons.call, size: 18),
              label: const Text(
                'Ligar Agora',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Poppins',
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Center(
            child: TextButton.icon(
              onPressed: _launchWhatsApp,
              icon: const Icon(Icons.chat_bubble_outline, size: 16),
              label: const Text('WhatsApp'),
              style: TextButton.styleFrom(
                foregroundColor: AppColors.gold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEliteMetaRow(IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 2),
          child: Icon(
            icon,
            color: AppColors.gold,
            size: 18,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  color: AppColors.lightGray.withOpacity(0.7),
                  fontSize: 9,
                  letterSpacing: 0.8,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Poppins',
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: const TextStyle(
                  color: AppColors.softWhite,
                  fontSize: 15,
                  fontFamily: 'Poppins',
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildEliteMapCard(BuildContext context) {
    return Container(
      height: 146,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFF2C3A30),
            const Color(0xFF3D5244),
            AppColors.graphiteGray,
          ],
        ),
        border: Border.all(
          color: AppColors.gold.withOpacity(0.40),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.gold.withOpacity(0.08),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned.fill(
            child: Opacity(
              opacity: 0.18,
              child: Icon(
                Icons.map_rounded,
                size: 120,
                color: AppColors.softWhite.withOpacity(0.8),
              ),
            ),
          ),
          Center(
            child: OutlinedButton.icon(
              onPressed: () => _openInAppMap(context),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: AppColors.gold),
                foregroundColor: AppColors.gold,
                backgroundColor: AppColors.deepBlack.withOpacity(0.18),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              icon: const Icon(Icons.map_outlined, size: 16),
              label: const Text(
                'Ver no Mapa',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  fontFamily: 'Poppins',
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppBottomNavigation(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.deepBlack,
        border: Border(
          top: BorderSide(
            color: AppColors.gold.withOpacity(0.3),
          ),
        ),
      ),
      child: BottomNavigationBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        type: BottomNavigationBarType.fixed,
        currentIndex: 0,
        selectedItemColor: AppColors.gold,
        unselectedItemColor: AppColors.lightGray,
        onTap: (index) => _onNavTap(context, index),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'INÍCIO',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'BUSCAR',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.map_outlined),
            label: 'MAPA',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'PERFIL',
          ),
        ],
      ),
    );
  }

  void _onNavTap(BuildContext context, int index) {
    HapticFeedback.lightImpact();
    if (index == 0) {
      Navigator.pushReplacementNamed(context, '/home');
    } else if (index == 1) {
      Navigator.pushReplacementNamed(context, '/search');
    } else if (index == 2) {
      Navigator.pushReplacementNamed(context, '/map');
    } else if (index == 3) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const CitizenProfileScreen(),
        ),
      );
    }
  }

  Future<void> _launchPhone() async {
    final Uri phoneUri = Uri(
      scheme: 'tel',
      path: company['phone'].toString().replaceAll(RegExp(r'\D'), ''),
    );

    if (await canLaunchUrl(phoneUri)) {
      await launchUrl(phoneUri);
    }
  }

  Future<void> _launchWhatsApp() async {
    final Uri whatsappUri = Uri(
      scheme: 'https',
      host: 'wa.me',
      path: '55${company['phone'].toString().replaceAll(RegExp(r'\D'), '')}',
    );

    if (await canLaunchUrl(whatsappUri)) {
      await launchUrl(whatsappUri);
    }
  }

  void _openInAppMap(BuildContext context) {
    HapticFeedback.lightImpact();
    Navigator.pushNamed(context, '/map');
  }
}
