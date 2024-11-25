class Gift {
  int? giftId; // Nullable for auto-incrementing ID
  String giftName;
  String? giftDescription;
  String? giftCat;
  double? giftPrice;
  String? giftStatus;
  int? giftEventId; // Foreign Key

  Gift({
    this.giftId,
    required this.giftName,
    this.giftDescription,
    this.giftCat,
    this.giftPrice,
    this.giftStatus,
    this.giftEventId,
  });

  Map<String, dynamic> toMap() {
    return {
      'GiftId': giftId,
      'GiftName': giftName,
      'GiftDescription': giftDescription,
      'GiftCat': giftCat,
      'GiftPrice': giftPrice,
      'GiftStatus': giftStatus,
      'GiftEventId': giftEventId,
    };
  }

  factory Gift.fromMap(Map<String, dynamic> map) {
    return Gift(
      giftId: map['GiftId'],
      giftName: map['GiftName'],
      giftDescription: map['GiftDescription'],
      giftCat: map['GiftCat'],
      giftPrice: map['GiftPrice'],
      giftStatus: map['GiftStatus'],
      giftEventId: map['GiftEventId'],
    );
  }
}
