class ApiConstants {
  static const String apiKey = String.fromEnvironment(
    'TMDB_API_KEY',
    defaultValue: 'YOUR_TMDB_API_KEY',
  );
  static const String geminiApiKey = String.fromEnvironment(
    'GEMINI_API_KEY',
    defaultValue: 'YOUR_GEMINI_API_KEY',
  );
  static const String baseUrl = 'https://api.themoviedb.org/3';
  static const String geminiUrl = 'https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent';
  static const String imageBaseUrl = 'https://image.tmdb.org/t/p/w500';
  static const String popularPersons = '/person/popular';

  static String personDetails(int id) => '/person/$id';
  static String personImages(int id) => '/person/$id/images';
}
