import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/services/supabase_service.dart';
import '../../../../core/services/profile_service.dart';
import '../../../../core/services/profile_database_service.dart';

class AuthProvider extends ChangeNotifier {
  final SupabaseService _supabaseService = SupabaseService();
  final ProfileDatabaseService _profileService = ProfileDatabaseService();
  
  bool _isLoading = false;
  bool _isAuthenticated = false;
  String? _errorMessage;
  User? _currentUser;
  Timer? _errorTimer;

  // Getters
  bool get isLoading => _isLoading;
  bool get isAuthenticated => _isAuthenticated;
  String? get errorMessage => _errorMessage;
  User? get currentUser => _currentUser;

  AuthProvider() {
    _checkAuthStatus();
  }

  void _checkAuthStatus() {
    _supabaseService.authStateChanges.listen((state) {
      _currentUser = state.session?.user;
      _isAuthenticated = state.session != null;
      notifyListeners();
    });
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  bool _isNetworkError(Object error) {
    final message = error.toString().toLowerCase();
    return error is SocketException ||
        message.contains('failed host lookup') ||
        message.contains('socketexception') ||
        message.contains('clientexception') ||
        message.contains('connection refused') ||
        message.contains('network is unreachable') ||
        message.contains('connection timed out') ||
        message.contains('timeout');
  }

  void _setError(String? error) {
    _errorMessage = error;
    _errorTimer?.cancel();
    if (error != null) {
      _errorTimer = Timer(const Duration(seconds: 4), () {
        if (_errorMessage == error) {
          _errorMessage = null;
          notifyListeners();
        }
      });
    }
    notifyListeners();
  }

  String _mapAuthError(Object error) {
    if (_isNetworkError(error)) {
      return 'Não foi possível conectar à internet ou ao servidor. Verifique sua conexão e tente novamente.';
    }

    if (error is AuthApiException) {
      if (error.code == 'user_already_exists') {
        return 'Este e-mail já está cadastrado. Tente entrar na sua conta.';
      }
      if (error.message.toLowerCase().contains('password')) {
        return 'A senha não atende aos requisitos mínimos.';
      }
      return error.message;
    }

    if (error is AuthException) {
      if (error.message.toLowerCase().contains('password')) {
        return 'A senha não atende aos requisitos mínimos.';
      }
      return error.message;
    }

    return 'Erro ao criar conta. Tente novamente.';
  }

  String _mapSignInError(Object error) {
    if (_isNetworkError(error)) {
      return 'Sem conexão com a internet ou com o servidor. Verifique sua rede e tente novamente.';
    }

    if (error is AuthApiException) {
      if (error.code == 'email_not_confirmed' ||
          error.message.toLowerCase().contains('email not confirmed')) {
        return 'Seu e-mail ainda não foi confirmado. Verifique sua caixa de entrada.';
      }
      if (error.code == 'invalid_credentials') {
        return 'Email ou senha incorretos.';
      }
      return error.message;
    }

    if (error is AuthException) {
      if (error.message.toLowerCase().contains('email not confirmed')) {
        return 'Seu e-mail ainda não foi confirmado. Verifique sua caixa de entrada.';
      }
      return error.message;
    }

    return 'Erro ao entrar. Tente novamente.';
  }

  String _mapResetPasswordError(Object error) {
    if (_isNetworkError(error)) {
      return 'Sem conexão com a internet ou com o servidor. Verifique sua rede e tente novamente.';
    }

    if (error is AuthApiException) {
      return error.message;
    }

    if (error is AuthException) {
      return error.message;
    }

    return 'Não foi possível enviar o e-mail de recuperação. Tente novamente.';
  }

  Future<bool> signIn(String email, String password) async {
    _setLoading(true);
    _setError(null);

    final normalizedEmail = email.trim().toLowerCase();

    try {
      final response = await _supabaseService.signIn(normalizedEmail, password);
      
      if (response.user != null) {
        _isAuthenticated = true;
        _currentUser = response.user;
        return true;
      } else {
        _setError('Falha no login. Tente novamente.');
        return false;
      }
    } catch (e) {
      _setError(_mapSignInError(e));
      if (kDebugMode) print('Login error: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> resetPassword(String email) async {
    _setLoading(true);
    _setError(null);

    final normalizedEmail = email.trim().toLowerCase();

    try {
      await _supabaseService.resetPassword(normalizedEmail);
      return true;
    } catch (e) {
      _setError(_mapResetPasswordError(e));
      if (kDebugMode) print('Reset password error: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> signUp({
    required String fullName,
    required String email,
    required String phone,
    required String password,
    String? document,
    String? address,
    String? country,
    String? city,
    String? region,
  }) async {
    _setLoading(true);
    _setError(null);
    User? createdUser;
    final normalizedEmail = email.trim().toLowerCase();

    try {
      // 1. Criar usuário no auth do Supabase
      final response = await _supabaseService.signUp(
        normalizedEmail,
        password,
        fullName: fullName,
        phone: phone,
      );
      createdUser = response.user;
      
      if (response.user != null) {
        User? authenticatedUser = response.user;

        if (response.session != null) {
          _isAuthenticated = true;
          _currentUser = response.user;
        } else {
          try {
            final signInResponse = await _supabaseService.signIn(normalizedEmail, password);
            authenticatedUser = signInResponse.user ?? response.user;
            _isAuthenticated = signInResponse.user != null;
            _currentUser = signInResponse.user;
          } catch (e) {
            if (kDebugMode) {
              print('⚠️ Sign in after sign up failed: $e');
            }
          }
        }

        // 2. Criar perfil na tabela profiles
        try {
          await _profileService.createProfile(
            userId: response.user!.id,
            fullName: fullName,
            email: normalizedEmail,
            phone: phone,
            profileType: 'citizen',
            document: document,
            address: address,
            country: country,
            city: city,
            region: region,
          );
        } catch (e) {
          if (kDebugMode) print('❌ Profile creation error after auth success: $e');
        }
        
        _isAuthenticated = authenticatedUser != null;
        _currentUser = authenticatedUser;
        
        if (kDebugMode) {
          print('✅ User created and profile saved:');
          print('   User ID: ${response.user!.id}');
          print('   Email: $normalizedEmail');
          print('   Profile Type: citizen');
          print('   Document: $document');
          print('   Address: $address');
          print('   City: $city');
          print('   Region: $region');
        }
        
        return true;
      } else {
        _setError('Falha no cadastro. Tente novamente.');
        return false;
      }
    } catch (e) {
      if (createdUser != null) {
        _setError('Sua conta já foi criada. Tente entrar com seu e-mail e senha.');
      } else {
        _setError(_mapAuthError(e));
      }
      if (kDebugMode) print('❌ Sign up error: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<void> signOut() async {
    try {
      await _supabaseService.signOut();
      _isAuthenticated = false;
      _currentUser = null;
    } catch (e) {
      _setError('Erro ao sair. Tente novamente.');
      if (kDebugMode) print('Sign out error: $e');
    }
  }

  void clearError() {
    _setError(null);
  }

  @override
  void dispose() {
    _errorTimer?.cancel();
    super.dispose();
  }
}
