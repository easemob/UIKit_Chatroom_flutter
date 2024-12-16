import '../../inner_headers.dart';

/// Gift page controller, you can customize the gift page
abstract class ChatroomGiftPageController {
  /// gift page title
  String get title;

  /// gift list
  List<GiftEntityProtocol> get gifts;

  /// gift will send, you can customize the gift
  GiftEntityProtocol giftWillSend(GiftEntityProtocol gift) {
    return gift;
  }
}
