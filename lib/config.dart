class Config {
  static const String baseUrl = const String.fromEnvironment(
    'BASE_URL',
    defaultValue: '',
  );
}