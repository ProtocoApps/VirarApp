import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../constants/supabase_constants.dart';

class ProfileDatabaseService {
  static final ProfileDatabaseService _instance = ProfileDatabaseService._internal();
  factory ProfileDatabaseService() => _instance;
  ProfileDatabaseService._internal();

  final SupabaseClient _client = Supabase.instance.client;

  bool _isMissingColumnError(Object error) {
    return error is PostgrestException && error.code == 'PGRST204';
  }

  Future<void> createProfile({
    required String userId,
    required String fullName,
    required String email,
    required String phone,
    required String profileType, // 'citizen' ou 'entrepreneur'
    String? companyName,
    String? document,
    String? address,
    String? country,
    String? city,
    String? region,
  }) async {
    try {
      final profileData = {
        'id': userId,
        'full_name': fullName,
        'email': email,
        'phone': phone,
        'profile_type': profileType,
        'created_at': DateTime.now().toIso8601String(),
        'updated_at': DateTime.now().toIso8601String(),
      };

      // Adiciona campos específicos para empresário
      if (profileType == 'entrepreneur') {
        if (companyName != null) profileData['company_name'] = companyName;
      }
      
      // Adiciona campos comuns para ambos os perfis
      if (document != null) profileData['document'] = document;
      if (address != null) profileData['address'] = address;
      if (country != null) profileData['country'] = country;
      if (city != null) profileData['city'] = city;
      if (region != null) profileData['region'] = region;

      try {
        await _client.from('profiles').upsert(profileData);
      } catch (e) {
        if (!_isMissingColumnError(e)) {
          rethrow;
        }

        final fallbackProfileData = {
          'id': userId,
          'full_name': fullName,
          'email': email,
          'phone': phone,
          'profile_type': profileType,
          'created_at': DateTime.now().toIso8601String(),
          'updated_at': DateTime.now().toIso8601String(),
        };

        if (profileType == 'entrepreneur' && companyName != null) {
          fallbackProfileData['company_name'] = companyName;
        }

        if (document != null) {
          fallbackProfileData['document'] = document;
        }

        await _client.from('profiles').upsert(fallbackProfileData);
      }

      if (kDebugMode) print('Profile created successfully for user: $userId');
    } catch (e) {
      if (kDebugMode) print('Error creating profile: $e');
      rethrow;
    }
  }

  Future<Map<String, dynamic>?> getProfile(String userId) async {
    try {
      final response = await _client
          .from('profiles')
          .select()
          .eq('id', userId)
          .single();
      return response;
    } catch (e) {
      if (kDebugMode) print('Error getting profile: $e');
      return null;
    }
  }

  Future<List<Map<String, dynamic>>> getAllProfiles() async {
    try {
      final response = await _client
          .from('profiles')
          .select('*')
          .order('created_at', ascending: false);
      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      if (kDebugMode) print('Error getting all profiles: $e');
      return [];
    }
  }

  Future<void> updateProfile(String userId, Map<String, dynamic> data) async {
    try {
      data['updated_at'] = DateTime.now().toIso8601String();
      await _client
          .from('profiles')
          .update(data)
          .eq('id', userId);
      if (kDebugMode) print('Profile updated successfully for user: $userId');
    } catch (e) {
      if (kDebugMode) print('Error updating profile: $e');
      rethrow;
    }
  }

  Future<void> deleteProfile(String userId) async {
    try {
      await _client
          .from('profiles')
          .delete()
          .eq('id', userId);
      if (kDebugMode) print('Profile deleted successfully for user: $userId');
    } catch (e) {
      if (kDebugMode) print('Error deleting profile: $e');
      rethrow;
    }
  }
}
