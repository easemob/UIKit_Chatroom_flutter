import '../../../inner_headers.dart';

class GiftEntity extends GiftEntityProtocol {
  GiftEntity({
    required this.giftId,
    required this.giftName,
    required this.giftIcon,
    required this.giftPrice,
    required this.giftEffect,
    this.count = 1,
  });

  GiftEntity.fromJson(Map<String, dynamic> map)
      : giftId = map['giftId']!,
        giftName = map['giftName']!,
        giftIcon = map['giftIcon']!,
        giftPrice = map['giftPrice'],
        giftEffect = map['giftEffect'],
        count = map['count'] ?? 1;

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {};
    map.putIfNotNull('giftId', giftId);
    map.putIfNotNull('giftName', giftName);
    map.putIfNotNull('giftIcon', giftIcon);
    map.putIfNotNull('giftPrice', giftPrice);
    map.putIfNotNull('giftEffect', giftEffect);
    map.putIfNotNull('count', count);

    return map;
  }

  @override
  final String giftId;
  @override
  final String giftName;
  @override
  final String giftIcon;
  @override
  final String giftPrice;
  @override
  final String? giftEffect;
  @override
  final int count;
}
