import 'package:flutter/foundation.dart';
import 'package:im_flutter_sdk/im_flutter_sdk.dart' as chat;

typedef Client = chat.EMClient;
typedef Message = chat.EMMessage;
typedef ChatRoomEventHandler = chat.EMChatRoomEventHandler;
typedef ChatEventHandler = chat.EMChatEventHandler;
typedef ConnectionEventHandler = chat.EMConnectionEventHandler;
typedef MessageEvent = chat.ChatMessageEvent;
typedef ChatError = chat.EMError;
typedef ChatOptions = chat.EMOptions;
typedef ChatUserInfo = chat.EMUserInfo;
typedef ChatRoom = chat.EMChatRoom;
typedef PageResult<T> = chat.EMPageResult<T>;
typedef CursorResult<T> = chat.EMCursorResult<T>;
typedef RoomLeaveReason = chat.LeaveReason;
typedef ChatType = chat.ChatType;
typedef BodyType = chat.MessageType;
typedef TextBody = chat.EMTextMessageBody;
typedef CustomBody = chat.EMCustomMessageBody;
typedef RoomPermissionType = chat.EMChatRoomPermissionType;
typedef MessageDirection = chat.MessageDirection;
typedef LoginExtensionInfo = chat.LoginExtensionInfo;
typedef MessagePinOperation = chat.MessagePinOperation;
typedef MessagePinInfo = chat.MessagePinInfo;

// import 'package:agora_chat_sdk/agora_chat_sdk.dart' as chat;

// typedef Client = chat.ChatClient;
// typedef Message = chat.ChatMessage;
// typedef ChatRoomEventHandler = chat.ChatRoomEventHandler;
// typedef ChatEventHandler = chat.ChatEventHandler;
// typedef ConnectionEventHandler = chat.ConnectionEventHandler;
// typedef MessageEvent = chat.ChatMessageEvent;
// typedef ChatError = chat.ChatError;
// typedef ChatOptions = chat.ChatOptions;
// typedef ChatUserInfo = chat.ChatUserInfo;
// typedef ChatRoom = chat.ChatRoom;
// typedef PageResult<T> = chat.ChatPageResult<T>;
// typedef CursorResult<T> = chat.ChatCursorResult<T>;
// typedef RoomLeaveReason = chat.LeaveReason;
// typedef ChatType = chat.ChatType;
// typedef BodyType = chat.MessageType;
// typedef TextBody = chat.ChatTextMessageBody;
// typedef CustomBody = chat.ChatCustomMessageBody;
// typedef RoomPermissionType = chat.ChatRoomPermissionType;
// typedef MessageDirection = chat.MessageDirection;
// typedef MessagePinOperation = chat.MessagePinOperation;
// typedef MessagePinInfo = chat.MessagePinInfo;

vLog(String log) {
  debugPrint("ChatRoomDemo: $log");
}
