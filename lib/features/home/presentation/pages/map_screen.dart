import 'dart:async';
import 'dart:convert';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../../core/localization/app_localizations.dart';
import '../../../../../core/services/supabase_service.dart';
import '../../../../../core/services/location_tracking_service.dart';
import '../../../../../core/theme/app_theme.dart';
import '../../../citizen/home/pages/company_details_screen.dart';
import '../../../citizen/profile/pages/citizen_profile_screen.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key, this.showBottomNavigation = true});

  final bool showBottomNavigation;

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  GoogleMapController? _mapController;
  BitmapDescriptor? _brownMarkerIcon;
  BitmapDescriptor? _userMarkerIcon;
  BitmapDescriptor? _trackingMarkerIcon;
  bool _isLoading = true;
  String? _errorMessage;
  List<Map<String, dynamic>> _companies = [];
  
  late LocationTrackingService _locationService;
  LatLng? _userLocation;
  Map<String, dynamic>? _trackedCompany;
  StreamSubscription<dynamic>? _locationSubscription;
  StreamSubscription<LatLng>? _userLocationSubscription;
  Timer? _animationTimer;
  LatLng? _animatedCompanyPosition;
  double _distanceToUser = 0;
  int _estimatedTimeMinutes = 0;
  bool _isSimulating = false;
  Set<Polyline> _polylines = {};
  List<LatLng> _routePoints = [];
  int _currentRouteIndex = 0;
  
  static const String _googleDirectionsApiKey = 'AIzaSyApft_cu8qq9eQ_-QsJ_NxgHlDZuMLAgTA';
  static const String _openRouteServiceApiKey = '5b3ce3597851110001cf6248d9b0e3e8e2f34d8d8b5e8c8f8e8e8e8e'; // Chave pública de exemplo

  static const CameraPosition _initialPosition = CameraPosition(
    target: LatLng(-15.793889, -47.882778),
    zoom: 12.9,
  );

  static const String _mapStyle = '''
[
  {
    "featureType": "poi",
    "stylers": [
      {"visibility": "off"}
    ]
  },
  {
    "featureType": "poi.business",
    "stylers": [
      {"visibility": "off"}
    ]
  },
  {
    "featureType": "poi.park",
    "stylers": [
      {"visibility": "off"}
    ]
  },
  {
    "featureType": "poi.attraction",
    "stylers": [
      {"visibility": "off"}
    ]
  },
  {
    "featureType": "poi.medical",
    "stylers": [
      {"visibility": "off"}
    ]
  },
  {
    "featureType": "poi.place_of_worship",
    "stylers": [
      {"visibility": "off"}
    ]
  },
  {
    "featureType": "poi.school",
    "stylers": [
      {"visibility": "off"}
    ]
  },
  {
    "featureType": "poi.sports_complex",
    "stylers": [
      {"visibility": "off"}
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
    final markers = <Marker>{};
    
    for (final company in _companies) {
      markers.add(Marker(
        markerId: MarkerId(company['id'].toString()),
        position: LatLng(company['latitude'] as double, company['longitude'] as double),
        infoWindow: InfoWindow(
          title: company['name'].toString(),
          snippet: '${company['category']}. Toque para ver detalhes.',
        ),
        icon: _brownMarkerIcon ?? BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange),
        onTap: () => _showCompanyDetails(company),
      ));
    }
    
    if (_userLocation != null) {
      markers.add(Marker(
        markerId: const MarkerId('user_location'),
        position: _userLocation!,
        infoWindow: const InfoWindow(title: 'Sua localização'),
        icon: _userMarkerIcon ?? BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
      ));
    }
    
    if (_animatedCompanyPosition != null && _trackedCompany != null) {
      final distanceText = _distanceToUser >= 1000
          ? '${(_distanceToUser / 1000).toStringAsFixed(1)} km'
          : '${_distanceToUser.toStringAsFixed(0)} m';
      
      final timeText = _estimatedTimeMinutes > 60
          ? '${(_estimatedTimeMinutes / 60).toStringAsFixed(1)}h'
          : '${_estimatedTimeMinutes}min';
      
      markers.add(Marker(
        markerId: const MarkerId('tracking_company'),
        position: _animatedCompanyPosition!,
        infoWindow: InfoWindow(
          title: '${_trackedCompany!['name']} a caminho',
          snippet: '$distanceText • $timeText de distância',
        ),
        icon: _trackingMarkerIcon ?? BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueYellow),
      ));
    }
    
    return markers;
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
      Navigator.pushReplacementNamed(context, '/citizen_home');
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
    _locationService = LocationTrackingService();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    try {
      // Obter localização PRIMEIRO, antes de renderizar o mapa
      final initialLocation = await _locationService.getCurrentLocation();
      if (initialLocation != null && mounted) {
        setState(() {
          _userLocation = initialLocation;
        });
      }

      // Depois carregar os ícones e dados
      unawaited(_loadBrownMarkerIcon());
      unawaited(_loadUserMarkerIcon());
      unawaited(_loadTrackingMarkerIcon());
      unawaited(_loadCompanies());

      // Iniciar rastreamento contínuo
      await _locationService.startLocationTracking();
      _subscribeToUserLocation();
    } catch (e) {
      print('Erro ao inicializar app: $e');
    }
  }

  @override
  void dispose() {
    _locationSubscription?.cancel();
    _userLocationSubscription?.cancel();
    _animationTimer?.cancel();
    _locationService.stopLocationTracking();
    _locationService.dispose();
    super.dispose();
  }

  void _subscribeToUserLocation() {
    _userLocationSubscription = _locationService.userLocationStream.listen((location) {
      setState(() {
        _userLocation = location;
        if (_trackedCompany != null) {
          _updateTrackedCompanyDistance();
        }
      });
    });
  }

  void _updateTrackedCompanyDistance() {
    if (_userLocation != null && _trackedCompany != null) {
      final companyLat = _trackedCompany!['latitude'] as double;
      final companyLng = _trackedCompany!['longitude'] as double;
      final companyLocation = LatLng(companyLat, companyLng);
      
      _distanceToUser = _locationService.calculateDistance(_userLocation!, companyLocation);
      _fetchRealRouteData(companyLocation, _userLocation!);
    }
  }

  Future<void> _fetchRealRouteData(LatLng origin, LatLng destination) async {
    try {
      final String url =
          'https://maps.googleapis.com/maps/api/directions/json?'
          'origin=${origin.latitude},${origin.longitude}&'
          'destination=${destination.latitude},${destination.longitude}&'
          'key=$_googleDirectionsApiKey&'
          'mode=driving&'
          'language=pt-BR';

      final response = await http.get(Uri.parse(url)).timeout(
        const Duration(seconds: 10),
        onTimeout: () => http.Response('Timeout', 408),
      );

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body) as Map<String, dynamic>;
        final routes = json['routes'] as List<dynamic>?;

        if (routes != null && routes.isNotEmpty) {
          final route = routes[0] as Map<String, dynamic>;
          final legs = route['legs'] as List<dynamic>?;

          if (legs != null && legs.isNotEmpty) {
            final leg = legs[0] as Map<String, dynamic>;
            final distance = leg['distance'] as Map<String, dynamic>?;
            final duration = leg['duration'] as Map<String, dynamic>?;

            if (distance != null && duration != null && mounted) {
              final distanceMeters = distance['value'] as int?;
              final durationSeconds = duration['value'] as int?;

              if (distanceMeters != null && durationSeconds != null) {
                setState(() {
                  _distanceToUser = distanceMeters.toDouble();
                  _estimatedTimeMinutes = (durationSeconds / 60).ceil();
                });
              }
            }
          }
        }
      }
    } catch (e) {
      print('Erro ao buscar dados de rota: $e');
    }
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
                  Row(
                    children: [
                      Expanded(
                        child: Semantics(
                          button: true,
                          label: 'Simular rota',
                          hint: 'Toque para simular a funerária vindo até você (teste)',
                          onTap: () {
                            HapticFeedback.mediumImpact();
                            Navigator.pop(context);
                            _startSimulation(company);
                          },
                          child: ElevatedButton(
                            onPressed: () {
                              HapticFeedback.mediumImpact();
                              Navigator.pop(context);
                              _startSimulation(company);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.graphiteGray,
                              foregroundColor: AppColors.gold,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                                side: const BorderSide(color: AppColors.gold, width: 1),
                              ),
                            ),
                            child: const Text(
                              'Simular rota',
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                fontFamily: 'Poppins',
                                fontSize: 15,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Semantics(
                          button: true,
                          label: 'Rastrear funerária',
                          hint: 'Toque para rastrear ${company['name']} em tempo real no mapa',
                          onTap: () {
                            HapticFeedback.mediumImpact();
                            Navigator.pop(context);
                            _startTrackingCompany(company);
                          },
                          child: ElevatedButton(
                            onPressed: () {
                              HapticFeedback.mediumImpact();
                              Navigator.pop(context);
                              _startTrackingCompany(company);
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
                              'Rastrear',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
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
                              backgroundColor: AppColors.graphiteGray,
                              foregroundColor: AppColors.gold,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              elevation: 0,
                              side: const BorderSide(color: AppColors.gold, width: 1.5),
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

  Future<void> _loadUserMarkerIcon() async {
    final marker = await _createUserMarker();
    if (!mounted) {
      return;
    }

    setState(() {
      _userMarkerIcon = marker;
    });
  }

  Future<void> _loadTrackingMarkerIcon() async {
    final marker = await _createTrackingMarker();
    if (!mounted) {
      return;
    }

    setState(() {
      _trackingMarkerIcon = marker;
    });
  }

  void _startTrackingCompany(Map<String, dynamic> company) {
    final currentUser = SupabaseService().currentUser;
    if (currentUser == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Erro: Usuário não autenticado'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      _trackedCompany = company;
      _animatedCompanyPosition = LatLng(
        company['latitude'] as double,
        company['longitude'] as double,
      );
      _isSimulating = false;
    });

    _animationTimer?.cancel();
    
    _locationSubscription?.cancel();
    _locationSubscription = SupabaseService()
        .client
        .from('funeral_home_tracking')
        .stream(primaryKey: ['id'])
        .listen(
          (List<Map<String, dynamic>> data) {
            if (!mounted) return;

            if (data.isEmpty) {
              return;
            }

            final tracking = data.firstWhere(
              (record) => 
                record['funeral_home_id'] == company['id'] && 
                record['user_id'] == currentUser.id,
              orElse: () => <String, dynamic>{},
            );

            if (tracking.isEmpty) {
              return;
            }

            final newLat = (tracking['latitude'] as num).toDouble();
            final newLng = (tracking['longitude'] as num).toDouble();
            final status = tracking['status'] as String?;

            setState(() {
              _animatedCompanyPosition = LatLng(newLat, newLng);
              _updateTrackedCompanyDistance();
            });

            if (_userLocation != null && _animatedCompanyPosition != null) {
              final distance = _locationService.calculateDistance(
                _animatedCompanyPosition!,
                _userLocation!,
              );

              if (distance < 50 || status == 'arrived') {
                _stopTracking();
                _showArrivalNotification();
              }
            }
          },
          onError: (error) {
            print('Erro ao rastrear funerária: $error');
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Erro ao rastrear: $error'),
                  backgroundColor: Colors.red,
                ),
              );
            }
          },
        );

    _showTrackingBottomSheet(company);
  }

  Future<void> _startSimulation(Map<String, dynamic> company) async {
    setState(() {
      _isSimulating = true;
      _trackedCompany = company;
      _animatedCompanyPosition = LatLng(
        company['latitude'] as double,
        company['longitude'] as double,
      );
      _polylines = {};
      _routePoints = [];
      _currentRouteIndex = 0;
      _estimatedTimeMinutes = 0;
    });

    // Obter rota real via Google Directions API
    final origin = LatLng(company['latitude'] as double, company['longitude'] as double);
    
    // Dar zoom e centralizar no caixão (funerária)
    _mapController?.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: origin,
          zoom: 16.0,
          tilt: 45.0,
        ),
      ),
    );
    
    await _fetchRoute(origin, _userLocation!);
    await _fetchRealRouteData(origin, _userLocation!);

    _animationTimer?.cancel();
    _animationTimer = Timer.periodic(const Duration(milliseconds: 500), (timer) {
      if (!mounted || _userLocation == null || _trackedCompany == null) {
        timer.cancel();
        return;
      }

      final distance = _locationService.calculateDistance(
        _animatedCompanyPosition!,
        _userLocation!,
      );

      if (distance < 50) {
        timer.cancel();
        setState(() {
          _trackedCompany = null;
          _animatedCompanyPosition = null;
          _isSimulating = false;
          _polylines = {};
          _routePoints = [];
        });
        _showArrivalNotification();
        return;
      }

      // Mover para o próximo ponto da rota com interpolação suave
      if (_routePoints.isNotEmpty && _currentRouteIndex < _routePoints.length - 1) {
        _currentRouteIndex++;
        final nextPoint = _routePoints[_currentRouteIndex];
        
        setState(() {
          _animatedCompanyPosition = nextPoint;
          _updateTrackedCompanyDistance();
          
          _polylines = {
            Polyline(
              polylineId: const PolylineId('route'),
              points: _routePoints,
              color: AppColors.gold,
              width: 5,
              geodesic: true,
            ),
          };
        });
      }
    });

    _showTrackingBottomSheet(company);
  }

  Future<void> _fetchRoute(LatLng origin, LatLng destination) async {
    try {
      // Usar OSRM (Open Source Routing Machine) - API gratuita sem CORS
      final String url =
          'https://router.project-osrm.org/route/v1/driving/'
          '${origin.longitude},${origin.latitude};'
          '${destination.longitude},${destination.latitude}'
          '?overview=full&geometries=geojson';

      print('Buscando rota real: $url');

      final response = await http.get(Uri.parse(url)).timeout(
        const Duration(seconds: 10),
        onTimeout: () => http.Response('Timeout', 408),
      );

      print('Status da resposta: ${response.statusCode}');

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body) as Map<String, dynamic>;
        final routes = json['routes'] as List<dynamic>?;

        if (routes != null && routes.isNotEmpty) {
          final route = routes[0] as Map<String, dynamic>;
          final geometry = route['geometry'] as Map<String, dynamic>?;
          
          if (geometry != null) {
            final coordinates = geometry['coordinates'] as List<dynamic>?;
            
            if (coordinates != null && coordinates.isNotEmpty) {
              final List<LatLng> routePoints = coordinates.map((coord) {
                final lng = (coord[0] as num).toDouble();
                final lat = (coord[1] as num).toDouble();
                return LatLng(lat, lng);
              }).toList();
              
              print('Rota real obtida com ${routePoints.length} pontos');
              
              if (routePoints.isNotEmpty && mounted) {
                setState(() {
                  _routePoints = routePoints;
                  _currentRouteIndex = 0;
                  _animatedCompanyPosition = routePoints.first;
                });
                return;
              }
            }
          }
        }
      }
      
      print('Usando fallback com curvas');
      // Fallback: usar interpolação com curvas se API falhar
      final List<LatLng> interpolatedRoute = _generateInterpolatedRoute(origin, destination);
      setState(() {
        _routePoints = interpolatedRoute;
        _currentRouteIndex = 0;
        _animatedCompanyPosition = interpolatedRoute.first;
      });
    } catch (e) {
      print('Erro ao buscar rota real: $e');
      // Fallback: usar rota com curvas
      final List<LatLng> interpolatedRoute = _generateInterpolatedRoute(origin, destination);
      setState(() {
        _routePoints = interpolatedRoute;
        _currentRouteIndex = 0;
        _animatedCompanyPosition = interpolatedRoute.first;
      });
    }
  }

  List<LatLng> _generateInterpolatedRoute(LatLng origin, LatLng destination) {
    final List<LatLng> route = [];
    
    // Criar pontos de controle intermediários para simular curvas de ruas
    final double latDiff = destination.latitude - origin.latitude;
    final double lngDiff = destination.longitude - origin.longitude;
    
    // Criar 3 pontos de controle intermediários com desvios perpendiculares
    final controlPoint1 = LatLng(
      origin.latitude + latDiff * 0.25 + lngDiff * 0.15,
      origin.longitude + lngDiff * 0.25 - latDiff * 0.15,
    );
    
    final controlPoint2 = LatLng(
      origin.latitude + latDiff * 0.5 - lngDiff * 0.1,
      origin.longitude + lngDiff * 0.5 + latDiff * 0.1,
    );
    
    final controlPoint3 = LatLng(
      origin.latitude + latDiff * 0.75 + lngDiff * 0.08,
      origin.longitude + lngDiff * 0.75 - latDiff * 0.08,
    );
    
    // Interpolar entre origem e primeiro ponto de controle
    route.addAll(_interpolateBetweenPoints(origin, controlPoint1, 75));
    
    // Interpolar entre pontos de controle
    route.addAll(_interpolateBetweenPoints(controlPoint1, controlPoint2, 75));
    route.addAll(_interpolateBetweenPoints(controlPoint2, controlPoint3, 75));
    
    // Interpolar entre último ponto de controle e destino
    route.addAll(_interpolateBetweenPoints(controlPoint3, destination, 75));
    
    return route;
  }
  
  List<LatLng> _interpolateBetweenPoints(LatLng start, LatLng end, int numPoints) {
    final List<LatLng> points = [];
    
    for (int i = 0; i <= numPoints; i++) {
      final double t = i / numPoints;
      final double lat = start.latitude + (end.latitude - start.latitude) * t;
      final double lng = start.longitude + (end.longitude - start.longitude) * t;
      points.add(LatLng(lat, lng));
    }
    
    return points;
  }

  List<LatLng> _decodePolyline(String encoded) {
    List<LatLng> poly = [];
    int index = 0, len = encoded.length;
    int lat = 0, lng = 0;

    while (index < len) {
      int b, shift = 0, result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlat = ((result & 1) != 0) ? ~(result >> 1) : (result >> 1);
      lat += dlat;

      shift = 0;
      result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlng = ((result & 1) != 0) ? ~(result >> 1) : (result >> 1);
      lng += dlng;

      poly.add(LatLng(lat / 1e5, lng / 1e5));
    }
    return poly;
  }

  void _stopTracking() {
    _animationTimer?.cancel();
    setState(() {
      _trackedCompany = null;
      _animatedCompanyPosition = null;
      _estimatedTimeMinutes = 0;
      _distanceToUser = 0;
    });
  }

  void _showArrivalNotification() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('A funerária chegou ao seu local!'),
        backgroundColor: AppColors.gold,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  void _showTrackingBottomSheet(Map<String, dynamic> company) {
    // Não mostrar modal - apenas atualizar o estado
    // O widget flutuante será mostrado no Stack do build
  }

  Future<BitmapDescriptor> _createBrownMarker() async {
    const double size = 32;
    const double height = 52;
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);
    final pinPaint = Paint()..color = const Color(0xFF5C4033);
    final innerPaint = Paint()..color = AppColors.lightGold;
    final shadowPaint = Paint()..color = Colors.black.withValues(alpha: 0.18);

    canvas.drawShadow(
      Path()
        ..moveTo(size / 2, height)
        ..lineTo(8, 21)
        ..arcToPoint(const Offset(32, 21), radius: const Radius.circular(12), clockwise: false)
        ..close(),
      Colors.black.withValues(alpha: 0.32),
      4,
      false,
    );

    canvas.drawCircle(const Offset(20, 19), 12, shadowPaint);
    canvas.drawCircle(const Offset(20, 18), 12, pinPaint);

    final path = Path()
      ..moveTo(20, 46)
      ..lineTo(10, 24)
      ..quadraticBezierTo(20, 32, 30, 24)
      ..close();
    canvas.drawPath(path, pinPaint);
    canvas.drawCircle(const Offset(20, 18), 4, innerPaint);

    final image = await recorder.endRecording().toImage(size.toInt(), height.toInt());
    final bytes = await image.toByteData(format: ui.ImageByteFormat.png);

    return BitmapDescriptor.bytes(bytes!.buffer.asUint8List());
  }

  Future<BitmapDescriptor> _createUserMarker() async {
    const double size = 32;
    const double height = 52;
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);
    final pinPaint = Paint()..color = const Color(0xFF2196F3);
    final innerPaint = Paint()..color = Colors.white;
    final shadowPaint = Paint()..color = Colors.black.withValues(alpha: 0.18);

    canvas.drawShadow(
      Path()
        ..moveTo(size / 2, height)
        ..lineTo(8, 21)
        ..arcToPoint(const Offset(32, 21), radius: const Radius.circular(12), clockwise: false)
        ..close(),
      Colors.black.withValues(alpha: 0.32),
      4,
      false,
    );

    canvas.drawCircle(const Offset(20, 19), 12, shadowPaint);
    canvas.drawCircle(const Offset(20, 18), 12, pinPaint);

    final path = Path()
      ..moveTo(20, 46)
      ..lineTo(10, 24)
      ..quadraticBezierTo(20, 32, 30, 24)
      ..close();
    canvas.drawPath(path, pinPaint);
    canvas.drawCircle(const Offset(20, 18), 4, innerPaint);

    final image = await recorder.endRecording().toImage(size.toInt(), height.toInt());
    final bytes = await image.toByteData(format: ui.ImageByteFormat.png);

    return BitmapDescriptor.bytes(bytes!.buffer.asUint8List());
  }

  Future<BitmapDescriptor> _createTrackingMarker() async {
    // Carregar a imagem do caixão dos assets
    final ByteData data = await rootBundle.load('assets/images/icone caixao.png');
    final Uint8List bytes = data.buffer.asUint8List();
    
    // Decodificar a imagem com alta qualidade
    final ui.Codec codec = await ui.instantiateImageCodec(
      bytes,
      targetWidth: 100,  // Tamanho maior para melhor resolução
      targetHeight: 100,
      allowUpscaling: false,
    );
    final ui.FrameInfo frameInfo = await codec.getNextFrame();
    final ui.Image originalImage = frameInfo.image;
    
    // Criar um canvas para desenhar a imagem com melhor qualidade
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);
    final paint = Paint()
      ..filterQuality = FilterQuality.high
      ..isAntiAlias = true;
    
    // Desenhar a imagem redimensionada com alta qualidade
    canvas.drawImageRect(
      originalImage,
      Rect.fromLTWH(0, 0, originalImage.width.toDouble(), originalImage.height.toDouble()),
      Rect.fromLTWH(0, 0, 50, 50),  // Tamanho final um pouco maior no mapa
      paint,
    );
    
    final picture = recorder.endRecording();
    final image = await picture.toImage(50, 50);
    final ByteData? pngBytes = await image.toByteData(format: ui.ImageByteFormat.png);
    
    return BitmapDescriptor.bytes(pngBytes!.buffer.asUint8List());
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
                initialCameraPosition: _userLocation != null 
                    ? CameraPosition(target: _userLocation!, zoom: 14)
                    : _initialPosition,
                style: _mapStyle,
                markers: _markers,
                polylines: _polylines,
                zoomControlsEnabled: false,
                mapToolbarEnabled: false,
                myLocationButtonEnabled: false,
                compassEnabled: true,
                onMapCreated: (controller) {
                  _mapController = controller;
                  if (_userLocation != null) {
                    controller.animateCamera(
                      CameraUpdate.newCameraPosition(
                        CameraPosition(target: _userLocation!, zoom: 14),
                      ),
                    );
                  }
                },
              ),
            ),
          // Card de notificação quando iniciar rastreamento (estilo Uber)
          if (_trackedCompany != null && _isSimulating)
            Positioned(
              top: 16,
              left: 16,
              right: 16,
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.15),
                      blurRadius: 20,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: AppColors.gold.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.local_shipping_outlined,
                        color: AppColors.gold,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            '${_trackedCompany!['name']}',
                            style: const TextStyle(
                              color: Colors.black87,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              fontFamily: 'Poppins',
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'está indo ao seu destino',
                            style: TextStyle(
                              color: Colors.black.withValues(alpha: 0.6),
                              fontSize: 12,
                              fontFamily: 'Poppins',
                            ),
                          ),
                          const SizedBox(height: 6),
                          Row(
                            children: [
                              Icon(
                                Icons.access_time,
                                size: 14,
                                color: Colors.black.withValues(alpha: 0.5),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                _estimatedTimeMinutes > 60
                                    ? '${(_estimatedTimeMinutes / 60).toStringAsFixed(1)}h'
                                    : '${_estimatedTimeMinutes} min',
                                style: TextStyle(
                                  color: Colors.black.withValues(alpha: 0.7),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  fontFamily: 'Poppins',
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
            )
          else if (_trackedCompany == null)
            Positioned(
              top: 16,
              left: 16,
              right: 16,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 15,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    const Icon(Icons.map_outlined, color: AppColors.gold, size: 20),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Veja funerárias e serviços próximos no mapa',
                        style: TextStyle(
                          color: Colors.black.withValues(alpha: 0.7),
                          fontSize: 13,
                          fontFamily: 'Poppins',
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          // Botões de zoom estilo Uber
          Positioned(
            right: 16,
            bottom: 96,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 15,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: _companies.isEmpty
                          ? null
                          : () {
                        HapticFeedback.lightImpact();
                        _zoomIn();
                      },
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(12),
                        topRight: Radius.circular(12),
                      ),
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        child: const Icon(
                          Icons.add,
                          color: Colors.black87,
                          size: 24,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    height: 1,
                    color: Colors.grey.withValues(alpha: 0.2),
                  ),
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: _companies.isEmpty
                          ? null
                          : () {
                        HapticFeedback.lightImpact();
                        _zoomOut();
                      },
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(12),
                        bottomRight: Radius.circular(12),
                      ),
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        child: const Icon(
                          Icons.remove,
                          color: Colors.black87,
                          size: 24,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Botão de iniciar partida (simulação)
          if (_trackedCompany == null)
            Positioned(
              left: 16,
              bottom: 24,
              child: Semantics(
                button: true,
                label: 'Iniciar Partida',
                hint: 'Toque para simular o rastreamento de uma funerária',
                child: FloatingActionButton.extended(
                  heroTag: 'start_tracking',
                  backgroundColor: AppColors.gold,
                  foregroundColor: Colors.black87,
                  onPressed: _companies.isNotEmpty
                      ? () {
                    HapticFeedback.lightImpact();
                    if (_companies.isNotEmpty) {
                      _startSimulation(_companies.first);
                    }
                  }
                      : null,
                  icon: const Icon(Icons.play_arrow),
                  label: const Text(
                    'Iniciar Partida',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Poppins',
                    ),
                  ),
                ),
              ),
            )
          else
            Positioned(
              left: 16,
              bottom: 24,
              child: Semantics(
                button: true,
                label: 'Parar rastreamento',
                hint: 'Toque para parar o rastreamento',
                child: FloatingActionButton.extended(
                  heroTag: 'stop_tracking',
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  onPressed: () {
                    HapticFeedback.lightImpact();
                    _stopTracking();
                  },
                  icon: const Icon(Icons.stop),
                  label: const Text(
                    'Parar',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Poppins',
                    ),
                  ),
                ),
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
                backgroundColor: Colors.white,
                foregroundColor: Colors.black87,
                onPressed: _companies.isEmpty
                    ? null
                    : () {
                  HapticFeedback.lightImpact();
                  _mapController?.animateCamera(
                    CameraUpdate.newCameraPosition(_initialPosition),
                  );
                },
                child: const Icon(Icons.my_location),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: widget.showBottomNavigation
          ? Container(
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
            )
          : null,
    );
  }

}
