// ignore_for_file: use_build_context_synchronously

import 'package:event_app/core/helpers/theming/colors.dart';
import 'package:event_app/core/routing/routes.dart';
import 'package:event_app/models/services/notification_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:logger/logger.dart';
import '../../controllers/event_cubit/event_cubit.dart';
import '../../controllers/event_cubit/event_state.dart';
import '../../models/data_models/event_model.dart';
import 'widgets/countdown_card.dart';
import 'widgets/empty_state.dart';

class EventView extends StatefulWidget {
  const EventView({super.key});

  @override
  State<EventView> createState() => _EventViewState();
}

class _EventViewState extends State<EventView> {
  @override
  void initState() {
    super.initState();
    // Load events when screen opens
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<EventCubit>().loadEvents();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'NextUp',
          style: TextStyle(
            fontFamily:
                GoogleFonts.exo2TextTheme(
                  ThemeData.dark().textTheme,
                ).headlineLarge!.fontFamily,
            fontSize: 32,
          ),
        ),
        backgroundColor: Colors.transparent,
        actions: [
          IconButton(
            onPressed: () => GoRouter.of(context).push(AppRoutes.getEventView),
            icon: Icon(FontAwesomeIcons.globe),
          ),
          IconButton(
            onPressed: () async {
              final FirebaseAuth auth = FirebaseAuth.instance;
              await auth
                  .signOut()
                  .then((_) {
                    var logger = Logger(printer: PrettyPrinter());
                    logger.i('User signed out successfully!');
                  })
                  .catchError((error) {
                    var logger = Logger(printer: PrettyPrinter());
                    logger.e('Error signing out: $error');
                  });
              GoRouter.of(context).pushReplacement(AppRoutes.loginScreen);
            },
            icon: Icon(FontAwesomeIcons.rightFromBracket),
          ),
        ],
      ),
      body: BlocBuilder<EventCubit, EventState>(
        builder: (context, state) {
          if (state is EventInitial || state is EventLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is EventError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 60, color: Colors.red),
                  const SizedBox(height: 16),
                  Text(
                    'Error: ${state.message}',
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.red),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => context.read<EventCubit>().loadEvents(),
                    child: const Text('Try Again'),
                  ),
                ],
              ),
            );
          } else if (state is EventLoaded) {
            final events = state.events;

            if (events.isEmpty) {
              return EmptyState();
            }

            return RefreshIndicator(
              onRefresh: () async {
                await context.read<EventCubit>().loadEvents();
              },
              child: ListView.builder(
                itemCount: events.length,
                itemBuilder: (context, index) {
                  final event = events[index];
                  return CountdownCard(
                    event: event,
                    onDelete: () => _confirmDeleteEvent(event),
                    onEdit: () => _navigateToEditEvent(event),
                    reminderDuration: event.reminderDuration ?? Duration.zero,
                  );
                },
              ),
            );
          }

          return const Center(child: Text('Unknown state'));
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: priamryColor,
        onPressed: _navigateToAddEvent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        label: Text(
          'New countdown',
          style: TextStyle(fontSize: 18, color: secondColor),
        ),
        icon: Container(
          decoration: BoxDecoration(
            color: secondColor,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(Icons.add, color: black, size: 24),
        ),
      ),
    );
  }

  Future<void> refreshEvents() async {
    await context.read<EventCubit>().loadEvents();
  }

  void _navigateToAddEvent() async {
    await context.push(AppRoutes.addEvent);
    // Refresh events when returning from add screen
    refreshEvents();
  }

  void _navigateToEditEvent(Event event) async {
    await context.push(AppRoutes.addEvent, extra: event);
    // Refresh events when returning from edit screen
    refreshEvents();
  }

  void _confirmDeleteEvent(Event event) {
    showDialog(
      context: context,
      builder:
          (dialogContext) => AlertDialog(
            backgroundColor: Colors.grey[900],
            title: const Text('Delete Event'),
            content: Text('Are you sure you want to delete "${event.title}"?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(dialogContext),
                child: Text('Cancel', style: TextStyle(color: white)),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  backgroundColor: Colors.red,
                ),
                onPressed: () async {
                  if (event.id != null) {
                    final notificationService = NotificationService(
                      FlutterLocalNotificationsPlugin(),
                    );
                    await notificationService.cancelEventNotifications(
                      event.id!,
                    );
                    context.read<EventCubit>().deleteEvent(event.id!);
                    GoRouter.of(context).pop(dialogContext);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Cannot delete event with null ID'),
                      ),
                    );
                    Navigator.pop(dialogContext);
                  }
                },
                child: Text('Delete', style: TextStyle(color: white)),
              ),
            ],
          ),
    );
  }
}
