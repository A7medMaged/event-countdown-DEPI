import 'package:cloud_firestore/cloud_firestore.dart';

class GetEventModel {
  final String? id;
  final String title;
  final String description;
  final DateTime eventDate;

  GetEventModel({
    this.id,
    required this.title,
    required this.description,
    required this.eventDate,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'eventDate': eventDate.toIso8601String(),
    };
  }

  factory GetEventModel.fromMap(Map<String, dynamic> map) {
    return GetEventModel(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      eventDate:
          map['eventDate'] is Timestamp
              ? (map['eventDate'] as Timestamp).toDate()
              : DateTime.parse(map['eventDate'].toString()),
    );
  }

  GetEventModel copyWith({
    int? id,
    String? title,
    String? description,
    DateTime? eventDate,
    Duration? reminderDuration,
    required String userId,
  }) {
    return GetEventModel(
      id: id?.toString(),
      title: title ?? this.title,
      description: description ?? this.description,
      eventDate: eventDate ?? this.eventDate,
    );
  }
}
