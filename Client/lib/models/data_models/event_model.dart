class Event {
  final int? id;
  final String title;
  final String description;
  final DateTime eventDate;
  final Duration? reminderDuration;
  final String userId;

  Event({
    this.id,
    required this.title,
    required this.description,
    required this.eventDate,
    required this.reminderDuration,
    required this.userId,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'eventDate': eventDate.toIso8601String(),
      'reminderDuration': reminderDuration?.inSeconds,
      'userId': userId,
    };
  }

  factory Event.fromMap(Map<String, dynamic> map) {
    return Event(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      eventDate: DateTime.parse(map['eventDate']),
      userId: map['userId'],
      reminderDuration:
          map['reminderDuration'] != null
              ? Duration(seconds: map['reminderDuration'])
              : null,
    );
  }

  Event copyWith({
    int? id,
    String? title,
    String? description,
    DateTime? eventDate,
    Duration? reminderDuration,
    required String userId,
  }) {
    return Event(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      eventDate: eventDate ?? this.eventDate,
      reminderDuration: reminderDuration ?? this.reminderDuration,

      userId: userId,
    );
  }
}
