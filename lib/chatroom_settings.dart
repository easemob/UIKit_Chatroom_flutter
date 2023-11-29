import 'package:chatroom_uikit/chatroom_uikit.dart';

class ChatRoomSettings {
  static String? userDefaultAvatar;
  static String? defaultIdentify;
  static String? defaultGiftIcon;

  static bool enableMsgListTime = true;
  static bool enableMsgListAvatar = true;
  static bool enableMsgListNickname = true;
  static bool enableMsgListIdentify = true;

  static bool enableMsgListGift = false;

  static bool enableParticipantItemIdentify = false;

  static CornerRadius inputBarRadius = CornerRadius.large;
  static CornerRadius avatarRadius = CornerRadius.large;
}
