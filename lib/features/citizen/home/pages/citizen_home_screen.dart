import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../core/theme/app_theme.dart';
import '../../../../../core/widgets/global_zoom_fab.dart';
import '../../../../../core/services/profile_service.dart';
import 'company_details_screen.dart';
import '../../profile/pages/citizen_profile_screen.dart';
import '../../../../../features/products/presentation/pages/carrinho_screen.dart';
import '../../../../../features/products/presentation/providers/carrinho_provider.dart';

class CitizenHomeScreen extends ConsumerStatefulWidget {
  const CitizenHomeScreen({super.key});

  @override
  ConsumerState<CitizenHomeScreen> createState() => _CitizenHomeScreenState();
}

class _CitizenHomeScreenState extends ConsumerState<CitizenHomeScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedCategory = 'Todos';
  bool _hasShownWelcomeSnackBar = false;
  String? _snackBarMessage;
  Timer? _snackBarTimer;
  
  final List<String> _categories = [
    'Todos',
    'Serviços Funerários',
    'Velório e Cerimônia',
    'Flores e Homenagens',
    'Cemitério e Sepultamento',
    // 'Documentação',
    'Documentação e Burocracia',
    'Apoio à Família',
    // 'Família',
    // 'Transporte',
    'Transporte Funerário',
    // 'Pós-Falecimento',
    'Serviços Pós-Falecimento',
    // 'Manutenção',
    'Manutenção de Túmulos',
    // 'Memorial',
    'Memorial Digital',
    'Memoriais e Lápides',
    // 'Planejamento',
    'Planejamento Antecipado',
    'Buffet para Velório e Cerimônias',
    'Assistência Social',
    'Serviços Funerários para Pets 🐾',
  ];

  final Map<String, String> _categoryToBaseCategory = {
    'Serviços Funerários': 'Serviços Funerários',
    'Velório e Cerimônia': 'Velório e Cerimônia',
    'Flores e Homenagens': 'Flores e Homenagens',
    'Cemitério e Sepultamento': 'Cemitério e Sepultamento',
    'Documentação': 'Serviços Funerários',
    'Documentação e Burocracia': 'Serviços Funerários',
    'Apoio à Família': 'Velório e Cerimônia',
    'Família': 'Velório e Cerimônia',
    'Transporte': 'Serviços Funerários',
    'Transporte Funerário': 'Serviços Funerários',
    'Pós-Falecimento': 'Cemitério e Sepultamento',
    'Serviços Pós-Falecimento': 'Cemitério e Sepultamento',
    'Manutenção': 'Cemitério e Sepultamento',
    'Manutenção de Túmulos': 'Cemitério e Sepultamento',
    'Memorial': 'Cemitério e Sepultamento',
    'Memorial Digital': 'Cemitério e Sepultamento',
    'Memoriais e Lápides': 'Cemitério e Sepultamento',
    'Planejamento': 'Serviços Funerários',
    'Planejamento Antecipado': 'Serviços Funerários',
    'Buffet para Velório e Cerimônias': 'Velório e Cerimônia',
    'Assistência Social': 'Velório e Cerimônia',
    'Serviços Funerários para Pets 🐾': 'Serviços Funerários para Pets 🐾',
  };

  // Dados mock de empresas - substituir com dados reais do Supabase
  final List<Map<String, dynamic>> _companies = [
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
    },
  ];

  List<Map<String, dynamic>> get _filteredCompanies {
    var filtered = _companies.where((company) {
      final matchesSearch = company['name'].toString().toLowerCase().contains(_searchController.text.toLowerCase());
      final selectedBaseCategory = _categoryToBaseCategory[_selectedCategory] ?? _selectedCategory;
      final matchesCategory = _selectedCategory == 'Todos' || company['category'] == selectedBaseCategory;
      return matchesSearch && matchesCategory;
    }).toList();
    
    return filtered;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_hasShownWelcomeSnackBar) return;
    _hasShownWelcomeSnackBar = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showSnackBarMessage('Bem-vindo ao VIRAR! Explore os serviços disponíveis.');
    });
  }

  void _showSnackBarMessage(String message) {
    if (!mounted) return;

    _snackBarTimer?.cancel();
    setState(() {
      _snackBarMessage = message;
    });

    _snackBarTimer = Timer(const Duration(seconds: 6), () {
      if (!mounted) return;
      setState(() {
        _snackBarMessage = null;
      });
    });
  }

  @override
  void dispose() {
    _snackBarTimer?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: const GlobalZoomFAB(),
      body: Stack(
        children: [
          Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xFF1A1614),
                Color(0xFF2D2420),
              ],
            ),
          ),
          child: SafeArea(
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          const Text(
                            'VIRAR',
                            style: TextStyle(
                              color: AppColors.gold,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Poppins',
                              letterSpacing: 2,
                            ),
                          ),
                          const Spacer(),
                          // Ícone do carrinho
                          Consumer(
                            builder: (context, ref, child) {
                              final carrinhoCount = ref.watch(carrinhoCountProvider);
                              
                              return GestureDetector(
                                onTap: () {
                                  HapticFeedback.lightImpact();
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const CarrinhoScreen(),
                                    ),
                                  );
                                },
                                child: Stack(
                                  children: [
                                    Container(
                                      width: 40,
                                      height: 40,
                                      decoration: BoxDecoration(
                                        color: AppColors.gold.withOpacity(0.2),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: const Icon(
                                        Icons.shopping_cart_outlined,
                                        color: AppColors.gold,
                                      ),
                                    ),
                                    if (carrinhoCount > 0)
                                      Positioned(
                                        right: 0,
                                        top: 0,
                                        child: Container(
                                          padding: const EdgeInsets.all(4),
                                          decoration: const BoxDecoration(
                                            color: Colors.red,
                                            shape: BoxShape.circle,
                                          ),
                                          constraints: const BoxConstraints(
                                            minWidth: 18,
                                            minHeight: 18,
                                          ),
                                          child: Text(
                                            carrinhoCount > 99 ? '99+' : carrinhoCount.toString(),
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 10,
                                              fontWeight: FontWeight.bold,
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                              );
                            },
                          ),
                          const SizedBox(width: 12),
                          GestureDetector(
                            onTap: _navigateToProfile,
                            child: Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: AppColors.gold.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Icon(
                                Icons.person_outline,
                                color: AppColors.gold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      Column(
                        children: [
                          const Text(
                            'Bem-vindo, Cidadão!',
                            style: TextStyle(
                              color: AppColors.softWhite,
                              fontSize: 24,
                              fontWeight: FontWeight.w600,
                              fontFamily: 'Poppins',
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Encontre os melhores serviços funerários',
                            style: TextStyle(
                              color: AppColors.lightGray.withOpacity(0.8),
                              fontSize: 16,
                              fontFamily: 'Poppins',
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 24),
                  child: TextField(
                    controller: _searchController,
                    onChanged: (value) => setState(() {}),
                    style: const TextStyle(
                      color: AppColors.softWhite,
                      fontFamily: 'Poppins',
                    ),
                    decoration: InputDecoration(
                      hintText: 'Buscar empresas...',
                      hintStyle: TextStyle(
                        color: AppColors.lightGray.withOpacity(0.6),
                        fontFamily: 'Poppins',
                      ),
                      prefixIcon: const Icon(
                        Icons.search,
                        color: AppColors.gold,
                      ),
                      filled: true,
                      fillColor: AppColors.darkBrown.withOpacity(0.6),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  height: 50,
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: _categories.length,
                    itemBuilder: (context, index) {
                      final category = _categories[index];
                      final isSelected = category == _selectedCategory;

                      return GestureDetector(
                        onTap: () => setState(() => _selectedCategory = category),
                        child: Container(
                          margin: const EdgeInsets.only(right: 12),
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                          decoration: BoxDecoration(
                            color: isSelected ? AppColors.gold : AppColors.darkBrown.withOpacity(0.6),
                            borderRadius: BorderRadius.circular(25),
                          ),
                          child: Text(
                            category,
                            style: TextStyle(
                              color: isSelected ? const Color(0xFF1A1614) : AppColors.softWhite,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              fontFamily: 'Poppins',
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: _filteredCompanies.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.search_off,
                                color: AppColors.lightGray.withOpacity(0.6),
                                size: 48,
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'Nenhuma empresa encontrada',
                                style: TextStyle(
                                  color: AppColors.lightGray.withOpacity(0.8),
                                  fontSize: 16,
                                  fontFamily: 'Poppins',
                                ),
                              ),
                            ],
                          ),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          itemCount: _filteredCompanies.length,
                          itemBuilder: (context, index) {
                            final company = _filteredCompanies[index];
                            return _buildCompanyCard(company);
                          },
                        ),
                ),
              ],
            ),
          ),
        ),
          if (_snackBarMessage != null)
            Positioned(
              left: 16,
              right: 16,
              bottom: 16,
              child: Material(
                color: Colors.transparent,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  decoration: BoxDecoration(
                    color: AppColors.gold,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.25),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          _snackBarMessage!,
                          style: const TextStyle(
                            color: Color(0xFF1A1614),
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'Poppins',
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildCompanyCard(Map<String, dynamic> company) {
    return GestureDetector(
      onTap: () => _navigateToCompanyDetails(company),
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
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
            // Company Image
            Container(
              height: 120,
              decoration: BoxDecoration(
                color: AppColors.gold.withOpacity(0.1),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
                image: company['image'].toString().startsWith('http')
                    ? DecorationImage(
                        image: NetworkImage(company['image']),
                        fit: BoxFit.cover,
                        onError: (error, stackTrace) {},
                      )
                    : null,
              ),
              child: Stack(
                children: [
                  if (!company['image'].toString().startsWith('http'))
                    Center(
                      child: Icon(
                        Icons.business,
                        color: AppColors.gold.withOpacity(0.4),
                        size: 48,
                      ),
                    ),
                  if (company['is24h'] == true)
                    Positioned(
                      top: 12,
                      right: 12,
                      child: Container(
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
                    ),
                ],
              ),
            ),
          
            // Company Info
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          company['name'],
                          style: const TextStyle(
                            color: AppColors.softWhite,
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'Poppins',
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.gold.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          company['category'],
                          style: const TextStyle(
                            color: AppColors.gold,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'Poppins',
                          ),
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 8),
                  
                  Text(
                    company['description'],
                    style: TextStyle(
                      color: AppColors.lightGray.withOpacity(0.8),
                      fontSize: 14,
                      fontFamily: 'Poppins',
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  
                  const SizedBox(height: 12),
                  
                  Row(
                    children: [
                      // Rating
                      Row(
                        children: [
                          const Icon(
                            Icons.star,
                            color: AppColors.gold,
                            size: 16,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            company['rating'].toString(),
                            style: const TextStyle(
                              color: AppColors.softWhite,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              fontFamily: 'Poppins',
                            ),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '(${company['reviews']})',
                            style: TextStyle(
                              color: AppColors.lightGray.withOpacity(0.8),
                              fontSize: 12,
                              fontFamily: 'Poppins',
                            ),
                          ),
                        ],
                      ),
                      
                      const Spacer(),
                      
                      // Phone
                      Row(
                        children: [
                          Icon(
                            Icons.phone,
                            color: AppColors.gold.withOpacity(0.8),
                            size: 16,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            company['phone'],
                            style: TextStyle(
                              color: AppColors.lightGray.withOpacity(0.8),
                              fontSize: 12,
                              fontFamily: 'Poppins',
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 12),
                  
                  // Action Buttons
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => _showCompanyDetails(company),
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: AppColors.gold),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text(
                            'Ver Detalhes',
                            style: TextStyle(
                              color: AppColors.gold,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              fontFamily: 'Poppins',
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () => _contactCompany(company),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.gold,
                            foregroundColor: const Color(0xFF1A1614),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text(
                            'Contatar',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              fontFamily: 'Poppins',
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showProfileMenu(BuildContext parentContext) {
    showModalBottomSheet(
      context: parentContext,
      backgroundColor: AppColors.darkBrown,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.gold.withOpacity(0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            
            const SizedBox(height: 24),
            
            const Text(
              'Menu Cidadão',
              style: TextStyle(
                color: AppColors.softWhite,
                fontSize: 20,
                fontWeight: FontWeight.w600,
                fontFamily: 'Poppins',
              ),
            ),
            
            const SizedBox(height: 24),
            
            ListTile(
              leading: const Icon(Icons.person_outline, color: AppColors.gold),
              title: const Text(
                'Meu Perfil',
                style: TextStyle(
                  color: AppColors.softWhite,
                  fontFamily: 'Poppins',
                ),
              ),
              onTap: () {
                Navigator.pop(context);
                Navigator.of(parentContext).push(
                  MaterialPageRoute(
                    builder: (context) => const CitizenProfileScreen(),
                  ),
                );
              },
            ),
            
            ListTile(
              leading: const Icon(Icons.history, color: AppColors.gold),
              title: const Text(
                'Histórico',
                style: TextStyle(
                  color: AppColors.softWhite,
                  fontFamily: 'Poppins',
                ),
              ),
              onTap: () {
                Navigator.pop(context);
                // TODO: Navigate to history
              },
            ),
            
            ListTile(
              leading: const Icon(Icons.settings, color: AppColors.gold),
              title: const Text(
                'Configurações',
                style: TextStyle(
                  color: AppColors.softWhite,
                  fontFamily: 'Poppins',
                ),
              ),
              onTap: () {
                Navigator.pop(context);
                // TODO: Navigate to settings
              },
            ),
            
            const SizedBox(height: 16),
            
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: const Text(
                'Sair',
                style: TextStyle(
                  color: Colors.red,
                  fontFamily: 'Poppins',
                ),
              ),
              onTap: () async {
                Navigator.pop(context);
                await ProfileService().clearProfileType();
                // TODO: Sign out from AuthProvider
                Navigator.pushReplacementNamed(parentContext, '/profile-selection');
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showCompanyDetails(Map<String, dynamic> company) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.darkBrown,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        maxChildSize: 0.9,
        minChildSize: 0.5,
        builder: (context, scrollController) => Container(
          padding: const EdgeInsets.all(24),
          child: SingleChildScrollView(
            controller: scrollController,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Handle
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: AppColors.gold.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                
                const SizedBox(height: 24),
                
                // Company Name
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
                
                // Category and Rating
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: AppColors.gold.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
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
                    const SizedBox(width: 12),
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
                
                // Contact Info
                _buildInfoRow(Icons.phone, company['phone']),
                _buildInfoRow(Icons.location_on, company['address']),
                
                const SizedBox(height: 24),
                
                // Description
                const Text(
                  'Sobre a empresa',
                  style: TextStyle(
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
                    color: AppColors.lightGray.withOpacity(0.8),
                    fontSize: 16,
                    fontFamily: 'Poppins',
                    height: 1.5,
                  ),
                ),
                
                const SizedBox(height: 32),
                
                // Action Buttons
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          Navigator.pop(context);
                          _contactCompany(company);
                        },
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: AppColors.gold),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          'Ligar Agora',
                          style: TextStyle(
                            color: AppColors.gold,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'Poppins',
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                          // TODO: Navigate to booking/scheduling
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
                          'Agendar',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'Poppins',
                          ),
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
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(
            icon,
            color: AppColors.gold,
            size: 20,
          ),
          const SizedBox(width: 12),
          Text(
            text,
            style: TextStyle(
              color: AppColors.lightGray.withOpacity(0.8),
              fontSize: 16,
              fontFamily: 'Poppins',
            ),
          ),
        ],
      ),
    );
  }

  void _contactCompany(Map<String, dynamic> company) {
    _showSnackBarMessage('Ligando para ${company['phone']}...');
  }

  void _navigateToCompanyDetails(Map<String, dynamic> company) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CompanyDetailsScreen(company: company),
      ),
    );
  }

  void _navigateToProfile() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CitizenProfileScreen(),
      ),
    );
  }
}
