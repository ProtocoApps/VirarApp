import 'package:supabase_flutter/supabase_flutter.dart';
import '../constants/supabase_constants.dart';
import 'profile_database_service.dart';

class DebugService {
  static final DebugService _instance = DebugService._internal();
  factory DebugService() => _instance;
  DebugService._internal();

  final SupabaseClient _client = Supabase.instance.client;
  final ProfileDatabaseService _profileService = ProfileDatabaseService();

  Future<void> checkSupabaseConnection() async {
    try {
      print('🔍 Verificando conexão com Supabase...');
      print('   URL: ${SupabaseConstants.supabaseUrl}');
      
      // Testar conexão básica
      final response = await _client.from('profiles').select('count').count();
      print('✅ Conexão OK! Total de perfis: ${response.count}');
      
    } catch (e) {
      print('❌ Erro na conexão: $e');
    }
  }

  Future<void> listAllUsers() async {
    try {
      print('\n👥 Listando todos os usuários cadastrados:');
      
      final profiles = await _profileService.getAllProfiles();
      
      if (profiles.isEmpty) {
        print('   Nenhum perfil encontrado na tabela profiles');
      } else {
        for (int i = 0; i < profiles.length; i++) {
          final profile = profiles[i];
          print('\n   --- Usuário ${i + 1} ---');
          print('   ID: ${profile['id']}');
          print('   Nome: ${profile['full_name']}');
          print('   Email: ${profile['email']}');
          print('   Telefone: ${profile['phone']}');
          print('   Tipo: ${profile['profile_type']}');
          if (profile['company_name'] != null) {
            print('   Empresa: ${profile['company_name']}');
          }
          if (profile['cnpj'] != null) {
            print('   CNPJ: ${profile['cnpj']}');
          }
          print('   Criado em: ${profile['created_at']}');
        }
      }
      
      print('\n📊 Total: ${profiles.length} perfis encontrados');
      
    } catch (e) {
      print('❌ Erro ao listar usuários: $e');
    }
  }

  Future<void> checkCurrentUser() async {
    try {
      print('\n🔐 Verificando usuário atual:');
      
      final currentUser = _client.auth.currentUser;
      
      if (currentUser == null) {
        print('   Nenhum usuário logado');
      } else {
        print('   ID: ${currentUser.id}');
        print('   Email: ${currentUser.email}');
        print('   Criado em: ${currentUser.createdAt}');
        print('   Metadata: ${currentUser.userMetadata}');
        
        // Verificar se existe perfil correspondente
        final profile = await _profileService.getProfile(currentUser.id);
        if (profile != null) {
          print('   ✅ Perfil encontrado na tabela profiles');
          print('   Tipo de perfil: ${profile['profile_type']}');
        } else {
          print('   ❌ Perfil não encontrado na tabela profiles');
        }
      }
      
    } catch (e) {
      print('❌ Erro ao verificar usuário atual: $e');
    }
  }

  Future<void> testProfileCreation() async {
    try {
      print('\n🧪 Testando criação de perfil...');
      
      const testUserId = 'test-user-id-123';
      const testFullName = 'Usuário Teste';
      const testEmail = 'teste@exemplo.com';
      const testPhone = '(11) 99999-9999';
      const testProfileType = 'citizen';
      
      await _profileService.createProfile(
        userId: testUserId,
        fullName: testFullName,
        email: testEmail,
        phone: testPhone,
        profileType: testProfileType,
      );
      
      print('✅ Perfil de teste criado com sucesso!');
      
      // Verificar se foi criado
      final profile = await _profileService.getProfile(testUserId);
      if (profile != null) {
        print('✅ Perfil encontrado e verificado!');
        
        // Limpar perfil de teste
        await _profileService.deleteProfile(testUserId);
        print('🧹 Perfil de teste removido');
      } else {
        print('❌ Perfil não encontrado após criação');
      }
      
    } catch (e) {
      print('❌ Erro no teste de criação: $e');
    }
  }

  Future<void> runFullDiagnostics() async {
    print('\n🔬 INICIANDO DIAGNÓSTICO COMPLETO DO SUPABASE');
    print('=' * 50);
    
    await checkSupabaseConnection();
    await checkCurrentUser();
    await listAllUsers();
    await testProfileCreation();
    
    print('\n✅ DIAGNÓSTICO CONCLUÍDO');
    print('=' * 50);
  }
}
