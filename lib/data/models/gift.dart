
class Gift {

  final String GiftId;
  late final String GiftName;
  late final String GiftDescription;
  final String GiftCat;
  late final double  GiftPrice;
  final String GiftStatus;
  final String GiftEventId;


  Gift({
    required this.GiftId,
    required this.GiftName,
    required this.GiftDescription,
    required this.GiftPrice,
    required this.GiftCat,
    required this.GiftStatus,
    required this.GiftEventId,
  });


  factory Gift.fromJson(Map<String, dynamic> json) {
    return Gift(
      GiftId: json['GiftId'] ?? '',
      GiftName: json['GiftName'] ?? '',
      GiftDescription: json['GiftDescription'],
      GiftPrice: (json['GiftPrice'] as num).toDouble() ,
      GiftCat: json['GiftCat'] ?? '',
      GiftStatus: json['GiftStatus'] ?? '',
      GiftEventId: json['GiftEventId'] ?? '',
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