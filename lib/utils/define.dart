import 'package:im_flutter_sdk/im_flutter_sdk.dart' as chat;

import 'package:flutter/foundation.dart';

typedef Client = chat.EMClient;
typedef Message = chat.EMMessage;
typedef ChatRoomEventHandler = chat.EMChatRoomEventHandler;
typedef ChatEventHandler = chat.EMChatEventHandler;
typedef ConnectionEventHandler = chat.EMConnectionEventHandler;
typedef MessageEvent = chat.ChatMessageEvent;
typedef ChatError = chat.EMError;
typedef ChatOptions = chat.EMOptions;
typedef UserInfo = chat.EMUserInfo;
typedef ChatRoom = chat.EMChatRoom;
typedef PageResult<T> = chat.EMPageResult<T>;
typedef CursorResult<T> = chat.EMCursorResult<T>;
typedef RoomLeaveReason = chat.LeaveReason;
typedef ChatType = chat.ChatType;
typedef BodyType = chat.MessageType;
typedef TextBody = chat.EMTextMessageBody;
typedef CustomBody = chat.EMCustomMessageBody;
typedef RoomPermissionType = chat.EMChatRoomPermissionType;

vLog(String log) {
  debugPrint("ChatRoomDemo: $log");
}
