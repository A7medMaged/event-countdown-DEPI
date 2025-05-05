import 'package:event_app/core/routing/routes.dart';
import 'package:event_app/main.dart';
import 'package:go_router/go_router.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: AppRoutes.kInitialRoute,
    routes: [
      GoRoute(
        path: AppRoutes.kInitialRoute,
        builder: (context, state) => const MyApp(),
      ),
    ],
  );
}
