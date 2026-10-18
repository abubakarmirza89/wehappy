class AppConfig {
  const AppConfig._();

  static const apiBaseUrl = String.fromEnvironment(
    'https://hearteli.com',
    defaultValue: 'https://hearteli.com',
  );

  static const appName = 'Hearteli';
}
