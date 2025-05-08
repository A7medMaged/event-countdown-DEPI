import 'package:event_app/core/helpers/theming/colors.dart';
import 'package:event_app/core/routing/router.dart';
import 'package:event_app/controllers/event_cubit/event_cubit.dart';
import 'package:event_app/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:google_fonts/google_fonts.dart';

final globalEventCubit = EventCubit();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> requestNotificationPermission() async {
    final bool? result =
        await flutterLocalNotificationsPlugin
            .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin
            >()
            ?.requestNotificationsPermission();
    debugPrint('Notification permission result: $result');
    if (result == null || !result) {
      debugPrint('Notification permission denied');
    } else {
      debugPrint('Notification permission granted');
    }
  }

  await requestNotificationPermission();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  tz.initializeTimeZones();

  await globalEventCubit.loadEvents();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [BlocProvider.value(value: globalEventCubit)],
      child: MaterialApp.router(
        title: 'NextUp',
        routerConfig: AppRouter.router,
        theme: ThemeData.dark().copyWith(
          colorScheme: ColorScheme.fromSwatch().copyWith(
            secondary: secondColor,
          ),
          scaffoldBackgroundColor: black,
          appBarTheme: const AppBarTheme(
            backgroundColor: black,
            iconTheme: IconThemeData(color: secondColor),
            titleTextStyle: TextStyle(
              color: secondColor,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          textTheme: GoogleFonts.exo2TextTheme(ThemeData.dark().textTheme),
        ),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
