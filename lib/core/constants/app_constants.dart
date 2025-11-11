class AppConstants {
  // API Configuration
  static const String apiBaseUrl = 'https://api.musicaterapeutica.com/api/v1';
  static const int apiTimeout = 30000; // 30 seconds

  // Storage Keys
  static const String keyAccessToken = 'access_token';
  static const String keyRefreshToken = 'refresh_token';
  static const String keyUserId = 'user_id';
  static const String keyUserData = 'user_data';

  // Subscription Plans
  static const String planMonthly = 'monthly';
  static const String planAnnual = 'annual';
  static const double priceMonthly = 19.99;
  static const double priceAnnual = 199.99;

  // Audio Quality
  static const String qualityNormal = '128kbps';
  static const String qualityHigh = '256kbps';

  // Pagination
  static const int defaultPageSize = 20;
  static const int maxPageSize = 100;

  // Validation
  static const int minPasswordLength = 8;
  static const int maxPlaylistNameLength = 100;

  // Trial Period
  static const int trialDays = 14;

  // Audio Settings
  static const Duration seekDuration = Duration(seconds: 10);
  static const Duration urlExpirationTime = Duration(hours: 1);

  // Categories (Therapeutic)
  static const List<String> therapeuticCategories = [
    'Relajación Profunda',
    'Energización',
    'Meditación',
    'Procesamiento Emocional',
    'Activación Cognitiva',
    'Acompañamiento de Dolor',
    'Terapia Infantil',
    'EMDR',
    'Mindfulness',
  ];
}

class AppStrings {
  // App
  static const String appName = 'Música Terapéutica';
  static const String appTagline = 'Tu biblioteca musical profesional';

  // Auth
  static const String login = 'Iniciar Sesión';
  static const String register = 'Registrarse';
  static const String logout = 'Cerrar Sesión';
  static const String email = 'Correo Electrónico';
  static const String password = 'Contraseña';
  static const String fullName = 'Nombre Completo';
  static const String profession = 'Profesión';
  static const String forgotPassword = 'Olvidé mi contraseña';
  static const String resetPassword = 'Restablecer Contraseña';

  // Home
  static const String home = 'Inicio';
  static const String featured = 'Destacado';
  static const String categories = 'Categorías';
  static const String recentlyPlayed = 'Reproducido Recientemente';
  static const String continueListening = 'Continuar Escuchando';

  // Player
  static const String nowPlaying = 'Reproduciendo Ahora';
  static const String queue = 'Cola de Reproducción';
  static const String addToPlaylist = 'Añadir a Playlist';
  static const String addToFavorites = 'Añadir a Favoritos';
  static const String removeFromFavorites = 'Quitar de Favoritos';

  // Library
  static const String library = 'Biblioteca';
  static const String favorites = 'Favoritos';
  static const String playlists = 'Playlists';
  static const String albums = 'Álbumes';
  static const String history = 'Historial';

  // Search
  static const String search = 'Buscar';
  static const String searchMusic = 'Buscar música terapéutica...';
  static const String noResults = 'No se encontraron resultados';

  // Profile
  static const String profile = 'Perfil';
  static const String settings = 'Configuración';
  static const String subscription = 'Suscripción';
  static const String preferences = 'Preferencias';

  // Subscription
  static const String subscriptionActive = 'Suscripción Activa';
  static const String trialActive = 'Trial Activo';
  static const String choosePlan = 'Elegir Plan';
  static const String monthlyPlan = 'Plan Mensual';
  static const String annualPlan = 'Plan Anual';
  static const String subscribe = 'Suscribirse';
  static const String cancel = 'Cancelar';
  static const String manageSusbcription = 'Gestionar Suscripción';

  // Errors
  static const String errorGeneric = 'Ocurrió un error. Por favor, intenta de nuevo.';
  static const String errorNetwork = 'Error de conexión. Verifica tu internet.';
  static const String errorAuth = 'Sesión expirada. Por favor, inicia sesión de nuevo.';
  static const String errorInvalidCredentials = 'Credenciales inválidas';
  static const String errorSubscriptionRequired = 'Se requiere suscripción activa';

  // Success
  static const String successLogin = 'Inicio de sesión exitoso';
  static const String successRegister = 'Registro exitoso';
  static const String successAddedToFavorites = 'Añadido a favoritos';
  static const String successRemovedFromFavorites = 'Eliminado de favoritos';
  static const String successPlaylistCreated = 'Playlist creada';
}
