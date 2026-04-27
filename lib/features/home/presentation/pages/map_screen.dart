import 'dart:async';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../../core/localization/app_localizations.dart';
import '../../../../../core/services/supabase_service.dart';
import '../../../../../core/theme/app_theme.dart';
import '../../../citizen/home/pages/company_details_screen.dart';
import '../../../citizen/profile/pages/citizen_profile_screen.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  GoogleMapController? _mapController;
  BitmapDescriptor? _brownMarkerIcon;
  bool _isLoading = true;
  String? _errorMessage;
  List<Map<String, dynamic>> _companies = [];

  static const CameraPosition _initialPosition = CameraPosition(
    target: LatLng(-15.793889, -47.882778),
    zoom: 12.9,
  );

  static const String _mapStyle = '''
[
  {
    "featureType": "poi",
    "stylers": [
      {"saturation": -100},
      {"lightness": 55}
    ]
  },
  {
    "featureType": "poi",
    "elementType": "labels.icon",
    "stylers": [
      {"saturation": -100},
      {"lightness": 70}
    ]
  },
  {
    "featureType": "poi",
    "elementType": "labels.text.fill",
    "stylers": [
      {"color": "#9e9e9e"}
    ]
  },
  {
    "featureType": "poi",
    "elementType": "labels.text.stroke",
    "stylers": [
      {"color": "#f5f5f5"}
    ]
  },
  {
    "featureType": "transit",
    "stylers": [
      {"saturation": -100},
      {"lightness": 65}
    ]
  },
  {
    "featureType": "road.local",
    "elementType": "labels.text.fill",
    "stylers": [
      {"color": "#9c9c9c"}
    ]
  },
  {
    "featureType": "administrative.neighborhood",
    "elementType": "labels.text.fill",
    "stylers": [
      {"color": "#8f8f8f"}
    ]
  }
]
''';

  Set<Marker> get _markers {
    return _companies.map((company) {
      return Marker(
        markerId: MarkerId(company['id'].toString()),
        position: LatLng(company['latitude'] as double, company['longitude'] as double),
        infoWindow: InfoWindow(
          title: company['name'].toString(),
          snippet: '${company['category']}. Toque para ver detalhes.',
        ),
        icon: _brownMarkerIcon ?? BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange),
        onTap: () => _showCompanyDetails(company),
      );
    }).toSet();
  }

  Future<void> _zoomIn() async {
    if (_mapController == null) {
      return;
    }

    await _mapController!.animateCamera(CameraUpdate.zoomIn());
  }

  Future<void> _zoomOut() async {
    if (_mapController == null) {
      return;
    }

    await _mapController!.animateCamera(CameraUpdate.zoomOut());
  }

  void _onNavTap(int index) {
    HapticFeedback.lightImpact();
    if (index == 0) {
      Navigator.pushReplacementNamed(context, '/home');
    } else if (index == 1) {
      Navigator.pushNamed(context, '/search');
    } else if (index == 3) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const CitizenProfileScreen(),
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    unawaited(_loadBrownMarkerIcon());
    unawaited(_loadCompanies());
  }

  Future<void> _loadCompanies() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final response = await SupabaseService()
          .client
          .from('funerarias')
          .select('id, nome, descricao, telefone, email, site, rua_avenida, numero, bairro, cidade, estado, dias_semana, horario_abertura, horario_fechamento, servicos, imagem, latitude, longitude')
          .not('latitude', 'is', null)
          .not('longitude', 'is', null)
          .order('nome');

      final companies = (response as List<dynamic>)
          .map((item) => _mapDatabaseFuneralHome(item as Map<String, dynamic>))
          .where((item) => item['latitude'] != null && item['longitude'] != null)
          .toList();

      if (!mounted) {
        return;
      }

      setState(() {
        _companies = companies;
        _isLoading = false;
      });
    } on PostgrestException catch (e) {
      if (!mounted) {
        return;
      }

      setState(() {
        _errorMessage = e.message;
        _isLoading = false;
      });
    } catch (_) {
      if (!mounted) {
        return;
      }

      setState(() {
        _errorMessage = 'Não foi possível carregar as funerárias no mapa.';
        _isLoading = false;
      });
    }
  }

  Map<String, dynamic> _mapDatabaseFuneralHome(Map<String, dynamic> row) {
    final street = row['rua_avenida']?.toString().trim() ?? '';
    final number = row['numero']?.toString().trim() ?? '';
    final neighborhood = row['bairro']?.toString().trim() ?? '';
    final city = row['cidade']?.toString().trim() ?? '';
    final state = row['estado']?.toString().trim() ?? '';
    final phone = row['telefone']?.toString().trim();
    final email = row['email']?.toString().trim();
    final site = row['site']?.toString().trim();
    final opening = row['horario_abertura']?.toString();
    final closing = row['horario_fechamento']?.toString();
    final days = row['dias_semana']?.toString().trim();
    final services = (row['servicos'] as List<dynamic>?)?.map((item) => item.toString()).toList() ?? <String>[];
    final hours = _formatHours(opening, closing);
    final is24h = (opening?.startsWith('00:00') ?? false) &&
        ((closing?.startsWith('23:59') ?? false) || (closing?.startsWith('23:58') ?? false));

    final addressParts = [
      if (street.isNotEmpty) street,
      if (number.isNotEmpty) number,
      if (neighborhood.isNotEmpty) neighborhood,
      if (city.isNotEmpty) city,
      if (state.isNotEmpty) state,
    ];

    return {
      'id': row['id'],
      'name': row['nome']?.toString() ?? 'Funerária',
      'category': 'Serviços Funerários',
      'description': row['descricao']?.toString() ?? 'Sem descrição disponível.',
      'phone': phone ?? 'Não informado',
      'email': (email != null && email.isNotEmpty) ? email : 'contato@funeraria.com.br',
      'site': site,
      'website': (site != null && site.isNotEmpty) ? site : 'www.funeraria.com.br',
      'address': addressParts.isEmpty ? 'Endereço não informado' : addressParts.join(' - '),
      'days': days,
      'hours': hours,
      'services': services,
      'image': row['imagem']?.toString() ?? '',
      'rating': 4.8,
      'reviews': 0,
      'is24h': is24h,
      'latitude': _toDouble(row['latitude']),
      'longitude': _toDouble(row['longitude']),
    };
  }

  double? _toDouble(dynamic value) {
    if (value is double) {
      return value;
    }
    if (value is int) {
      return value.toDouble();
    }
    return double.tryParse(value?.toString() ?? '');
  }

  String _formatHours(String? opening, String? closing) {
    final open = opening == null || opening.isEmpty ? null : opening.substring(0, 5);
    final close = closing == null || closing.isEmpty ? null : closing.substring(0, 5);
    if (open == null && close == null) {
      return 'Horário não informado';
    }
    if (open != null && close != null) {
      return '$open às $close';
    }
    return open ?? close ?? 'Horário não informado';
  }

  void _showCompanyDetails(Map<String, dynamic> company) {
    HapticFeedback.mediumImpact();
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: AppColors.graphiteGray,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        final services = (company['services'] as List<dynamic>?) ?? const [];

        return Semantics(
          label: 'Detalhes de ${company['name']}',
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ExcludeSemantics(
                    child: Center(
                      child: Container(
                        width: 42,
                        height: 4,
                        decoration: BoxDecoration(
                          color: AppColors.gold.withValues(alpha: 0.45),
                          borderRadius: BorderRadius.circular(999),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 18),
                  Text(
                    company['name'].toString(),
                    style: const TextStyle(
                      color: AppColors.softWhite,
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      fontFamily: 'Poppins',
                    ),
                  ),
                  const SizedBox(height: 10),
                  if ((company['address']?.toString().isNotEmpty ?? false))
                    _buildDetailRow(Icons.location_on_outlined, company['address'].toString()),
                  if ((company['phone']?.toString().isNotEmpty ?? false)) ...[
                    const SizedBox(height: 8),
                    _buildDetailRow(Icons.phone_outlined, company['phone'].toString()),
                  ],
                  if ((company['days']?.toString().isNotEmpty ?? false) || (company['hours']?.toString().isNotEmpty ?? false)) ...[
                    const SizedBox(height: 8),
                    _buildDetailRow(
                      Icons.schedule_outlined,
                      [
                        if (company['days']?.toString().isNotEmpty ?? false) company['days'].toString(),
                        if (company['hours']?.toString().isNotEmpty ?? false) company['hours'].toString(),
                      ].join('  •  '),
                    ),
                  ],
                  const SizedBox(height: 14),
                  Text(
                    company['description'].toString(),
                    style: TextStyle(
                      color: AppColors.softWhite.withValues(alpha: 0.88),
                      fontSize: 14,
                      height: 1.5,
                      fontFamily: 'Poppins',
                    ),
                  ),
                  if (services.isNotEmpty) ...[
                    const SizedBox(height: 18),
                    Semantics(
                      label: 'Serviços oferecidos: ${services.take(4).join(', ')}',
                      child: Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: services.take(4).map((service) {
                          return Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                            decoration: BoxDecoration(
                              color: AppColors.gold.withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: AppColors.gold.withValues(alpha: 0.25)),
                            ),
                            child: Text(
                              service.toString(),
                              style: const TextStyle(
                                color: AppColors.gold,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                fontFamily: 'Poppins',
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                  const SizedBox(height: 22),
                  Semantics(
                    button: true,
                    label: 'Ver mais detalhes',
                    hint: 'Toque para ver informações completas sobre ${company['name']}',
                    onTap: () {
                      HapticFeedback.mediumImpact();
                      Navigator.pop(context);
                      Navigator.push(
                        this.context,
                        MaterialPageRoute(
                          builder: (context) => CompanyDetailsScreen(company: company),
                        ),
                      );
                    },
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          HapticFeedback.mediumImpact();
                          Navigator.pop(context);
                          Navigator.push(
                            this.context,
                            MaterialPageRoute(
                              builder: (context) => CompanyDetailsScreen(company: company),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.gold,
                          foregroundColor: AppColors.deepBlack,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        child: const Text(
                          'Ver mais',
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
            ),
          ),
        );
      },
    );
  }

  Widget _buildDetailRow(IconData icon, String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Semantics(
          label: _getIconLabel(icon),
          child: Icon(icon, color: AppColors.gold, size: 18),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              color: AppColors.softWhite.withValues(alpha: 0.9),
              fontSize: 13,
              fontFamily: 'Poppins',
            ),
          ),
        ),
      ],
    );
  }

  String _getIconLabel(IconData icon) {
    if (icon == Icons.location_on_outlined) return 'Localização';
    if (icon == Icons.phone_outlined) return 'Telefone';
    if (icon == Icons.schedule_outlined) return 'Horário';
    return 'Ícone';
  }

  Future<void> _loadBrownMarkerIcon() async {
    final marker = await _createBrownMarker();
    if (!mounted) {
      return;
    }

    setState(() {
      _brownMarkerIcon = marker;
    });
  }

  Future<BitmapDescriptor> _createBrownMarker() async {
    const double width = 56;
    const double height = 72;
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);
    final pinPaint = Paint()..color = const Color(0xFF5C4033);
    final innerPaint = Paint()..color = AppColors.lightGold;
    final shadowPaint = Paint()..color = Colors.black.withValues(alpha: 0.18);

    canvas.drawShadow(
      Path()
        ..moveTo(width / 2, height)
        ..lineTo(12, 29)
        ..arcToPoint(const Offset(44, 29), radius: const Radius.circular(16), clockwise: false)
        ..close(),
      Colors.black.withValues(alpha: 0.32),
      6,
      false,
    );

    canvas.drawCircle(const Offset(28, 26), 16, shadowPaint);
    canvas.drawCircle(const Offset(28, 24), 16, pinPaint);

    final path = Path()
      ..moveTo(28, 63)
      ..lineTo(14, 33)
      ..quadraticBezierTo(28, 44, 42, 33)
      ..close();
    canvas.drawPath(path, pinPaint);
    canvas.drawCircle(const Offset(28, 24), 6, innerPaint);

    final image = await recorder.endRecording().toImage(width.toInt(), height.toInt());
    final bytes = await image.toByteData(format: ui.ImageByteFormat.png);

    return BitmapDescriptor.bytes(bytes!.buffer.asUint8List());
  }

  @override
  Widget build(BuildContext context) {
    final strings = context.t;

    return Scaffold(
      backgroundColor: AppColors.deepBlack,
      appBar: AppBar(
        backgroundColor: AppColors.deepBlack,
        elevation: 0,
        centerTitle: true,
        title: Semantics(
          header: true,
          label: 'Mapa de Serviços',
          child: const Text(
            'Mapa de Serviços',
            style: TextStyle(
              color: AppColors.gold,
              fontWeight: FontWeight.w600,
              fontFamily: 'Poppins',
            ),
          ),
        ),
        iconTheme: const IconThemeData(color: AppColors.gold),
      ),
      body: Stack(
        children: [
          if (_isLoading)
            Semantics(
              label: 'Carregando mapa',
              child: const Center(
                child: CircularProgressIndicator(color: AppColors.gold),
              ),
            )
          else if (_errorMessage != null)
            Semantics(
              label: 'Erro ao carregar mapa: $_errorMessage',
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Semantics(
                        label: 'Ícone de erro de localização',
                        child: const Icon(Icons.location_off_outlined, color: AppColors.gold, size: 42),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        _errorMessage!,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: AppColors.softWhite,
                          fontSize: 14,
                          fontFamily: 'Poppins',
                        ),
                      ),
                      const SizedBox(height: 16),
                      Semantics(
                        button: true,
                        label: 'Tentar novamente',
                        hint: 'Toque para recarregar as funerárias no mapa',
                        onTap: () {
                          HapticFeedback.lightImpact();
                          _loadCompanies();
                        },
                        child: ElevatedButton(
                          onPressed: () {
                            HapticFeedback.lightImpact();
                            _loadCompanies();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.gold,
                            foregroundColor: AppColors.deepBlack,
                          ),
                          child: const Text('Tentar novamente'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )
          else if (_companies.isEmpty)
            Semantics(
              label: 'Nenhuma funerária com localização foi encontrada',
              child: const Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24),
                  child: Text(
                    'Nenhuma funerária com latitude e longitude foi encontrada.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: AppColors.softWhite,
                      fontSize: 14,
                      fontFamily: 'Poppins',
                    ),
                  ),
                ),
              ),
            )
          else
            Semantics(
              label: 'Mapa interativo com ${_companies.length} funerárias marcadas',
              hint: 'Mapa de funerárias. Toque nos marcadores para ver detalhes.',
              child: GoogleMap(
                initialCameraPosition: _initialPosition,
                style: _mapStyle,
                markers: _markers,
                zoomControlsEnabled: false,
                mapToolbarEnabled: false,
                myLocationButtonEnabled: false,
                compassEnabled: true,
                onMapCreated: (controller) {
                  _mapController = controller;
                },
              ),
            ),
          Positioned(
            top: 16,
            left: 16,
            right: 16,
            child: Semantics(
              label: 'Informação do mapa',
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                decoration: BoxDecoration(
                  color: AppColors.graphiteGray.withValues(alpha: 0.94),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.gold.withValues(alpha: 0.35)),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.deepBlack.withValues(alpha: 0.24),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Semantics(
                      label: 'Ícone de mapa',
                      child: const Icon(Icons.map_outlined, color: AppColors.gold),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Veja funerárias e serviços próximos no mapa.',
                        style: TextStyle(
                          color: AppColors.softWhite.withValues(alpha: 0.92),
                          fontSize: 13,
                          fontFamily: 'Poppins',
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            right: 16,
            bottom: 96,
            child: Column(
              children: [
                Semantics(
                  button: true,
                  label: 'Aumentar zoom do mapa',
                  hint: 'Toque para aproximar o mapa',
                  child: FloatingActionButton(
                    heroTag: 'zoom_in_map',
                    mini: true,
                    backgroundColor: AppColors.gold,
                    foregroundColor: AppColors.deepBlack,
                    onPressed: _companies.isEmpty
                        ? null
                        : () {
                      HapticFeedback.lightImpact();
                      _zoomIn();
                    },
                    child: const Icon(Icons.add),
                  ),
                ),
                const SizedBox(height: 10),
                Semantics(
                  button: true,
                  label: 'Diminuir zoom do mapa',
                  hint: 'Toque para afastar o mapa',
                  child: FloatingActionButton(
                    heroTag: 'zoom_out_map',
                    mini: true,
                    backgroundColor: AppColors.gold,
                    foregroundColor: AppColors.deepBlack,
                    onPressed: _companies.isEmpty
                        ? null
                        : () {
                      HapticFeedback.lightImpact();
                      _zoomOut();
                    },
                    child: const Icon(Icons.remove),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            right: 16,
            bottom: 24,
            child: Semantics(
              button: true,
              label: 'Centralizar mapa',
              hint: 'Toque para voltar à posição inicial do mapa',
              child: FloatingActionButton(
                heroTag: 'center_map',
                backgroundColor: AppColors.gold,
                foregroundColor: AppColors.deepBlack,
                onPressed: _companies.isEmpty
                    ? null
                    : () {
                  HapticFeedback.lightImpact();
                  _mapController?.animateCamera(
                    CameraUpdate.newCameraPosition(_initialPosition),
                  );
                },
                child: Semantics(
                  label: 'Ícone de centralizar',
                  child: const Icon(Icons.center_focus_strong),
                ),
              ),
            ),
          ),
        ],
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
          currentIndex: 2,
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

}
