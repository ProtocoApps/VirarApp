import 'package:flutter/material.dart';
import 'package:provider/provider.dart' as provider;
import '../../../../../core/providers/text_scale_provider.dart';
import 'package:video_player/video_player.dart';
import '../../../../../core/theme/app_theme.dart';
import '../../../../../core/widgets/global_zoom_fab.dart';
import '../../../../../core/localization/app_language.dart';
import '../../../../../core/providers/app_language_provider.dart';
import '../../../search/presentation/pages/search_screen.dart';

class AccessibilityHomeScreen extends StatelessWidget {
  const AccessibilityHomeScreen({super.key, this.showBottomNavigation = true});

  final bool showBottomNavigation;

  static const List<_ServiceItem> _services = [
   _ServiceItem(Icons.local_hospital_outlined, 'Serviços\nFunerários', 'Funeral\nServices', 'Servicios\nFunerarios', 'Serviços Funerários', 'assets/images/Serviço funerária. Oficial.gif'),
    _ServiceItem(Icons.inventory_2_outlined, 'Velório', 'Wake', 'Velorio', 'Velório e Cerimônia', 'assets/images/2.Velório e cerimônia.gif'),
    _ServiceItem(Icons.local_florist_outlined, 'Flores e\nHomenagens', 'Flowers', 'Flores', 'Flores e Homenagens', 'assets/images/3.Flores e homenagens.gif'),
    _ServiceItem(Icons.church_outlined, 'Cemitério', 'Cemetery', 'Cementerio', 'Cemitério e Sepultamento', 'assets/images/4.Cemitério e sepultamento.gif'),
    // _ServiceItem(Icons.description_outlined, 'Documentação', 'Documents', 'Documentación', 'Serviços Funerários', 'assets/images/6.Documentação e burocracia.gif'),
    _ServiceItem(Icons.folder_open_outlined, 'Documentação\ne Burocracia', 'Docs &\nBureaucracy', 'Docs y\nBurocracia', 'Serviços Funerários', 'assets/images/6.Documentação e burocracia.gif'),
    _ServiceItem(Icons.favorite_border, 'Apoio à\nFamília', 'Family\nSupport', 'Apoyo a\nFamilia', 'Velório e Cerimônia', 'assets/images/5.Apoio à família.gif'),
    // _ServiceItem(Icons.groups_outlined, 'Família', 'Family', 'Familia', 'Velório e Cerimônia', 'assets/images/5.Apoio à família.gif'),
    // _ServiceItem(Icons.airport_shuttle_outlined, 'Transporte', 'Transport', 'Transporte', 'Serviços Funerários', 'assets/images/9.Transporte funerário.gif'),
    _ServiceItem(Icons.local_shipping_outlined, 'Transporte\nFunerário', 'Funeral\nTransport', 'Transporte\nFunerario', 'Serviços Funerários', 'assets/images/9.Transporte funerário.gif'),
    // _ServiceItem(Icons.spa_outlined, 'Pós-\nFalecimento', 'Post-\nPassage', 'Post-\nFallecimiento', 'Cemitério e Sepultamento', 'assets/images/7.Serviços pós-falecimento.gif'),
    _ServiceItem(Icons.history_toggle_off_outlined, 'Serviços Pós-\nFalecimento', 'Post-Death\nServices', 'Servicios Post-\nFallecimiento', 'Cemitério e Sepultamento', 'assets/images/7.Serviços pós-falecimento.gif'),
    // _ServiceItem(Icons.build_outlined, 'Manutenção', 'Maintenance', 'Mantenimiento', 'Cemitério e Sepultamento', 'assets/images/8.Manutenção de túmulos.gif'),
    _ServiceItem(Icons.handyman_outlined, 'Manutenção\nde Túmulos', 'Grave\nMaintenance', 'Mantenimiento\nde Tumbas', 'Cemitério e Sepultamento', 'assets/images/8.Manutenção de túmulos.gif'),
    // _ServiceItem(Icons.auto_stories_outlined, 'Memorial', 'Memorial', 'Memorial', 'Cemitério e Sepultamento', 'assets/images/12.Memorial digital.gif'),
    _ServiceItem(Icons.memory_outlined, 'Memorial\nDigital', 'Digital\nMemorial', 'Memorial\nDigital', 'Cemitério e Sepultamento', 'assets/images/12.Memorial digital.gif'),
    _ServiceItem(Icons.account_balance_outlined, 'Memoriais\ne Lápides', 'Memorials\nand Headstones', 'Memoriales\ny Lápidas', 'Cemitério e Sepultamento', 'assets/images/13.Memoriais e lápides.gif'),
    // _ServiceItem(Icons.event_note_outlined, 'Planejamento', 'Planning', 'Planificación', 'Serviços Funerários', 'assets/images/14.Planejamento antecipado.gif'),
    _ServiceItem(Icons.event_available_outlined, 'Planejamento\nAntecipado', 'Advance\nPlanning', 'Planificación\nAnticipada', 'Serviços Funerários', 'assets/images/14.Planejamento antecipado.gif'),
    _ServiceItem(Icons.restaurant_outlined, 'Buffet para\nVelório', 'Buffet for\nWake', 'Buffet para\nVelorio', 'Velório e Cerimônia', 'assets/images/10.Buffet para Velório e Cerimônias.gif'),
    _ServiceItem(Icons.volunteer_activism_outlined, 'Assistência\nSocial', 'Social\nSupport', 'Asistencia\nSocial', 'Velório e Cerimônia', 'assets/images/11.Assistência social.gif'),
    _ServiceItem(Icons.pets_outlined, 'Serviços\nFunerários\npara Pets', 'Pet Funeral\nServices', 'Servicios Funerarios\npara Mascotas', 'Serviços Funerários', 'assets/images/Serviço funerária Pets Oficial.gif'),
  ];

  String _label(_ServiceItem item, AppLanguage lang) {
    switch (lang) {
      case AppLanguage.english:
        return item.en;
      case AppLanguage.spanish:
        return item.es;
      default:
        return item.pt;
    }
  }

  @override
  Widget build(BuildContext context) {
    final lang = provider.Provider.of<AppLanguageProvider>(context).currentLanguage;

    return Scaffold(
      backgroundColor: AppColors.deepBlack,
      floatingActionButton: const GlobalZoomFAB(),
      body: Stack(
        children: [
          // Background image with overlay
          Container(
            decoration: const BoxDecoration(
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

          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 20),

                  // ── Header ──────────────────────────────────────────────
                  _buildHeader(context, lang),

                  const SizedBox(height: 28),

                  // ── "Experiência Exclusiva" label ────────────────────────
                  _buildSectionLabel(lang),

                  const SizedBox(height: 20),

                  // ── Services grid ────────────────────────────────────────
                  _buildServicesGrid(lang),

                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: showBottomNavigation ? _buildBottomNavigation() : null,
    );
  }

  Widget _buildBottomNavigation() {
    return Semantics(
      label: 'Barra de navegação inferior',
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.deepBlack,
          border: Border(
            top: BorderSide(color: AppColors.gold.withOpacity(0.3)),
          ),
        ),
        child: SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _BottomNavItem(icon: Icons.map_outlined, label: 'Mapa'),
                _BottomNavItem(icon: Icons.person, label: 'Perfil'),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ── HEADER ────────────────────────────────────────────────────────────────
  Widget _buildHeader(BuildContext context, AppLanguage lang) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(height: 22),

        // Gold divider glow line top
        SizedBox(
          width: 220,
          child: Container(
            height: 1.5,
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [
                Colors.transparent,
                AppColors.gold.withOpacity(0.7),
                Colors.transparent,
              ]),
            ),
          ),
        ),

        const SizedBox(height: 18),

        // App name
        const Text(
          'VIRAR',
          style: TextStyle(
            color: AppColors.gold,
            fontSize: 32,
            fontWeight: FontWeight.bold,
            fontFamily: 'Poppins',
            letterSpacing: 4,
          ),
        ),

        const SizedBox(height: 6),

        Text(
          lang == AppLanguage.english
              ? 'Atendimento com acolhimento e cuidado'
              : lang == AppLanguage.spanish
                  ? 'Atendimento com acolhimento e cuidado'
                  : 'Atendimento com acolhimento e cuidado',
          style: TextStyle(
            color: AppColors.softWhite.withOpacity(0.80),
            fontSize: 12,
            fontFamily: 'Poppins',
            height: 1.5,
          ),
          textAlign: TextAlign.center,
        ),

        const SizedBox(height: 18),

        // Gold divider glow line bottom
        SizedBox(
          width: 220,
          child: Container(
            height: 1.5,
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [
                Colors.transparent,
                AppColors.gold.withOpacity(0.7),
                Colors.transparent,
              ]),
            ),
          ),
        ),
      ],
    );
  }

  // ── SECTION LABEL ─────────────────────────────────────────────────────────
  Widget _buildSectionLabel(AppLanguage lang) {
    final label = lang == AppLanguage.english
        ? 'Exclusive Experience'
        : lang == AppLanguage.spanish
            ? 'Experiencia Exclusiva'
            : 'Experiência Exclusiva';

    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(
            color: AppColors.softWhite,
            fontSize: 20,
            fontWeight: FontWeight.w600,
            fontFamily: 'Poppins',
            letterSpacing: 0.4,
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          width: 120,
          child: Divider(color: AppColors.gold.withOpacity(0.5), thickness: 1.2),
        ),
      ],
    );
  }

  // ── SERVICES GRID ─────────────────────────────────────────────────────────
  Widget _buildServicesGrid(AppLanguage lang) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        crossAxisSpacing: 10,
        mainAxisSpacing: 16,
        childAspectRatio: 0.64,
      ),
      itemCount: _services.length,
      itemBuilder: (context, index) {
        final item = _services[index];
        return _ServiceTile(
          icon: item.icon,
          label: _label(item, lang),
          onTap: () => _openCategoryResults(context, item),
          onGifTap: () => _showCategoryGif(context, item, lang),
        );
      },
    );
  }

  void _openCategoryResults(BuildContext context, _ServiceItem item) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => SearchScreen(initialCategory: item.searchCategory),
      ),
    );
  }

  void _showCategoryGif(BuildContext context, _ServiceItem item, AppLanguage lang) {
    final title = _label(item, lang).replaceAll('\n', ' ');
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
                        '$title em Libras',
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
                  child: item.gifAssetPath.endsWith('.mp4')
                      ? _VideoPlayerWidget(videoPath: item.gifAssetPath)
                      : Image.asset(item.gifAssetPath, fit: BoxFit.contain),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

}

// ── SERVICE TILE ─────────────────────────────────────────────────────────────
class _ServiceTile extends StatelessWidget {
  const _ServiceTile({
    required this.icon,
    required this.label,
    required this.onTap,
    required this.onGifTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final VoidCallback onGifTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFF3B2B10), Color(0xFF221913)],
                  ),
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(
                    color: AppColors.gold.withOpacity(0.60),
                    width: 1.5,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.gold.withOpacity(0.18),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Center(
                  child: Icon(
                    icon,
                    color: AppColors.gold,
                    size: 28,
                  ),
                ),
              ),
              Positioned(
                right: -6,
                top: -6,
                child: Semantics(
                  button: true,
                  label: 'Abrir explicação em Libras para $label',
                  hint: 'Toque para ver o GIF da categoria em Libras',
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: onGifTap,
                      borderRadius: BorderRadius.circular(16),
                      child: Ink(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: AppColors.deepBlack.withOpacity(0.88),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: AppColors.gold.withOpacity(0.45),
                            width: 1,
                          ),
                        ),
                        child: const Center(
                          child: Icon(
                            Icons.sign_language,
                            color: AppColors.gold,
                            size: 18,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 7),
          Text(
            label,
            style: TextStyle(
              color: AppColors.softWhite,
              fontSize: 11,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w500,
              height: 1.3,
            ),
            textAlign: TextAlign.center,
            maxLines: 3,
          ),
        ],
      ),
    );
  }
}

class _BottomNavItem extends StatelessWidget {
  const _BottomNavItem({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: label,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: AppColors.lightGray),
            const SizedBox(height: 4),
            Text(
              label,
              style: const TextStyle(
                color: AppColors.lightGray,
                fontSize: 12,
                fontFamily: 'Poppins',
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── VIDEO PLAYER WIDGET ────────────────────────────────────────────────────────
class _VideoPlayerWidget extends StatefulWidget {
  const _VideoPlayerWidget({required this.videoPath});

  final String videoPath;

  @override
  State<_VideoPlayerWidget> createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<_VideoPlayerWidget> {
  late VideoPlayerController _controller;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset(widget.videoPath)
      ..initialize().then((_) {
        if (mounted) {
          setState(() {
            _isInitialized = true;
          });
          _controller.play();
          _controller.setLooping(true);
        }
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isInitialized) {
      return const SizedBox(
        height: 200,
        child: Center(
          child: CircularProgressIndicator(color: AppColors.gold),
        ),
      );
    }
    return AspectRatio(
      aspectRatio: _controller.value.aspectRatio,
      child: VideoPlayer(_controller),
    );
  }
}

// ── DATA MODEL ────────────────────────────────────────────────────────────────
class _ServiceItem {
  const _ServiceItem(this.icon, this.pt, this.en, this.es, this.searchCategory, this.gifAssetPath);

  final IconData icon;
  final String pt;
  final String en;
  final String es;
  final String searchCategory;
  final String gifAssetPath;
}
