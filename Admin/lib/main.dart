import 'package:events_dashboard/controllers/event_cubit/event_cubit.dart';
import 'package:events_dashboard/core/helpers/theming/colors.dart';
import 'package:events_dashboard/core/routing/router.dart';
import 'package:events_dashboard/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => EventCubit(),
      child: MaterialApp.router(
        title: 'Event Countdown Admin Dashboard',
        routerConfig: AppRouter.router,
        theme: ThemeData(brightness: Brightness.dark, colorSchemeSeed: secondColor, scaffoldBackgroundColor: black),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
