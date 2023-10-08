import 'package:im_flutter_sdk/im_flutter_sdk.dart';

typedef Client = EMClient;
typedef ChatMessage = EMMessage;
typedef RoomEventHandler = EMChatRoomEventHandler;
typedef ChatEventHandler = EMChatEventHandler;
typedef ChatException = EMError;

typedef MarqueeCallback = void Function(String str);
typedef GiftCallback = void Function(String userId, String giftId);

enum ChatroomBeKickedReason { removed, destroyed, offline }

enum ChatroomOperationType { join, leave }

enum ChatroomUserOperationType {
  // addAdministrator,
  // removeAdministrator,
  mute,
  unmute,
  block,
  unblock,
  kick,
}
