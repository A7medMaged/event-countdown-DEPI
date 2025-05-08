import 'package:event_app/models/services/notification_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../../models/services/database_service.dart';
import '../../models/data_models/event_model.dart';
import 'event_state.dart';

class EventCubit extends Cubit<EventState> {
  final DatabaseService _dbController = DatabaseService.instance;

  EventCubit() : super(EventInitial());

  String get uid => FirebaseAuth.instance.currentUser?.uid ?? '';

  Future<void> loadEvents() async {
    if (isClosed) return;
    emit(EventLoading());

    try {
      debugPrint('Loading events for user: $uid');
      final events = await _dbController.getAllEvents(uid);
      debugPrint('Loaded ${events.length} events from local database');
      if (isClosed) return;
      emit(EventLoaded(events));
    } catch (e) {
      debugPrint('Error loading events: $e');
      if (isClosed) return;
      emit(EventError('Failed to load events: ${e.toString()}'));
    }
  }

  Future<void> addEvent(Event event) async {
    if (isClosed) return;
    emit(EventLoading());

    try {
      final localId = await _dbController.createEvent(event);
      debugPrint('Added event to local DB with ID: $localId');
      final events = await _dbController.getAllEvents(uid);

      if (isClosed) return;
      emit(EventLoaded(events));
    } catch (e) {
      debugPrint('Error adding event: $e');
      if (isClosed) return;
      emit(EventError('Failed to add event: ${e.toString()}'));
    }
  }

  Future<void> updateEvent(Event event) async {
    if (isClosed) return;
    emit(EventLoading());

    try {
      await _dbController.updateEvent(event);
      debugPrint('Updated event in local DB: ${event.id}');

      final events = await _dbController.getAllEvents(uid);

      if (isClosed) return;
      emit(EventLoaded(events));
    } catch (e) {
      debugPrint('Error updating event: $e');
      if (isClosed) return;
      emit(EventError('Failed to update event: ${e.toString()}'));
    }
  }

  Future<void> deleteEvent(int id) async {
    if (isClosed) return;
    emit(EventLoading());

    try {
      final notificationService = NotificationService(
        FlutterLocalNotificationsPlugin(),
      );
      await notificationService.cancelEventNotifications(id);
      await _dbController.deleteEvent(id);
      debugPrint('Deleted event from local DB: $id');

      final events = await _dbController.getAllEvents(uid);

      if (isClosed) return;
      emit(EventLoaded(events));
    } catch (e) {
      debugPrint('Error deleting event: $e');
      if (isClosed) return;
      emit(EventError('Failed to delete event: ${e.toString()}'));
    }
  }

  Duration getRemainingTime(Event event) {
    final now = DateTime.now();
    if (event.eventDate.isBefore(now)) {
      return Duration.zero;
    }
    return event.eventDate.difference(now);
  }
}
