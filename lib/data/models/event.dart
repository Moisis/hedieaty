import 'package:hedieaty/domain/entities/event_entity.dart';



class Event extends EventEntity {
  Event({
    required super.EventId,
    required super.EventName,
    required super.EventDate,
    required super.EventLocation,
    required super.EventDescription,
    required super.UserId,
  });

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      EventId: json['EventId'],
      EventName: json['EventName'],
      EventDate : json['EventDate'],
      EventLocation: json['EventLocation'],
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
      'EventDescription': EventDescription,
      'UserId': UserId,
    };
  }
}