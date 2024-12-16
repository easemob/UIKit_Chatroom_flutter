import 'utils/chatroom_enums.dart';

class ChatRoomSettings {
  /// Default display avatar
  static String? userDefaultAvatar;

  /// Default identity icon
  static String? defaultIdentify;

  /// Default gift icon
  static String? defaultGiftIcon;

  /// Default gift icon
  static String? defaultGiftPriceIcon;

  /// Whether to display time in the message list
  static bool enableMsgListTime = true;

  /// Whether to display avatar in the message list
  static bool enableMsgListAvatar = true;

  /// Whether to display nickname in the message list
  static bool enableMsgListNickname = true;

  /// Whether to display identity in the message list
  static bool enableMsgListIdentify = true;

  /// Whether to display gift in the message list
  static bool enableMsgListGift = false;

  /// Whether to display identity in the participant list
  static bool enableParticipantItemIdentify = false;

  /// Input component corner radius
  static CornerRadius inputBarRadius = CornerRadius.large;

  /// Avatar corner radius
  static CornerRadius avatarRadius = CornerRadius.large;

  static String? reportTitle;

  /// report message reason
  static Map<String, String>? reportMap;
}
