enum Environment { test, prod }

class ApiConfig {
  static const Environment environment = Environment.prod;

  static String get baseUrl {
    switch (environment) {
      case Environment.prod:
        return 'https://60b105915bda.ngrok-free.app';
      case Environment.test:
        return 'https://60b105915bda.ngrok-free.app';
    }
  }
}
