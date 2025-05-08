import 'package:event_app/controllers/get_event_cubit/get_event_state.dart';
import 'package:event_app/models/services/firestore_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GetEventCubit extends Cubit<GetEventState> {
  final FirestoreService _firestoreService = FirestoreService();

  GetEventCubit() : super(GetEventInitial());

  String get uid => FirebaseAuth.instance.currentUser?.uid ?? '';

  Future<void> loadEvents() async {
    if (isClosed) return;
    emit(GetEventLoading());

    try {
      debugPrint('Loading events for user: $uid');
      final events = await _firestoreService.getAllEvents();
      debugPrint('Loaded ${events.length} events from local database');
      if (isClosed) return;
      emit(GetEventLoaded(events));
    } catch (e) {
      debugPrint('Error loading events: $e');
      if (isClosed) return;
      emit(GetEventError('Failed to load events: ${e.toString()}'));
    }
  }
}
