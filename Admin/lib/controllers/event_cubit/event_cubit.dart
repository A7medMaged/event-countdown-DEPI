import 'package:events_dashboard/models/services/firebase_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';
import '../../models/data_models/event_model.dart';
import 'event_state.dart';

class EventCubit extends Cubit<EventState> {
  final FirestoreService _dbController = FirestoreService();

  EventCubit() : super(EventInitial());

  final uid = FirebaseAuth.instance.currentUser?.uid ?? '';

  Future<void> loadEvents() async {
    emit(EventLoading());
    try {
      final events = await _dbController.getAllEvents();
      emit(EventLoaded(events));
      Logger().w('Successfully loaded events from Firestore: ${events.length}');
    } catch (e) {
      Logger().e('Error adding event to Firestore: $e');

      emit(EventError('Failed to load events: ${e.toString()}'));
    }
  }

  Future<void> addEvent(Event event) async {
    emit(EventLoading());
    try {
      await _dbController.addEvent(event);
      final events = await _dbController.getAllEvents();
      emit(EventLoaded(events));
    } catch (e) {
      Logger().e('Error adding event to Firestore: $e');

      emit(EventError('Failed to add event: ${e.toString()}'));
    }
  }

  Future<void> updateEvent(Event event) async {
    emit(EventLoading());
    Logger().w('Updating event: ${event.toMap()}');
    try {
      await _dbController.updateEvent(event);
      final events = await _dbController.getAllEvents();
      emit(EventLoaded(events));
    } catch (e) {
      emit(EventError('Failed to update event: ${e.toString()}'));
    }
  }

  Future<void> deleteEvent(String id) async {
    emit(EventLoading());
    try {
      await _dbController.deleteEvent(id);
      final events = await _dbController.getAllEvents();
      emit(EventLoaded(events));
    } catch (e) {
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
