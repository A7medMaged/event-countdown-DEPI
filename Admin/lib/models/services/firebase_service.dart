import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import '../../models/data_models/event_model.dart';

class FirestoreService {
  final FirebaseFirestore _firestore;

  static final FirestoreService _instance = FirestoreService._internal();

  factory FirestoreService() => _instance;

  FirestoreService._internal() : _firestore = FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get _eventsCollection => _firestore.collection('events');

  Future<List<Event>> getAllEvents() async {
    try {
      debugPrint('Fetching events from Firestore...');

      final querySnapshot = await _eventsCollection.get();
      final events = querySnapshot.docs.map((doc) => Event.fromMap(doc.data())).toList();

      debugPrint('Successfully fetched ${events.length} events from Firestore');
      return events;
    } catch (e) {
      debugPrint('Error fetching events from Firestore: $e');
      rethrow;
    }
  }

  Future<void> addEvent(Event event) async {
    try {
      debugPrint('Adding event to Firestore: ${event.title}');

      final firestoreData = {
        'id': event.id,
        'title': event.title,
        'description': event.description,
        'eventDate': Timestamp.fromDate(event.eventDate),
      };

      final value = await _eventsCollection.add(firestoreData);
      await _eventsCollection.doc(value.id).set({'id': value.id}, SetOptions(merge: true));
      debugPrint('Successfully added event to Firestore with ID: ${event.id}');
    } catch (e) {
      Logger().e('Error adding event to Firestore: $e');
      rethrow;
    }
  }

  Future<void> updateEvent(Event event) async {
    try {
      debugPrint('Updating event in Firestore: ${event.id}');

      if (event.id == null) {
        throw Exception('Cannot update event with null ID');
      }

      final docId = event.id;

      final docSnapshot = await _eventsCollection.doc(docId).get();

      if (docSnapshot.exists) {
        await _eventsCollection.doc(docId).update({
          'title': event.title,
          'description': event.description,
          'eventDate': Timestamp.fromDate(event.eventDate),
        });
        debugPrint('Successfully updated event in Firestore: $docId');
      } else {
        await addEvent(event);
      }
    } catch (e) {
      debugPrint('Error updating event in Firestore: $e');
      rethrow;
    }
  }

  Future<void> deleteEvent(String eventId) async {
    try {
      debugPrint('Deleting event from Firestore: $eventId');

      final stringId = eventId.toString();

      await _eventsCollection.doc(stringId).delete();
      debugPrint('Successfully deleted event from Firestore: $stringId');
    } catch (e) {
      debugPrint('Error deleting event from Firestore: $e');
      rethrow;
    }
  }
}
