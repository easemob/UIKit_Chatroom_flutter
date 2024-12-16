import '../../inner_headers.dart';

abstract class GiftService {
  /// Bind user state changed listener
  /// - Parameter listener: UserStateChangedListener
  void bindResponse(GiftResponse response);

  /// Unbind user state changed listener
  /// - Parameter listener: UserStateChangedListener
  void unbindResponse(GiftResponse response);

  /// Send gift.
  /// - Parameters:
  ///   - gift: ``GiftEntityProtocol``
  ///   - completion: Callback,what if success or error.
  Future<void> sendGift(
    String roomId,
    GiftEntityProtocol gift,
    UserInfoProtocol? user,
  );

  void dispose();

  GiftEntityProtocol? giftFromJson(Map<String, dynamic>? json);
  Map<String, dynamic>? giftToJson(GiftEntityProtocol? giftEntityProtocol);
}

mixin GiftResponse {
  void receiveGift(
    String roomId,
    Message msg,
  );
}

abstract class GiftEntityProtocol {
  /// Gift ID
  String get giftId;

  /// Gift name
  String get giftName;

  /// Gift price`
  String get giftPrice;

  /// Gift icon
  String get giftIcon;

  /// Gift effect
  String? get giftEffect;

  int get count;
}
