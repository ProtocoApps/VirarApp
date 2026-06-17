import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import '../providers/app_language_provider.dart';
import 'app_language.dart';

class AppLocalizations {
  AppLocalizations(this.language);

  final AppLanguage language;

  static AppLocalizations of(BuildContext context) {
    final provider = Provider.of<AppLanguageProvider>(context, listen: false);
    return AppLocalizations(provider.currentLanguage);
  }

  static const Map<String, Map<AppLanguage, String>> _strings = {
    'app_tagline': {
      AppLanguage.portuguese: 'Soluções que Transformam o Cuidado',
      AppLanguage.english: 'Solutions That Transform Funeral Homes',
      AppLanguage.spanish: 'Soluciones que Transforman Funerarias',
    },
    'welcome_start_service': {
      AppLanguage.portuguese: 'Iniciar atendimento',
      AppLanguage.english: 'Start service',
      AppLanguage.spanish: 'Iniciar atención',
    },
    'welcome_already_registered': {
      AppLanguage.portuguese: 'Já tenho cadastro',
      AppLanguage.english: 'I already have an account',
      AppLanguage.spanish: 'Ya tengo registro',
    },
    'welcome_title': {
      AppLanguage.portuguese: 'Apoio nos\nmomentos difíceis',
      AppLanguage.english: 'Support in the\nmost difficult moments',
      AppLanguage.spanish: 'Apoyo en los momentos\nmás difíciles',
    },
    'welcome_description': {
      AppLanguage.portuguese: 'Conectamos você a serviços, apoio e cuidado com respeito e agilidade.',
      AppLanguage.english: 'We connect you to trusted funeral services with respect, agility, and care in every detail.',
      AppLanguage.spanish: 'Lo conectamos con servicios funerarios confiables, con respeto, agilidad y cuidado en cada detalle.',
    },
    'start': {
      AppLanguage.portuguese: 'Começar',
      AppLanguage.english: 'Get Started',
      AppLanguage.spanish: 'Comenzar',
    },
    'already_have_account': {
      AppLanguage.portuguese: 'Já tenho uma conta',
      AppLanguage.english: 'I already have an account',
      AppLanguage.spanish: 'Ya tengo una cuenta',
    },
    'app_language': {
      AppLanguage.portuguese: 'Idioma do app',
      AppLanguage.english: 'App language',
      AppLanguage.spanish: 'Idioma de la app',
    },
    'choose_language_hint': {
      AppLanguage.portuguese: 'Escolha como deseja usar o aplicativo desde o início.',
      AppLanguage.english: 'Choose how you want to use the app from the start.',
      AppLanguage.spanish: 'Elija cómo desea usar la aplicación desde el inicio.',
    },
    'login_welcome': {
      AppLanguage.portuguese: 'Bem-vindo ao VIRAR',
      AppLanguage.english: 'Welcome to VIRAR',
      AppLanguage.spanish: 'Bienvenido a VIRAR',
    },
    'login_subtitle': {
      AppLanguage.portuguese: 'Soluções de cuidado, apoio e serviços com dignidade',
      AppLanguage.english: 'Soluções de cuidado, apoio e serviços com dignidade',
      AppLanguage.spanish: 'Soluções de cuidado, apoio e serviços com dignidade',
    },
    'email_label': {
      AppLanguage.portuguese: 'E-mail',
      AppLanguage.english: 'Email',
      AppLanguage.spanish: 'Correo electrónico',
    },
    'email_hint_registered': {
      AppLanguage.portuguese: 'Seu e-mail cadastrado',
      AppLanguage.english: 'Your registered email',
      AppLanguage.spanish: 'Su correo registrado',
    },
    'password': {
      AppLanguage.portuguese: 'Senha',
      AppLanguage.english: 'Password',
      AppLanguage.spanish: 'Contraseña',
    },
    'password_hint': {
      AppLanguage.portuguese: 'Sua senha',
      AppLanguage.english: 'Your password',
      AppLanguage.spanish: 'Su contraseña',
    },
    'remember_me': {
      AppLanguage.portuguese: 'Lembrar de mim',
      AppLanguage.english: 'Remember me',
      AppLanguage.spanish: 'Recordarme',
    },
    'forgot_password': {
      AppLanguage.portuguese: 'Esqueci minha senha',
      AppLanguage.english: 'I forgot my password',
      AppLanguage.spanish: 'Olvidé mi contraseña',
    },
    'sign_in': {
      AppLanguage.portuguese: 'ENTRAR',
      AppLanguage.english: 'SIGN IN',
      AppLanguage.spanish: 'INICIAR SESIÓN',
    },
    'no_account': {
      AppLanguage.portuguese: 'Não tem uma conta? ',
      AppLanguage.english: 'Don’t have an account? ',
      AppLanguage.spanish: '¿No tiene una cuenta? ',
    },
    'create_account': {
      AppLanguage.portuguese: 'Criar conta',
      AppLanguage.english: 'Create account',
      AppLanguage.spanish: 'Crear cuenta',
    },
    'login_error': {
      AppLanguage.portuguese: 'Erro no login',
      AppLanguage.english: 'Login error',
      AppLanguage.spanish: 'Error de inicio de sesión',
    },
    'enter_email': {
      AppLanguage.portuguese: 'Por favor, digite seu e-mail',
      AppLanguage.english: 'Please enter your email',
      AppLanguage.spanish: 'Por favor, ingrese su correo electrónico',
    },
    'enter_valid_email': {
      AppLanguage.portuguese: 'Digite um e-mail válido',
      AppLanguage.english: 'Enter a valid email',
      AppLanguage.spanish: 'Ingrese un correo válido',
    },
    'enter_password': {
      AppLanguage.portuguese: 'Por favor, digite sua senha',
      AppLanguage.english: 'Please enter your password',
      AppLanguage.spanish: 'Por favor, ingrese su contraseña',
    },
    'password_min_length': {
      AppLanguage.portuguese: 'A senha deve ter pelo menos 6 caracteres',
      AppLanguage.english: 'Password must be at least 6 characters',
      AppLanguage.spanish: 'La contraseña debe tener al menos 6 caracteres',
    },
    'register_title': {
      AppLanguage.portuguese: 'Crie sua conta',
      AppLanguage.english: 'Create your account',
      AppLanguage.spanish: 'Cree su cuenta',
    },
    'register_subtitle': {
      AppLanguage.portuguese: 'Preencha os dados abaixo para começar sua experiência premium.',
      AppLanguage.english: 'Fill in the details below to start your premium experience.',
      AppLanguage.spanish: 'Complete los datos a continuación para comenzar su experiencia premium.',
    },
    'full_name': {
      AppLanguage.portuguese: 'Nome completo',
      AppLanguage.english: 'Full name',
      AppLanguage.spanish: 'Nombre completo',
    },
    'full_name_hint': {
      AppLanguage.portuguese: 'Digite seu nome completo',
      AppLanguage.english: 'Enter your full name',
      AppLanguage.spanish: 'Ingrese su nombre completo',
    },
    'phone': {
      AppLanguage.portuguese: 'Celular',
      AppLanguage.english: 'Phone',
      AppLanguage.spanish: 'Teléfono',
    },
    'profile_type': {
      AppLanguage.portuguese: 'Tipo de Perfil',
      AppLanguage.english: 'Profile Type',
      AppLanguage.spanish: 'Tipo de Perfil',
    },
    'citizen': {
      AppLanguage.portuguese: 'Cidadão',
      AppLanguage.english: 'Citizen',
      AppLanguage.spanish: 'Ciudadano',
    },
    'citizen_desc': {
      AppLanguage.portuguese: 'Busco serviços funerários',
      AppLanguage.english: 'I am looking for funeral services',
      AppLanguage.spanish: 'Busco servicios funerarios',
    },
    'entrepreneur': {
      AppLanguage.portuguese: 'Empresário',
      AppLanguage.english: 'Business Owner',
      AppLanguage.spanish: 'Empresario',
    },
    'entrepreneur_desc': {
      AppLanguage.portuguese: 'Ofereço serviços funerários',
      AppLanguage.english: 'I offer funeral services',
      AppLanguage.spanish: 'Ofrezco servicios funerarios',
    },
    'search_support': {
      AppLanguage.portuguese: 'Encontre amparo',
      AppLanguage.english: 'Find support',
      AppLanguage.spanish: 'Encuentre apoyo',
    },
    'services_with_respect': {
      AppLanguage.portuguese: 'Serviços funerários com dignidade e respeito.',
      AppLanguage.english: 'Funeral services with dignity and respect.',
      AppLanguage.spanish: 'Servicios funerarios con dignidad y respeto.',
    },
    'categories': {
      AppLanguage.portuguese: 'Categorias',
      AppLanguage.english: 'Categories',
      AppLanguage.spanish: 'Categorías',
    },
    'featured_funeral_homes': {
      AppLanguage.portuguese: 'Funerárias em Destaque',
      AppLanguage.english: 'Featured Funeral Homes',
      AppLanguage.spanish: 'Funerarias Destacadas',
    },
    'view_all': {
      AppLanguage.portuguese: 'Ver todas',
      AppLanguage.english: 'View all',
      AppLanguage.spanish: 'Ver todas',
    },
    'home_nav': {
      AppLanguage.portuguese: 'INÍCIO',
      AppLanguage.english: 'HOME',
      AppLanguage.spanish: 'INICIO',
    },
    'search_nav': {
      AppLanguage.portuguese: 'BUSCAR',
      AppLanguage.english: 'SEARCH',
      AppLanguage.spanish: 'BUSCAR',
    },
    'plans_nav': {
      AppLanguage.portuguese: 'PLANOS',
      AppLanguage.english: 'PLANS',
      AppLanguage.spanish: 'PLANES',
    },
    'profile_nav': {
      AppLanguage.portuguese: 'PERFIL',
      AppLanguage.english: 'PROFILE',
      AppLanguage.spanish: 'PERFIL',
    },
    'all': {
      AppLanguage.portuguese: 'Todos',
      AppLanguage.english: 'All',
      AppLanguage.spanish: 'Todos',
    },
    'funeral_services': {
      AppLanguage.portuguese: 'Serviços Funerários',
      AppLanguage.english: 'Funeral Services',
      AppLanguage.spanish: 'Servicios Funerarios',
    },
    'wake_ceremony': {
      AppLanguage.portuguese: 'Velório e Cerimônia',
      AppLanguage.english: 'Wake and Ceremony',
      AppLanguage.spanish: 'Velorio y Ceremonia',
    },
    'flowers_tributes': {
      AppLanguage.portuguese: 'Flores e Homenagens',
      AppLanguage.english: 'Flowers and Tributes',
      AppLanguage.spanish: 'Flores y Homenajes',
    },
    'cemetery_burial': {
      AppLanguage.portuguese: 'Cemitério e Sepultamento',
      AppLanguage.english: 'Cemetery and Burial',
      AppLanguage.spanish: 'Cementerio y Sepultura',
    },
    'documentation_bureaucracy': {
      AppLanguage.portuguese: 'Documentação e Burocracia',
      AppLanguage.english: 'Documentation and Bureaucracy',
      AppLanguage.spanish: 'Documentación y Burocracia',
    },
    'family_support': {
      AppLanguage.portuguese: 'Apoio à Família',
      AppLanguage.english: 'Family Support',
      AppLanguage.spanish: 'Apoyo a la Familia',
    },
    'funeral_transport': {
      AppLanguage.portuguese: 'Transporte Funerário',
      AppLanguage.english: 'Funeral Transport',
      AppLanguage.spanish: 'Transporte Funerario',
    },
    'post_death_services': {
      AppLanguage.portuguese: 'Serviços Pós-Falecimento',
      AppLanguage.english: 'Post-Death Services',
      AppLanguage.spanish: 'Servicios Post-Fallecimiento',
    },
    'grave_maintenance': {
      AppLanguage.portuguese: 'Manutenção de Túmulos',
      AppLanguage.english: 'Grave Maintenance',
      AppLanguage.spanish: 'Mantenimiento de Tumbas',
    },
    'digital_memorial': {
      AppLanguage.portuguese: 'Memorial Digital',
      AppLanguage.english: 'Digital Memorial',
      AppLanguage.spanish: 'Memorial Digital',
    },
    'memorials_headstones': {
      AppLanguage.portuguese: 'Memoriais e Lápides',
      AppLanguage.english: 'Memorials and Headstones',
      AppLanguage.spanish: 'Memoriales y Lápidas',
    },
    'advance_planning': {
      AppLanguage.portuguese: 'Planejamento Antecipado',
      AppLanguage.english: 'Advance Planning',
      AppLanguage.spanish: 'Planificación Anticipada',
    },
    'wake_buffet': {
      AppLanguage.portuguese: 'Buffet para Velório e Cerimônias',
      AppLanguage.english: 'Buffet for Wake and Ceremonies',
      AppLanguage.spanish: 'Buffet para Velorio y Ceremonias',
    },
    'social_assistance': {
      AppLanguage.portuguese: 'Assistência Social',
      AppLanguage.english: 'Social Assistance',
      AppLanguage.spanish: 'Asistencia Social',
    },
    'pet_funeral_services': {
      AppLanguage.portuguese: 'Serviços Funerários para Pets 🐾',
      AppLanguage.english: 'Pet Funeral Services 🐾',
      AppLanguage.spanish: 'Servicios Funerarios para Mascotas 🐾',
    },
    'no_companies_found_category': {
      AppLanguage.portuguese: 'Nenhuma empresa encontrada para essa categoria.',
      AppLanguage.english: 'No companies found for this category.',
      AppLanguage.spanish: 'No se encontraron empresas para esta categoría.',
    },
    'search_city_neighborhood': {
      AppLanguage.portuguese: 'Cidade ou bairro',
      AppLanguage.english: 'City or neighborhood',
      AppLanguage.spanish: 'Ciudad o barrio',
    },
    'my_profile': {
      AppLanguage.portuguese: 'Meu Perfil',
      AppLanguage.english: 'My Profile',
      AppLanguage.spanish: 'Mi Perfil',
    },
    'profile_edit_soon': {
      AppLanguage.portuguese: 'Edição de perfil em breve!',
      AppLanguage.english: 'Profile editing coming soon!',
      AppLanguage.spanish: '¡La edición del perfil estará disponible pronto!',
    },
    'notifications': {
      AppLanguage.portuguese: 'Notificações',
      AppLanguage.english: 'Notifications',
      AppLanguage.spanish: 'Notificaciones',
    },
    'receive_alerts': {
      AppLanguage.portuguese: 'Receber alertas e atualizações',
      AppLanguage.english: 'Receive alerts and updates',
      AppLanguage.spanish: 'Recibir alertas y actualizaciones',
    },
    'location': {
      AppLanguage.portuguese: 'Localização',
      AppLanguage.english: 'Location',
      AppLanguage.spanish: 'Ubicación',
    },
    'allow_location': {
      AppLanguage.portuguese: 'Permitir acesso à localização',
      AppLanguage.english: 'Allow location access',
      AppLanguage.spanish: 'Permitir acceso a la ubicación',
    },
    'dark_mode': {
      AppLanguage.portuguese: 'Modo Escuro',
      AppLanguage.english: 'Dark Mode',
      AppLanguage.spanish: 'Modo Oscuro',
    },
    'dark_mode_desc': {
      AppLanguage.portuguese: 'Tema escuro do aplicativo',
      AppLanguage.english: 'Dark theme for the app',
      AppLanguage.spanish: 'Tema oscuro de la aplicación',
    },
    'help_center': {
      AppLanguage.portuguese: 'Central de Ajuda',
      AppLanguage.english: 'Help Center',
      AppLanguage.spanish: 'Centro de Ayuda',
    },
    'faq_support': {
      AppLanguage.portuguese: 'Perguntas frequentes e suporte',
      AppLanguage.english: 'Frequently asked questions and support',
      AppLanguage.spanish: 'Preguntas frecuentes y soporte',
    },
    'contact_us': {
      AppLanguage.portuguese: 'Fale Conosco',
      AppLanguage.english: 'Contact Us',
      AppLanguage.spanish: 'Contáctenos',
    },
    'get_in_touch': {
      AppLanguage.portuguese: 'Entre em contato conosco',
      AppLanguage.english: 'Get in touch with us',
      AppLanguage.spanish: 'Póngase en contacto con nosotros',
    },
    'privacy_policy': {
      AppLanguage.portuguese: 'Política de Privacidade',
      AppLanguage.english: 'Privacy Policy',
      AppLanguage.spanish: 'Política de Privacidad',
    },
    'privacy_policy_desc': {
      AppLanguage.portuguese: 'Nossas políticas de privacidade',
      AppLanguage.english: 'Our privacy policies',
      AppLanguage.spanish: 'Nuestras políticas de privacidad',
    },
    'terms_of_use': {
      AppLanguage.portuguese: 'Termos de Uso',
      AppLanguage.english: 'Terms of Use',
      AppLanguage.spanish: 'Términos de Uso',
    },
    'terms_of_use_desc': {
      AppLanguage.portuguese: 'Termos e condições do serviço',
      AppLanguage.english: 'Terms and conditions of service',
      AppLanguage.spanish: 'Términos y condiciones del servicio',
    },
    'complete_name': {
      AppLanguage.portuguese: 'Nome Completo',
      AppLanguage.english: 'Full Name',
      AppLanguage.spanish: 'Nombre Completo',
    },
    'document': {
      AppLanguage.portuguese: 'Documento',
      AppLanguage.english: 'Document',
      AppLanguage.spanish: 'Documento',
    },
    'address': {
      AppLanguage.portuguese: 'Endereço',
      AppLanguage.english: 'Address',
      AppLanguage.spanish: 'Dirección',
    },
    'city': {
      AppLanguage.portuguese: 'Cidade',
      AppLanguage.english: 'City',
      AppLanguage.spanish: 'Ciudad',
    },
    'region': {
      AppLanguage.portuguese: 'Região',
      AppLanguage.english: 'Region',
      AppLanguage.spanish: 'Región',
    },
    'user': {
      AppLanguage.portuguese: 'Usuário',
      AppLanguage.english: 'User',
      AppLanguage.spanish: 'Usuario',
    },
    'not_informed': {
      AppLanguage.portuguese: 'Não informado',
      AppLanguage.english: 'Not provided',
      AppLanguage.spanish: 'No informado',
    },
    'personal_information': {
      AppLanguage.portuguese: 'Informações Pessoais',
      AppLanguage.english: 'Personal Information',
      AppLanguage.spanish: 'Información Personal',
    },
    'app_settings': {
      AppLanguage.portuguese: 'Configurações do Aplicativo',
      AppLanguage.english: 'App Settings',
      AppLanguage.spanish: 'Configuración de la Aplicación',
    },
    'support': {
      AppLanguage.portuguese: 'Suporte',
      AppLanguage.english: 'Support',
      AppLanguage.spanish: 'Soporte',
    },
    'logout': {
      AppLanguage.portuguese: 'Sair da Conta',
      AppLanguage.english: 'Sign Out',
      AppLanguage.spanish: 'Cerrar Sesión',
    },
    'feature_in_development': {
      AppLanguage.portuguese: 'Funcionalidade em desenvolvimento!',
      AppLanguage.english: 'Feature in development!',
      AppLanguage.spanish: '¡Funcionalidad en desarrollo!',
    },
  };

  String text(String key) {
    return _strings[key]?[language] ?? _strings[key]?[AppLanguage.portuguese] ?? key;
  }
}

extension AppLocalizationsX on BuildContext {
  AppLocalizations get t => AppLocalizations.of(this);
}
