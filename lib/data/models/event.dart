class Event {
  int? eventId; // Nullable for auto-incrementing ID
  String eventName;
  String eventDate; // Use String for SQLite compatibility
  String? eventLocation;
  String? eventDescription;
  int userId; // Foreign Key

  Event({
    this.eventId,
    required this.eventName,
    required this.eventDate,
    this.eventLocation,
    this.eventDescription,
    required this.userId,
  });

  Map<String, dynamic> toMap() {
    return {
      'EventId': eventId,
      'EventName': eventName,
      'EventDate': eventDate,
      'EventLocation': eventLocation,
      'EventDescription': eventDescription,
      'UserId': userId,
    };
  }

  factory Event.fromMap(Map<String, dynamic> map) {
    return Event(
      eventId: map['EventId'],
      eventName: map['EventName'],
      eventDate: map['EventDate'],
      eventLocation: map['EventLocation'],
      eventDescription: map['EventDescription'],
      userId: map['UserId'],
    );
  }
}
