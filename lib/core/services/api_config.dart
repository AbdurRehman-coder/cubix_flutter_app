enum Environment { test, prod }

class ApiConfig {
  static const Environment environment = Environment.prod;

  static String get baseUrl {
    switch (environment) {
      case Environment.prod:
        return 'https://f7fed5bb0efb.ngrok-free.app';
      case Environment.test:
        return 'https://f7fed5bb0efb.ngrok-free.app';
    }
  }
}
