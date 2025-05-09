import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:event_app/models/data_models/get_event_model.dart';
import 'package:flutter/material.dart';

class FirestoreService {
  final FirebaseFirestore _firestore;

  static final FirestoreService _instance = FirestoreService._internal();

  factory FirestoreService() => _instance;

  FirestoreService._internal() : _firestore = FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get _eventsCollection =>
      _firestore.collection('events');

  Future<List<GetEventModel>> getAllEvents() async {
    try {
      debugPrint('Fetching events from Firestore...');

      final querySnapshot = await _eventsCollection.get();
      final events =
          querySnapshot.docs
              .map((doc) => GetEventModel.fromMap(doc.data()))
              .toList();

      debugPrint('Successfully fetched ${events.length} events from Firestore');
      return events;
    } catch (e) {
      debugPrint('Error fetching events from Firestore: $e');
      rethrow;
    }
  }
}
