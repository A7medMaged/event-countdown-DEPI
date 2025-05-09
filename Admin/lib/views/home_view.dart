import 'package:events_dashboard/core/helpers/theming/colors.dart';
import 'package:events_dashboard/core/routing/routes.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:logger/logger.dart';
import '../controllers/event_cubit/event_cubit.dart';
import '../controllers/event_cubit/event_state.dart';
import '../models/data_models/event_model.dart';
import 'widgets/countdown_card.dart';
import 'widgets/empty_state.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  void initState() {
    super.initState();
    context.read<EventCubit>().loadEvents();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Reload data whenever returning to this screen
    context.read<EventCubit>().loadEvents();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text(
          'Event Countdown',
          style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: secondColor),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(FontAwesomeIcons.rightFromBracket, color: secondColor),
            onPressed: () {
              FirebaseAuth.instance.signOut().then((_) {
                context.pushReplacement(AppRoutes.loginScreen);
              });
            },
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
                    onDelete: () {
                      Logger().i('Delete button pressed for event: ${event.id}');
                      _confirmDeleteEvent(event);
                    },
                    onEdit: () => _navigateToEditEvent(event),
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
        label: Text('New countdown', style: TextStyle(fontSize: 18, color: secondColor)),
        icon: Container(
          decoration: BoxDecoration(color: secondColor, borderRadius: BorderRadius.circular(8)),
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
            title: const Text('Delete Event'),
            content: Text('Are you sure you want to delete "${event.title}"?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(dialogContext),
                child: Text('Cancel', style: TextStyle(color: white)),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  backgroundColor: Colors.red,
                ),
                onPressed: () {
                  Logger().e('Delete button pressed for event: ${event.id}');

                  if (event.id != null) {
                    // Use the correct context (from the widget, not dialog)
                    context.read<EventCubit>().deleteEvent(event.id!);
                    // Close the dialog
                    GoRouter.of(context).pop(dialogContext);
                  } else {
                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(const SnackBar(content: Text('Cannot delete event with null ID')));
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
