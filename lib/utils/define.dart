import 'package:im_flutter_sdk/im_flutter_sdk.dart';

import 'package:flutter/foundation.dart';

typedef Client = EMClient;
typedef ChatMessage = EMMessage;
typedef ChatRoomEventHandler = EMChatRoomEventHandler;
typedef ChatEventHandler = EMChatEventHandler;
typedef ConnectionEventHandler = EMConnectionEventHandler;
typedef MessageEvent = ChatMessageEvent;
typedef ChatError = EMError;
typedef ChatOptions = EMOptions;
typedef UserInfo = EMUserInfo;
typedef ChatRoom = EMChatRoom;
typedef PageResult<T> = EMPageResult<T>;
typedef CursorResult<T> = EMCursorResult<T>;
typedef RoomLeaveReason = LeaveReason;
typedef MsgType = ChatType;
typedef BodyType = MessageType;
typedef TextBody = EMTextMessageBody;
typedef CustomBody = EMCustomMessageBody;
typedef RoomPermission = EMChatRoomPermissionType;

vLog(String log) {
  debugPrint("ChatRoomDemo: $log");
}
