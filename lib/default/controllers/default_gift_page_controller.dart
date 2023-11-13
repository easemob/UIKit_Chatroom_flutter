import 'package:chatroom_uikit/chatroom_uikit.dart';

class DefaultGiftPageController extends ChatRoomGiftPageController {
  @override
  final String title;

  @override
  final List<GiftEntityProtocol> gifts;

  DefaultGiftPageController({
    required this.title,
    required this.gifts,
  });
}
