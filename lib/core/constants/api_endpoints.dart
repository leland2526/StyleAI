class ApiEndpoints {
  // Supabase
  static const String supabaseUrl = String.fromEnvironment(
    'SUPABASE_URL',
    defaultValue: '',
  );

  static const String supabaseAnonKey = String.fromEnvironment(
    'SUPABASE_ANON_KEY',
    defaultValue: '',
  );

  // OpenAI
  static const String openAiKey = String.fromEnvironment(
    'OPENAI_API_KEY',
    defaultValue: '',
  );

  // Weather API (OpenWeather)
  static const String weatherApiKey = String.fromEnvironment(
    'OPENWEATHER_API_KEY',
    defaultValue: '',
  );

  static const String weatherBaseUrl = 'https://api.openweathermap.org/data/2.5';

  // Supabase Edge Functions
  static String analyzeImage() => '$supabaseUrl/functions/v1/analyze-image';
  static String recommendOutfit() => '$supabaseUrl/functions/v1/recommend-outfit';
}
