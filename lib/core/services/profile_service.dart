import 'package:shared_preferences/shared_preferences.dart';

enum UserProfileType {
  citizen('cidadão'),
  entrepreneur('empresário');

  const UserProfileType(this.displayName);
  final String displayName;
}

class ProfileService {
  static final ProfileService _instance = ProfileService._internal();
  factory ProfileService() => _instance;
  ProfileService._internal();

  static const String _profileTypeKey = 'user_profile_type';

  Future<void> saveProfileType(UserProfileType type) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_profileTypeKey, type.name);
    } catch (e) {
      print('Error saving profile type: $e');
      rethrow;
    }
  }

  Future<UserProfileType?> getProfileType() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final profileTypeString = prefs.getString(_profileTypeKey);
      
      if (profileTypeString == null) return null;
      
      return UserProfileType.values.firstWhere(
        (type) => type.name == profileTypeString,
        orElse: () => UserProfileType.citizen,
      );
    } catch (e) {
      print('Error getting profile type: $e');
      return null;
    }
  }

  Future<void> clearProfileType() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_profileTypeKey);
    } catch (e) {
      print('Error clearing profile type: $e');
    }
  }

  Future<bool> hasProfileType() async {
    final type = await getProfileType();
    return type != null;
  }
}
