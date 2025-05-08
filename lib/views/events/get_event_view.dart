// ignore_for_file: use_build_context_synchronously

import 'package:event_app/controllers/get_event_cubit/get_event_cubit.dart';
import 'package:event_app/controllers/get_event_cubit/get_event_state.dart';
import 'package:event_app/views/events/widgets/get_countdown_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'widgets/empty_state.dart';

class GetEventView extends StatefulWidget {
  const GetEventView({super.key});

  @override
  State<GetEventView> createState() => _GetEventViewState();
}

class _GetEventViewState extends State<GetEventView> {
  @override
  void initState() {
    super.initState();
    // Load events when screen opens
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<GetEventCubit>().loadEvents();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Remote Reminders',
          style: TextStyle(
            fontFamily:
                GoogleFonts.exo2TextTheme(
                  ThemeData.dark().textTheme,
                ).headlineLarge!.fontFamily,
            fontSize: 28,
          ),
        ),
        backgroundColor: Colors.transparent,
      ),
      body: BlocBuilder<GetEventCubit, GetEventState>(
        buildWhen:
            (previous, current) =>
                current is GetEventLoaded ||
                current is GetEventError ||
                current is GetEventLoading,
        builder: (context, state) {
          if (state is GetEventLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is GetEventError) {
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
                    onPressed: () => context.read<GetEventCubit>().loadEvents(),
                    child: const Text('Try Again'),
                  ),
                ],
              ),
            );
          } else if (state is GetEventLoaded) {
            final events = state.events;

            if (events.isEmpty) {
              return EmptyState();
            }

            return RefreshIndicator(
              onRefresh: () async {
                await context.read<GetEventCubit>().loadEvents();
              },
              child: ListView.builder(
                itemCount: events.length,
                itemBuilder: (context, index) {
                  final event = events[index];
                  return GetCountdownCard(event: event);
                },
              ),
            );
          }

          return const Center(child: Text('Unknown state'));
        },
      ),
    );
  }

  Future<void> refreshEvents() async {
    await context.read<GetEventCubit>().loadEvents();
  }
}
