import 'package:cubix_app/core/services/api_client.dart';
import 'package:cubix_app/features/home/data/home_services.dart';
import 'package:get_it/get_it.dart';

final GetIt locator = GetIt.instance;

Future<void> initServices() async {
  locator.registerSingleton<ApiClient>(ApiClient());
  locator.registerSingleton<HomeServices>(
    HomeServices(apiClient: locator.get<ApiClient>()),
  );
}
