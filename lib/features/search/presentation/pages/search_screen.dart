import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../../../core/localization/app_localizations.dart';
import '../../../../../core/theme/app_theme.dart';
import '../../../citizen/home/pages/company_details_screen.dart';
import '../../../citizen/profile/pages/citizen_profile_screen.dart';
import '../../../home/presentation/pages/map_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key, this.initialCategory});

  final String? initialCategory;

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _eliteGlowController;
  final TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;
  String? _selectedCategory;


  void _onNavTap(int index) {
    HapticFeedback.lightImpact();
    if (index == 0) {
      Navigator.pushReplacementNamed(context, '/home');
    } else if (index == 2) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const MapScreen(),
        ),
      );
    } else if (index == 3) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const CitizenProfileScreen(),
        ),
      );
    }
  }

  List<Map<String, dynamic>> get _allCompanies => [
    {
      'id': '1',
      'name': 'Memorial Funerária São Paulo',
      'category': 'Serviços Funerários',
      'rating': 4.9,
      'reviews': 342,
      'phone': '(11) 3456-7890',
      'address': 'Rua da Consolação, 1234 - Consolação, São Paulo - SP',
      'image': 'https://images.unsplash.com/photo-1516321497487-e288fb19713f?auto=format&fit=crop&w=1600&q=80',
      'is24h': true,
      'description': 'Há mais de 50 anos oferecendo cuidado e respeito nas horas mais difíceis. Serviços completos de funeral, cremação e velório com estrutura moderna e atendimento humanizado.',
      'website': 'www.memorialsp.com.br',
      'services': ['Funeral Completo', 'Cremação', 'Velório', 'Capela', 'Tanatopraxia'],
      'hours': 'Aberto 24 horas',
      'email': 'contato@memorialsp.com.br',
      'tags': ['ATENDIMENTO 24H', 'TRANSLADO'],
    },
    {
      'id': '2',
      'name': 'Jardim da Paz Crematório',
      'brandName': 'Heritage Grand',
      'category': 'Cemitério e Sepultamento',
      'rating': 4.8,
      'reviews': 289,
      'phone': '(11) 2345-6789',
      'address': 'Avenida Professor Francisco Morato, 3456 - Vila Nova Cachoeirinha, São Paulo - SP',
      'addressShort': 'Av. da Paz, 1000  Centro',
      'image': 'https://images.unsplash.com/photo-1549488344-1f9b8d2bd1f3?auto=format&fit=crop&w=1600&q=80',
      'is24h': false,
      'description': 'Crematório moderno com tecnologia avançada e ambiente tranquilo. Oferecemos serviços de cremação com dignidade e respeito, além de memorial para cinzas.',
      'eliteDescription': 'O Jardim da Paz Crematório oferece um ambiente sereno e respeitoso para homenagear seus entes queridos. Com instalações modernas e rodeado por uma natureza tranquila, proporcionamos um espaço de paz para reflexão e despedidas memoráveis. Nossa equipe dedicada está pronta para oferecer suporte compassivo em todos os momentos.',
      'website': 'www.jardimdapazcrematorio.com.br',
      'services': ['Cremação', 'Memorial de Cinzas', 'Cerimônia', 'Jardim Memorial'],
      'hours': 'Seg-Sex: 8h-18h, Sáb: 8h-12h',
      'email': 'atendimento@jardimdapazcrematorio.com.br',
      'tags': ['CREMAÇÃO', 'CERIMÔNIA'],
      'detailLayout': 'elite',
      'eliteFeatures': [
        {'icon': Icons.volunteer_activism_outlined, 'label': 'Jardins Serenos'},
        {'icon': Icons.weekend_outlined, 'label': 'Salas de Velório'},
        {'icon': Icons.local_parking_outlined, 'label': 'Estacionamento'},
        {'icon': Icons.restaurant_outlined, 'label': 'Cafeteria 24h'},
        {'icon': Icons.shield_outlined, 'label': 'Segurança 24h'},
        {'icon': Icons.accessible_forward_outlined, 'label': 'Acessibilidade'},
      ],
    },
    {
      'id': '3',
      'name': 'Luz Eterna Assistência Funeral',
      'category': 'Velório e Cerimônia',
      'rating': 4.7,
      'reviews': 198,
      'phone': '(11) 4002-8922',
      'address': 'Rua Vergueiro, 987 - Vila Mariana, São Paulo - SP',
      'image': 'https://images.unsplash.com/photo-1506744038136-46273834b3fb?auto=format&fit=crop&w=1600&q=80',
      'is24h': true,
      'description': 'Atendimento completo para velórios e cerimônias com suporte familiar, estrutura acolhedora e organização personalizada.',
      'website': 'www.luzeterna.com.br',
      'services': ['Velório', 'Cerimônia', 'Translado', 'Documentação'],
      'hours': 'Aberto 24 horas',
      'email': 'contato@luzeterna.com.br',
      'tags': ['PARCELAMENTO', 'SUPORTE FAMILIAR'],
    },
    {
      'id': '4',
      'name': 'Flores da Saudade',
      'category': 'Flores e Homenagens',
      'rating': 4.8,
      'reviews': 154,
      'phone': '(11) 3333-4455',
      'address': 'Rua das Flores, 450 - Moema, São Paulo - SP',
      'image': 'https://images.unsplash.com/photo-1468327768560-75b778cbb551?auto=format&fit=crop&w=1600&q=80',
      'is24h': false,
      'description': 'Coroas, arranjos e homenagens florais personalizadas com entrega rápida para velórios e cerimônias.',
      'website': 'www.floresdasaudade.com.br',
      'services': ['Coroas de Flores', 'Arranjos', 'Faixas de Homenagem', 'Entrega Expressa'],
      'hours': 'Seg-Dom: 7h-22h',
      'email': 'contato@floresdasaudade.com.br',
      'tags': ['FLORES', 'ENTREGA RÁPIDA'],
    },
    {
      'id': '5',
      'name': 'Amigo Fiel Memorial Pet',
      'category': 'Serviços Funerários para Pets 🐾',
      'rating': 4.9,
      'reviews': 121,
      'phone': '(11) 98888-7766',
      'address': 'Avenida dos Animais, 1200 - Santana, São Paulo - SP',
      'image': 'https://images.unsplash.com/photo-1517849845537-4d257902454a?auto=format&fit=crop&w=1600&q=80',
      'is24h': true,
      'description': 'Serviços funerários humanizados para pets, com cremação individual, cerimônias de despedida e suporte às famílias.',
      'website': 'www.amigofielpet.com.br',
      'services': ['Cremação Pet', 'Cerimônia de Despedida', 'Urnas', 'Translado Veterinário'],
      'hours': 'Aberto 24 horas',
      'email': 'acolhimento@amigofielpet.com.br',
      'tags': ['PET', 'CREMAÇÃO'],
    },
  ];

  List<Map<String, dynamic>> get _filteredCompanies {
    return _allCompanies.where((company) {
      final query = _searchController.text.toLowerCase();
      final matchesSearch = query.isEmpty ||
          company['name'].toString().toLowerCase().contains(query) ||
          company['address'].toString().toLowerCase().contains(query) ||
          company['category'].toString().toLowerCase().contains(query) ||
          company['services'].toString().toLowerCase().contains(query);
      final matchesCategory =
          _selectedCategory == null || company['category'] == _selectedCategory;
      return matchesSearch && matchesCategory;
    }).toList();
  }

  @override
  void initState() {
    super.initState();
    _selectedCategory = widget.initialCategory;
    _eliteGlowController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat();
  }

  @override
  void dispose() {
    _eliteGlowController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final strings = context.t;

    return Scaffold(
      backgroundColor: AppColors.deepBlack,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            _buildHeader(context),
            
            // Search Section
            _buildSearchSection(strings),
            
            // Results Section
            Expanded(
              child: _buildResultsSection(context, strings),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Semantics(
        label: 'Barra de navegação inferior',
        child: Container(
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
            currentIndex: 1,
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
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Semantics(
      label: 'Cabeçalho da tela de busca',
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Back Button
            Semantics(
              button: true,
              label: 'Voltar',
              hint: 'Toque para voltar para a tela anterior',
              onTap: () {
                HapticFeedback.lightImpact();
                Navigator.pop(context);
              },
              child: GestureDetector(
                onTap: () {
                  HapticFeedback.lightImpact();
                  Navigator.pop(context);
                },
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: AppColors.graphiteGray,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: AppColors.gold.withOpacity(0.3)),
                  ),
                  child: Semantics(
                    label: 'Ícone de voltar',
                    child: const Icon(
                      Icons.arrow_back,
                      color: AppColors.gold,
                      size: 20,
                    ),
                  ),
                ),
              ),
            ),
            
            // Logo
            Semantics(
              label: 'Logo VIRAR',
              header: true,
              child: Row(
                children: [
                  ExcludeSemantics(
                    child: Container(
                      width: 4,
                      height: 24,
                      decoration: BoxDecoration(
                        color: AppColors.gold,
                        borderRadius: BorderRadius.all(Radius.circular(2)),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  ExcludeSemantics(
                    child: Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: AppColors.gold,
                        borderRadius: BorderRadius.all(Radius.circular(16)),
                      ),
                      child: const Icon(
                        Icons.local_florist,
                        color: AppColors.deepBlack,
                        size: 18,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'VIRAR',
                    style: TextStyle(
                      color: AppColors.gold,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Poppins',
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 40, height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchSection(AppLocalizations strings) {
    return Semantics(
      label: 'Seção de busca',
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Pesquisar funerária',
              style: TextStyle(
                color: AppColors.softWhite,
                fontSize: 22,
                fontWeight: FontWeight.bold,
                fontFamily: 'Poppins',
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Busque por nome, endereço ou serviço',
              style: TextStyle(
                color: AppColors.lightGold,
                fontSize: 14,
                fontFamily: 'Poppins',
              ),
            ),
            const SizedBox(height: 16),
            // Search Bar
            Semantics(
              textField: true,
              label: 'Campo de busca de funerárias',
              hint: 'Digite para buscar por nome, endereço ou serviço',
              value: _searchController.text.isEmpty ? 'Vazio' : _searchController.text,
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.graphiteGray,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.gold.withOpacity(0.3)),
                ),
                child: TextField(
                  controller: _searchController,
                  onChanged: (_) => setState(() {}),
                  onSubmitted: (_) => setState(() => _isSearching = true),
                  style: const TextStyle(
                    color: AppColors.lightGold,
                    fontFamily: 'Poppins',
                  ),
                  decoration: InputDecoration(
                    hintText: strings.text('search_city_neighborhood'),
                    hintStyle: TextStyle(
                      color: AppColors.lightGold.withOpacity(0.6),
                      fontFamily: 'Poppins',
                    ),
                    prefixIcon: Semantics(
                      label: 'Ícone de lupa',
                      child: const Icon(
                        Icons.search,
                        color: AppColors.lightGold,
                      ),
                    ),
                    suffixIcon: _searchController.text.isNotEmpty
                        ? Semantics(
                          button: true,
                          label: 'Limpar busca',
                          hint: 'Toque para limpar o texto da busca',
                          onTap: () {
                            HapticFeedback.lightImpact();
                            _searchController.clear();
                            setState(() {
                              _isSearching = false;
                            });
                          },
                          child: GestureDetector(
                            onTap: () {
                              HapticFeedback.lightImpact();
                              _searchController.clear();
                              setState(() {
                                _isSearching = false;
                              });
                            },
                            child: const Icon(
                              Icons.clear,
                              color: AppColors.lightGold,
                            ),
                          ),
                        )
                        : null,
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 16,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResultsSection(BuildContext context, AppLocalizations strings) {
    final results = _filteredCompanies;

    if (results.isEmpty) {
      return Semantics(
        label: 'Nenhuma funerária encontrada',
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: AppColors.graphiteGray,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.gold.withOpacity(0.2)),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Semantics(
                  label: 'Ícone de busca sem resultados',
                  child: Icon(
                    Icons.search_off,
                    size: 48,
                    color: AppColors.gold.withOpacity(0.6),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  strings.text('no_companies_found_category'),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColors.softWhite,
                    fontSize: 16,
                    fontFamily: 'Poppins',
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Tente usar outro nome ou serviço',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColors.lightGold.withOpacity(0.8),
                    fontSize: 14,
                    fontFamily: 'Poppins',
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Semantics(
      label: 'Resultados da busca, ${results.length} empresas encontradas',
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Semantics(
              liveRegion: true,
              label: '${results.length} empresas encontradas',
              child: Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: Text(
                  '${results.length} empresas encontradas',
                  style: TextStyle(
                    color: AppColors.lightGold,
                    fontSize: 14,
                    fontFamily: 'Poppins',
                  ),
                ),
              ),
            ),
            Expanded(
              child: ListView.separated(
                itemCount: results.length,
                separatorBuilder: (context, index) => const SizedBox(height: 16),
                itemBuilder: (context, index) {
                  final company = results[index];
                  return _buildCompanyCard(context, company, index + 1);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentSearches(AppLocalizations strings) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Buscas recentes',
            style: TextStyle(
              color: AppColors.softWhite,
              fontSize: 18,
              fontWeight: FontWeight.bold,
              fontFamily: 'Poppins',
            ),
          ),
          const SizedBox(height: 16),
          // Recent searches placeholder
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: AppColors.graphiteGray,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.gold.withOpacity(0.2)),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.history,
                  size: 48,
                  color: AppColors.gold.withOpacity(0.6),
                ),
                const SizedBox(height: 16),
                Text(
                  'Nenhuma busca recente',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColors.softWhite,
                    fontSize: 16,
                    fontFamily: 'Poppins',
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Suas buscas aparecerão aqui',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColors.lightGold.withOpacity(0.8),
                    fontSize: 14,
                    fontFamily: 'Poppins',
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCompanyCard(BuildContext context, Map<String, dynamic> company, int index) {
    final bool isElite = company['detailLayout'] == 'elite';
    final String eliteLabel = isElite ? ', plano Elite' : '';
    final String ratingLabel = company['rating'].toString();
    final String reviewsLabel = company['reviews'].toString();

    final Widget cardContent = Container(
      decoration: BoxDecoration(
        color: AppColors.graphiteGray,
        borderRadius: BorderRadius.circular(16),
        border: isElite ? null : Border.all(color: AppColors.gold.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            child: SizedBox(
              width: double.infinity,
              height: 160,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Semantics(
                    label: 'Foto de ${company['name']}',
                    image: true,
                    child: CachedNetworkImage(
                      imageUrl: company['image'],
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Semantics(
                        label: 'Carregando imagem',
                        child: Container(
                          color: AppColors.gold.withOpacity(0.12),
                          child: Center(
                            child: CircularProgressIndicator(
                              color: AppColors.gold.withOpacity(0.8),
                            ),
                          ),
                        ),
                      ),
                      errorWidget: (context, url, error) => Semantics(
                        label: 'Imagem não disponível',
                        child: Container(
                          color: AppColors.gold.withOpacity(0.12),
                          child: Center(
                            child: Icon(
                              Icons.business,
                              size: 48,
                              color: AppColors.gold.withOpacity(0.6),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  if (isElite)
                    Positioned.fill(
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              const Color(0xFFEBB249).withOpacity(0.25),
                            ],
                          ),
                        ),
                      ),
                    ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Semantics(
                      label: 'Avaliação $ratingLabel de 5 estrelas, $reviewsLabel avaliações',
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.gold,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Semantics(
                              label: 'Estrela',
                              child: const Icon(
                                Icons.star,
                                color: AppColors.gold,
                                size: 16,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              company['rating'].toString(),
                              style: const TextStyle(
                                color: AppColors.deepBlack,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Poppins',
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  if (isElite)
                    Positioned(
                      top: 8,
                      left: 8,
                      child: Semantics(
                        label: 'Badge Elite',
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [
                                Color(0xFFEBB249),
                                Color(0xFFF5D98A),
                                Color(0xFFEBB249),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(8),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.gold.withOpacity(0.5),
                                blurRadius: 8,
                                spreadRadius: 1,
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Semantics(
                                label: 'Troféu',
                                child: const Icon(
                                  Icons.workspace_premium,
                                  color: AppColors.gold,
                                  size: 16,
                                ),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                'ELITE',
                                style: const TextStyle(
                                  color: AppColors.deepBlack,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w900,
                                  fontFamily: 'Poppins',
                                  letterSpacing: 1.5,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  company['name'],
                  style: TextStyle(
                    color: isElite ? AppColors.gold : AppColors.softWhite,
                    fontSize: isElite ? 19 : 18,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Poppins',
                  ),
                ),
                if (isElite) ...[
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Semantics(
                        label: 'Verificado',
                        child: Icon(
                          Icons.verified,
                          color: AppColors.gold,
                          size: 16,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'Empresa verificada • Plano Elite',
                        style: TextStyle(
                          color: AppColors.lightGold,
                          fontSize: 12,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );

    Widget finalCard = cardContent;

    if (isElite) {
      finalCard = AnimatedBuilder(
        animation: _eliteGlowController,
        builder: (context, child) {
          final double glowValue = _eliteGlowController.value;
          return Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              boxShadow: [
                BoxShadow(
                  color: AppColors.gold.withOpacity(0.25 + 0.25 * sin(glowValue * 2 * pi)),
                  blurRadius: 16 + 8 * sin(glowValue * 2 * pi).abs(),
                  spreadRadius: 1 + 2 * sin(glowValue * 2 * pi).abs(),
                ),
              ],
            ),
            child: CustomPaint(
              painter: _EliteShimmerBorderPainter(
                progress: glowValue,
                borderRadius: 16,
                strokeWidth: 2.5,
              ),
              child: child,
            ),
          );
        },
        child: cardContent,
      );
    }

    return Semantics(
      button: true,
      label: '${company['name']}, ${company['category']}$eliteLabel. Avaliação $ratingLabel de 5 estrelas, $reviewsLabel avaliações. Toque para ver detalhes.',
      hint: 'Card de funerária, toque para acessar informações completas',
      onTap: () {
        HapticFeedback.mediumImpact();
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CompanyDetailsScreen(company: company),
          ),
        );
      },
      child: GestureDetector(
        onTap: () {
          HapticFeedback.mediumImpact();
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CompanyDetailsScreen(company: company),
            ),
          );
        },
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: isElite ? 6 : 0),
          child: finalCard,
        ),
      ),
    );
  }
}

class _EliteShimmerBorderPainter extends CustomPainter {
  final double progress;
  final double borderRadius;
  final double strokeWidth;

  _EliteShimmerBorderPainter({
    required this.progress,
    required this.borderRadius,
    required this.strokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final rrect = RRect.fromRectAndRadius(
      rect.deflate(strokeWidth / 2),
      Radius.circular(borderRadius),
    );

    // Animated sweep gradient that rotates around the border
    final sweepShader = SweepGradient(
      startAngle: 0,
      endAngle: 2 * pi,
      transform: GradientRotation(progress * 2 * pi),
      colors: const [
        Color(0xFFEBB249),
        Color(0xFFF5D98A),
        Color(0xFFFFFFFF),
        Color(0xFFF5D98A),
        Color(0xFFEBB249),
        Color(0xFFD4983D),
        Color(0xFFEBB249),
      ],
      stops: const [0.0, 0.15, 0.3, 0.45, 0.6, 0.8, 1.0],
    ).createShader(rect);

    final paint = Paint()
      ..shader = sweepShader
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;

    canvas.drawRRect(rrect, paint);
  }

  @override
  bool shouldRepaint(covariant _EliteShimmerBorderPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
