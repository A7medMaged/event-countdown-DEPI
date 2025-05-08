import 'package:event_app/controllers/auth_cubit/user_cubit.dart';
import 'package:event_app/controllers/get_event_cubit/get_event_cubit.dart';
import 'package:event_app/models/services/auth_service.dart';
import 'package:event_app/core/routing/routes.dart';
import 'package:event_app/controllers/event_cubit/event_cubit.dart';
import 'package:event_app/models/data_models/event_model.dart';
import 'package:event_app/views/events/add_event_view.dart';
import 'package:event_app/views/events/get_event_view.dart';
import 'package:event_app/views/events/event_view.dart';
import 'package:event_app/views/login/login_screen.dart';
import 'package:event_app/views/signup/signup_screen.dart';
import 'package:event_app/views/splash_screen/splash_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    routes: [
      GoRoute(path: '/', builder: (context, state) => const SplashScreen()),
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
        path: AppRoutes.eventView,
        builder:
            (context, state) => BlocProvider(
              create: (context) => EventCubit(),
              child: const EventView(),
            ),
      ),
      GoRoute(
        path: AppRoutes.getEventView,
        builder:
            (context, state) => BlocProvider(
              create: (context) => GetEventCubit(),
              child: const GetEventView(),
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
