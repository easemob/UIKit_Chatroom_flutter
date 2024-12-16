import 'dart:convert';

import '../../inner_headers.dart';


extension PutWithoutNull on Map<String, dynamic> {
  void putIfNotNull(String key, dynamic value) {
    if (value != null) {
      this[key] = value;
    }
  }
}

extension Notify on Message {
  bool isJoinNotify() {
    if (body.type == BodyType.CUSTOM) {
      if (ChatRoomUIKitEvent.userJoinEvent == (body as CustomBody).event) {
        return true;
      }
    }
    return false;
  }
}

extension GlobalNotify on Message {
  bool isGlobalNotify() {
    return isBroadcast;
  }
}

extension Gift on Message {
  bool isGiftMsg() {
    if (body.type == BodyType.CUSTOM) {
      return (body as CustomBody).event == ChatRoomUIKitEvent.giftEvent;
    } else {
      return false;
    }
  }

  GiftEntityProtocol? getGiftEntity() {
    GiftEntityProtocol? ret;
    do {
      if (body.type != BodyType.CUSTOM) break;
      if ((body as CustomBody).event != ChatRoomUIKitEvent.giftEvent) break;
      if ((body as CustomBody).params == null) break;
      if (!(body as CustomBody).params!.containsKey(ChatRoomUIKitEvent.gift)) {
        break;
      }
      String? jString = (body as CustomBody).params![ChatRoomUIKitEvent.gift];
      final map = json.decode(jString!);
      ret = ChatroomUIKitClient.instance.giftService.giftFromJson(map);
    } while (false);

    return ret;
  }
}

extension UserInfo on Message {
  void addUserEntity() {
    UserInfoProtocol? userInfo =
        ChatroomContext.instance.userInfosMap[Client.getInstance.currentUserId];
    if (userInfo != null) {
      Map<String, dynamic>? map =
          ChatroomUIKitClient.instance.userService.userToJson(userInfo);
      if (map?.isNotEmpty == true) {
        attributes ??= {};
        attributes![ChatRoomUIKitEvent.userInfo] = map;
      }
    }
  }

  UserInfoProtocol? getUserEntity() {
    Map<String, dynamic>? map = attributes?[ChatRoomUIKitEvent.userInfo];
    if (map != null) {
      UserInfoProtocol? userInfo =
          ChatroomUIKitClient.instance.userService.userFromJson(map);
      return userInfo;
    } else {
      return null;
    }
  }
}
