import 'package:events_dashboard/models/services/auth_service.dart';
import 'package:events_dashboard/core/routing/routes.dart';
import 'package:events_dashboard/controllers/event_cubit/event_cubit.dart';
import 'package:events_dashboard/controllers/user_cubit/user_cubit.dart';
import 'package:events_dashboard/models/data_models/event_model.dart';
import 'package:events_dashboard/views/add_event_view.dart';
import 'package:events_dashboard/views/home_view.dart';
import 'package:events_dashboard/views/login/ui/login_screen.dart';
import 'package:events_dashboard/views/signup/ui/signup_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation:
        FirebaseAuth.instance.currentUser != null
            ? AppRoutes.homePageScreen
            : AppRoutes.loginScreen,
    routes: [
      GoRoute(
        path: AppRoutes.loginScreen,
        builder:
            (context, state) => BlocProvider(
              create: (context) => AuthCubit(AuthService()),
              child: const LoginScreen(),
            ),
      ),
      GoRoute(
        path: AppRoutes.signUpScreen,
        builder:
            (context, state) => BlocProvider(
              create: (context) => AuthCubit(AuthService()),
              child: const SignUpScreen(),
            ),
      ),
      GoRoute(
        path: AppRoutes.homePageScreen,
        builder:
            (context, state) => BlocProvider(
              create: (context) => EventCubit(),
              child: const HomeView(),
            ),
      ),
      GoRoute(
        path: AppRoutes.addEvent,
        builder:
            (context, state) => BlocProvider(
              create: (context) => EventCubit(),
              child: AddEventView(eventToEdit: state.extra as Event?),
            ),
      ),
    ],
  );
}
