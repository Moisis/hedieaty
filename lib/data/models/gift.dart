import 'package:hedieaty/domain/entities/gift_entity.dart';

class Gift extends GiftEntity{
  Gift({required super.GiftId,
    required super.GiftName,
    required super.GiftDescription,
    required super.GiftPrice,
    required super.GiftCat,
    required super.GiftStatus,
    required super.GiftEventId
  });

  factory Gift.fromJson(Map<String, dynamic> json) {
    return Gift(
      GiftId: json['GiftId'],
      GiftName: json['GiftName'],
      GiftDescription: json['GiftDescription'],
      GiftPrice: json['GiftPrice'],
      GiftCat: json['GiftCat'],
      GiftStatus: json['GiftStatus'],
      GiftEventId: json['GiftEventId'],
    );
  }


  Map<String, dynamic> toJson() {
    return {
      'GiftId': GiftId,
      'GiftName': GiftName,
      'GiftDescription': GiftDescription,
      'GiftPrice': GiftPrice,
      'GiftCat': GiftCat,
      'GiftStatus': GiftStatus,
      'GiftEventId': GiftEventId,
    };
  }



}