import 'package:cubix_app/core/services/api_client.dart';
import 'package:cubix_app/core/services/apple_auth_services.dart';
import 'package:cubix_app/core/services/google_auth_services.dart';
import 'package:cubix_app/core/services/shared_prefs_services.dart';
import 'package:cubix_app/features/auth/services/auth_services.dart';
import 'package:cubix_app/features/home/data/home_services.dart';
import 'package:cubix_app/features/lessons/data/progress_services.dart';
import 'package:get_it/get_it.dart';

final GetIt locator = GetIt.instance;

Future<void> initServices() async {
  final sharedPrefService = await SharedPrefServices.getInstance();
  locator.registerSingleton<SharedPrefServices>(sharedPrefService);
  locator.registerSingleton<ApiClient>(ApiClient());
  locator.registerSingleton<GoogleAuthService>(GoogleAuthService());
  locator.registerSingleton<AppleAuthServices>(AppleAuthServices());

  locator.registerSingleton<AuthServices>(
    AuthServices(
      apiClient: locator.get<ApiClient>(),
      googleAuthService: locator.get<GoogleAuthService>(),
      appleAuthServices: locator.get<AppleAuthServices>(),
      localDBServices: locator.get<SharedPrefServices>(),
    ),
  );

  locator.registerSingleton<HomeServices>(
    HomeServices(apiClient: locator.get<ApiClient>()),
  );

  locator.registerSingleton<ProgressServices>(
    ProgressServices(apiClient: locator.get<ApiClient>()),
  );
}
