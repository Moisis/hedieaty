import 'package:hedieaty/data/models/event.dart';

class EventEntity extends Event{

  String? UserName ;


  EventEntity({
    required super.EventId,
    required super.EventName,
    required super.EventDate,
    required super.EventLocation,
    required super.EventImageUrl,
    required super.EventDescription,
    required super.UserId,
    this.UserName


  });
}


