import 'package:chatroom_uikit/service/protocol/gift_service.dart';

abstract class ChatRoomGiftPageController {
  String get title;
  List<GiftEntityProtocol> get gifts;

  GiftEntityProtocol giftWillSend(GiftEntityProtocol gift) {
    return gift;
  }
}
