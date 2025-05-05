class Event {
  final int? id;
  final String title;
  final String description;
  final DateTime eventDate;
  final String userId;

  Event({
    this.id,
    required this.title,
    required this.description,
    required this.eventDate,
    required this.userId,
  });

  // Convert to map for database operations
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'eventDate': eventDate.toIso8601String(),
      'userId': userId,
    };
  }

  // Create from map for database retrieval
  factory Event.fromMap(Map<String, dynamic> map) {
    return Event(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      eventDate: DateTime.parse(map['eventDate']),
      userId: map['userId'],
    );
  }

  // Copy with method for updating events
  Event copyWith({
    int? id,
    String? title,
    String? description,
    DateTime? eventDate,
    required String userId,
  }) {
    return Event(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      eventDate: eventDate ?? this.eventDate,
      userId: userId,
    );
  }
}
