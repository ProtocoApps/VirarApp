class AppConstants {
  // App Info
  static const String appName = 'VIRAR';
  static const String appVersion = '1.0.0';
  
  // API Configuration
  static const String baseUrl = 'https://api.virar.com.br';
  static const String apiVersion = 'v1';
  
  // Storage Keys
  static const String tokenKey = 'auth_token';
  static const String userKey = 'user_data';
  static const String themeKey = 'theme_preference';
  
  // Routes
  static const String welcomeRoute = '/welcome';
  static const String loginRoute = '/login';
  static const String registerRoute = '/register';
  static const String homeRoute = '/home';
  static const String searchRoute = '/search';
  static const String profileRoute = '/profile';
  
  // Animation Durations
  static const Duration shortAnimation = Duration(milliseconds: 200);
  static const Duration mediumAnimation = Duration(milliseconds: 300);
  static const Duration longAnimation = Duration(milliseconds: 500);
  
  // Padding and Margins
  static const double smallPadding = 8.0;
  static const double mediumPadding = 16.0;
  static const double largePadding = 24.0;
  static const double extraLargePadding = 32.0;
  
  // Border Radius
  static const double smallRadius = 8.0;
  static const double mediumRadius = 12.0;
  static const double largeRadius = 16.0;
  static const double extraLargeRadius = 24.0;
  
  // Font Sizes
  static const double smallFontSize = 12.0;
  static const double mediumFontSize = 14.0;
  static const double largeFontSize = 16.0;
  static const double extraLargeFontSize = 18.0;
  static const double titleFontSize = 24.0;
  static const double headerFontSize = 28.0;
  
  // Image Sizes
  static const double smallImageSize = 32.0;
  static const double mediumImageSize = 48.0;
  static const double largeImageSize = 64.0;
  static const double extraLargeImageSize = 96.0;
  
  // Grid Settings
  static const int gridCrossAxisCount = 2;
  static const double gridChildAspectRatio = 0.75;
  static const double gridSpacing = 16.0;
  
  // List Settings
  static const double listPadding = 8.0;
  static const double listItemHeight = 120.0;
  
  // Error Messages
  static const String genericErrorMessage = 'Ocorreu um erro. Tente novamente.';
  static const String networkErrorMessage = 'Verifique sua conexão com a internet.';
  static const String serverErrorMessage = 'Servidor indisponível. Tente mais tarde.';
  
  // Success Messages
  static const String loginSuccessMessage = 'Login realizado com sucesso!';
  static const String registerSuccessMessage = 'Cadastro realizado com sucesso!';
  static const String updateSuccessMessage = 'Dados atualizados com sucesso!';
  
  // Validation Messages
  static const String emailRequiredMessage = 'E-mail é obrigatório';
  static const String emailInvalidMessage = 'E-mail inválido';
  static const String passwordRequiredMessage = 'Senha é obrigatória';
  static const String passwordShortMessage = 'Senha deve ter pelo menos 6 caracteres';
  static const String passwordMismatchMessage = 'Senhas não conferem';
  static const String nameRequiredMessage = 'Nome é obrigatório';
  static const String phoneRequiredMessage = 'Telefone é obrigatório';
  
  // Service Categories
  static const List<String> serviceCategories = [
    'CREMAÇÃO',
    'VELÓRIO',
    'TRANSLADO',
    'DOCUMENTAÇÃO',
    'PLANOS',
    'ORNAMENTAÇÃO',
  ];
  
  // Filter Options
  static const List<String> sortOptions = [
    'Mais Relevantes',
    'Melhor Avaliados',
    'Mais Próximos',
    'Menor Preço',
  ];
  
  // Rating Levels
  static const List<int> ratingLevels = [5, 4, 3, 2, 1];
  
  // Price Ranges
  static const List<String> priceRanges = [
    'Até R\$ 1.000',
    'R\$ 1.000 - R\$ 3.000',
    'R\$ 3.000 - R\$ 5.000',
    'Acima de R\$ 5.000',
  ];
}
