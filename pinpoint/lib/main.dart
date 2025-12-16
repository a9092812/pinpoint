import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pinpoint/repository/location_services/location_services.dart';
import 'package:pinpoint/repository/storage/appStorage.dart';
import 'package:pinpoint/resources/routes/go_router_config.dart';
import 'package:pinpoint/resources/theme/app_theme.dart';
import 'package:pinpoint/view/users/route_screen.dart';
 
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final locationService = LocationService();
 
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(goRouterProvider);

    return MaterialApp.router(
      title: 'Pinpoint',
      theme: AppTheme.lightTheme,
      routerConfig: router,
      // home: RouteScreen(),
    );
  }
}
