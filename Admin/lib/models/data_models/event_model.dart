import 'package:cloud_firestore/cloud_firestore.dart';

class Event {
  String? id;
  final String title;
  final String description;
  final DateTime eventDate;

  Event({this.id, required this.title, required this.description, required this.eventDate});

  // Convert to map for database operations
  Map<String, dynamic> toMap() {
    return {'id': id, 'title': title, 'description': description, 'eventDate': eventDate.toIso8601String()};
  }

  // Create from map for database retrieval
  factory Event.fromMap(Map<String, dynamic> map) {
    return Event(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      eventDate:
          map['eventDate'] is Timestamp
              ? (map['eventDate'] as Timestamp).toDate()
              : DateTime.parse(map['eventDate'].toString()),
    );
  }

  // Copy with method for updating events
  Event copyWith({String? id, String? title, String? description, DateTime? eventDate, required String userId}) {
    return Event(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      eventDate: eventDate ?? this.eventDate,
    );
  }
}
