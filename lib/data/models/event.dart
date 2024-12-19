


class Event   {


  final String EventId;
  final String EventName;
  final String EventDate;
  final String EventLocation;
  final String EventImageUrl;
  final String EventDescription;
  final String UserId;

  Event({
    required this.EventId,
    required this.EventName,
    required this.EventDate,
    required this.EventLocation,
    required this.EventImageUrl,
    required this.EventDescription,
    required this.UserId,
  });

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      EventId: json['EventId'],
      EventName: json['EventName'],
      EventDate : json['EventDate'],
      EventLocation: json['EventLocation'],
      EventImageUrl: json['EventImageUrl'],
      EventDescription: json['EventDescription'],
      UserId: json['UserId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'EventId': EventId,
      'EventName': EventName,
      'EventDate': EventDate,
      'EventLocation': EventLocation,
      'EventImageUrl': EventImageUrl,
      'EventDescription': EventDescription,
      'UserId': UserId,
    };
  }
}