enum Environment { test, prod }

class ApiConfig {
  static const Environment environment = Environment.prod;

  static String get baseUrl {
    switch (environment) {
      case Environment.prod:
        return 'https://49c209c1c882.ngrok-free.app';
      case Environment.test:
        return 'https://49c209c1c882.ngrok-free.app';
    }
  }
}
