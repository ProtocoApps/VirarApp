import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../../core/theme/app_theme.dart';
import '../../../../../core/widgets/global_zoom_fab.dart';
import '../../../../../core/services/profile_service.dart';

class EntrepreneurHomeScreen extends StatefulWidget {
  const EntrepreneurHomeScreen({super.key});

  @override
  State<EntrepreneurHomeScreen> createState() => _EntrepreneurHomeScreenState();
}

class _EntrepreneurHomeScreenState extends State<EntrepreneurHomeScreen> {
  // Dados mock - substituir com dados reais do Supabase
  final Map<String, dynamic> _companyData = {
    'name': 'Funerária Paz Eterna',
    'cnpj': '12.345.678/0001-90',
    'responsible': 'João Silva',
    'phone': '(11) 3456-7890',
    'email': 'contato@pazeterna.com.br',
    'address': 'Rua das Flores, 123 - São Paulo, SP',
    'status': 'ativo',
    'rating': 4.8,
    'totalReviews': 234,
    'monthlyRevenue': 125000.00,
    'activeServices': 156,
    'pendingRequests': 12,
  };

  final List<Map<String, dynamic>> _recentServices = [
    {
      'id': '1',
      'client': 'Maria Santos',
      'service': 'Funeral Completo',
      'date': '15/03/2026',
      'status': 'concluído',
      'value': 8500.00,
    },
    {
      'id': '2',
      'client': 'José Oliveira',
      'service': 'Velório',
      'date': '16/03/2026',
      'status': 'em_andamento',
      'value': 3200.00,
    },
    {
      'id': '3',
      'client': 'Ana Costa',
      'service': 'Cremação',
      'date': '17/03/2026',
      'status': 'agendado',
      'value': 4500.00,
    },
  ];

  final List<Map<String, dynamic>> _services = [
    {
      'id': '1',
      'name': 'Funeral Completo',
      'description': 'Serviço completo de funeral',
      'price': 8500.00,
      'active': true,
      'requests': 45,
    },
    {
      'id': '2',
      'name': 'Velório',
      'description': 'Espaço para velório',
      'price': 3200.00,
      'active': true,
      'requests': 32,
    },
    {
      'id': '3',
      'name': 'Cremação',
      'description': 'Serviço de cremação',
      'price': 4500.00,
      'active': true,
      'requests': 28,
    },
    {
      'id': '4',
      'name': 'Transporte',
      'description': 'Transporte fúnebre',
      'price': 800.00,
      'active': false,
      'requests': 15,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: const GlobalZoomFAB(),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              const Color(0xFF1A1614),
              const Color(0xFF2D2420),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header
              Container(
                padding: const EdgeInsets.all(24),
                child: Row(
                  children: [
                    // Menu Button
                    GestureDetector(
                      onTap: () => _showProfileMenu(context),
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: AppColors.gold.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(
                          Icons.menu,
                          color: AppColors.gold,
                        ),
                      ),
                    ),
                    
                    const Spacer(),
                    
                    // Logo
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
                    
                    // Notifications
                    GestureDetector(
                      onTap: () => _showNotifications(context),
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: AppColors.gold.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Stack(
                          children: [
                            const Icon(
                              Icons.notifications_outlined,
                              color: AppColors.gold,
                            ),
                            if (_companyData['pendingRequests'] > 0)
                              Positioned(
                                top: 2,
                                right: 2,
                                child: Container(
                                  width: 8,
                                  height: 8,
                                  decoration: const BoxDecoration(
                                    color: Colors.red,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              
              // Company Info Card
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 24),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.darkBrown.withOpacity(0.6),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: AppColors.gold.withOpacity(0.3),
                    width: 1,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _companyData['name'],
                                style: const TextStyle(
                                  color: AppColors.softWhite,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Poppins',
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'CNPJ: ${_companyData['cnpj']}',
                                style: TextStyle(
                                  color: AppColors.lightGray.withOpacity(0.8),
                                  fontSize: 14,
                                  fontFamily: 'Poppins',
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.green,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Text(
                            'ATIVO',
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
                    
                    const SizedBox(height: 16),
                    
                    Row(
                      children: [
                        _buildStatCard('Avaliação', '${_companyData['rating']}', Icons.star),
                        const SizedBox(width: 12),
                        _buildStatCard('Serviços', '${_companyData['activeServices']}', Icons.work),
                        const SizedBox(width: 12),
                        _buildStatCard('Pendentes', '${_companyData['pendingRequests']}', Icons.pending),
                      ],
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 16),
              
              // Quick Actions
              Container(
                height: 100,
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Row(
                  children: [
                    Expanded(
                      child: _buildQuickAction(
                        'Novo Serviço',
                        Icons.add_circle_outline,
                        () => _addNewService(),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildQuickAction(
                        'Ver Pedidos',
                        Icons.list_alt,
                        () => _viewRequests(),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildQuickAction(
                        'Relatórios',
                        Icons.bar_chart,
                        () => _viewReports(),
                      ),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 16),
              
              // Tabs
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () => setState(() {}),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            color: AppColors.gold,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Text(
                            'Serviços',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Color(0xFF1A1614),
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              fontFamily: 'Poppins',
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: GestureDetector(
                        onTap: () => setState(() {}),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            color: AppColors.darkBrown.withOpacity(0.6),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            'Recentes',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: AppColors.lightGray.withOpacity(0.8),
                              fontSize: 14,
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
              
              const SizedBox(height: 16),
              
              // Services List
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  itemCount: _services.length,
                  itemBuilder: (context, index) {
                    final service = _services[index];
                    return _buildServiceCard(service);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard(String label, String value, IconData icon) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.gold.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: AppColors.gold,
              size: 20,
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: const TextStyle(
                color: AppColors.softWhite,
                fontSize: 16,
                fontWeight: FontWeight.bold,
                fontFamily: 'Poppins',
              ),
            ),
            Text(
              label,
              style: TextStyle(
                color: AppColors.lightGray.withOpacity(0.8),
                fontSize: 12,
                fontFamily: 'Poppins',
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickAction(String label, IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.darkBrown.withOpacity(0.6),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: AppColors.gold.withOpacity(0.2),
            width: 1,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: AppColors.gold,
              size: 24,
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: const TextStyle(
                color: AppColors.softWhite,
                fontSize: 12,
                fontWeight: FontWeight.w600,
                fontFamily: 'Poppins',
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildServiceCard(Map<String, dynamic> service) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      service['name'],
                      style: const TextStyle(
                        color: AppColors.softWhite,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Poppins',
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      service['description'],
                      style: TextStyle(
                        color: AppColors.lightGray.withOpacity(0.8),
                        fontSize: 14,
                        fontFamily: 'Poppins',
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: service['active'] ? Colors.green : Colors.red,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  service['active'] ? 'Ativo' : 'Inativo',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Poppins',
                  ),
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 12),
          
          Row(
            children: [
              Text(
                'R\$ ${service['price'].toStringAsFixed(2)}',
                style: const TextStyle(
                  color: AppColors.gold,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Poppins',
                ),
              ),
              const Spacer(),
              Text(
                '${service['requests']} solicitações',
                style: TextStyle(
                  color: AppColors.lightGray.withOpacity(0.8),
                  fontSize: 14,
                  fontFamily: 'Poppins',
                ),
              ),
              const SizedBox(width: 12),
              GestureDetector(
                onTap: () => _editService(service),
                child: const Icon(
                  Icons.edit,
                  color: AppColors.gold,
                  size: 20,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showProfileMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
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
              'Menu Empresarial',
              style: TextStyle(
                color: AppColors.softWhite,
                fontSize: 20,
                fontWeight: FontWeight.w600,
                fontFamily: 'Poppins',
              ),
            ),
            
            const SizedBox(height: 24),
            
            ListTile(
              leading: const Icon(Icons.business, color: AppColors.gold),
              title: const Text(
                'Dados da Empresa',
                style: TextStyle(
                  color: AppColors.softWhite,
                  fontFamily: 'Poppins',
                ),
              ),
              onTap: () {
                Navigator.pop(context);
                _editCompanyInfo();
              },
            ),
            
            ListTile(
              leading: const Icon(Icons.work, color: AppColors.gold),
              title: const Text(
                'Gerenciar Serviços',
                style: TextStyle(
                  color: AppColors.softWhite,
                  fontFamily: 'Poppins',
                ),
              ),
              onTap: () {
                Navigator.pop(context);
                _manageServices();
              },
            ),
            
            ListTile(
              leading: const Icon(Icons.bar_chart, color: AppColors.gold),
              title: const Text(
                'Relatórios',
                style: TextStyle(
                  color: AppColors.softWhite,
                  fontFamily: 'Poppins',
                ),
              ),
              onTap: () {
                Navigator.pop(context);
                _viewReports();
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
                _showSettings();
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
                Navigator.pushReplacementNamed(context, '/profile-selection');
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showNotifications(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Você tem ${_companyData['pendingRequests']} solicitações pendentes'),
        backgroundColor: AppColors.gold,
      ),
    );
  }

  void _addNewService() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Adicionando novo serviço...'),
        backgroundColor: AppColors.gold,
      ),
    );
  }

  void _viewRequests() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Visualizando solicitações...'),
        backgroundColor: AppColors.gold,
      ),
    );
  }

  void _viewReports() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Gerando relatórios...'),
        backgroundColor: AppColors.gold,
      ),
    );
  }

  void _editService(Map<String, dynamic> service) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Editando serviço: ${service['name']}'),
        backgroundColor: AppColors.gold,
      ),
    );
  }

  void _editCompanyInfo() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Editando informações da empresa...'),
        backgroundColor: AppColors.gold,
      ),
    );
  }

  void _manageServices() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Gerenciando serviços...'),
        backgroundColor: AppColors.gold,
      ),
    );
  }

  void _showSettings() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Abrindo configurações...'),
        backgroundColor: AppColors.gold,
      ),
    );
  }
}
