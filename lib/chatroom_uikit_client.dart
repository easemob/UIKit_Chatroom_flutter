import 'package:chatroom_uikit/chatroom_uikit.dart';

import 'package:flutter/widgets.dart';

class ChatroomUIKitClient {
  static ChatroomUIKitClient? _instance;
  static ChatroomUIKitClient get instance =>
      _instance ??= ChatroomUIKitClient();

  void unInit() {
    _instance?.banders.clear();
    _clearService();
    _instance = null;
  }

  void _clearService() {
    _userService?.dispose();
    _userService = null;
    _giftService?.dispose();
    _giftService = null;
    _chatroomService?.dispose();
    _chatroomService = null;
  }

  final List<ChatroomEventResponse> banders = [];

  UserService? _userService;
  GiftService? _giftService;
  ChatRoomService? _chatroomService;

  UserService get userService => _userService ??= UserServiceImplement();
  set userService(UserService value) {
    _userService = value;
  }

  GiftService get giftService => _giftService ??= GiftServiceImplement();
  set giftService(GiftService value) {
    _giftService = value;
  }

  ChatRoomService get roomService =>
      _chatroomService ??= ChatRoomServiceImplement();
  set roomService(ChatRoomService value) {
    _chatroomService = value;
  }

  Future<void> initWithAppkey(
    String appkey, {
    bool debugMode = false,
    bool autoLogin = false,
  }) async {
    WidgetsFlutterBinding.ensureInitialized();
    final options = ChatOptions(
      appKey: appkey,
      debugModel: debugMode,
      autoLogin: autoLogin,
    );
    await Client.getInstance.init(options);
  }
}

extension GiftServiceAction on ChatroomUIKitClient {
  Future<void> sendGift({
    required String roomId,
    required GiftEntityProtocol gift,
    UserInfoProtocol? user,
  }) async {
    await giftService.sendGift(roomId, gift, user);
  }
}

extension UserServiceAction on ChatroomUIKitClient {
  Future<void> login({
    required String userId,
    required String token,
    UserInfoProtocol? userInfo,
  }) async {
    await userService.login(
      userId: userId,
      token: token,
    );
    updateUserInfo(user: userInfo);
  }

  Future<void> logout() {
    return userService.logout();
  }

  Future<List<UserInfoProtocol>> fetchUserInfos({
    required List<String> userIds,
  }) {
    return userService.fetchUserInfos(userIds: userIds);
  }

  Future<void> updateUserInfo({
    UserInfoProtocol? user,
  }) {
    if (user == null) return Future.value();
    return userService.updateUserInfo(user: user);
  }

  Future<void> refreshToken({required String token}) {
    return Client.getInstance.renewAgoraToken(token);
  }
}

extension ChatRoomServiceAction on ChatroomUIKitClient {
  Future<CursorResult<String>> fetchParticipants(
      String roomId, int pageSize, String cursor) {
    return _checkResult(roomId, RoomEventsType.fetchParticipants, () {
      return Client.getInstance.chatRoomManager.fetchChatRoomMembers(
        roomId,
        cursor: cursor,
        pageSize: pageSize,
      );
    });
  }

  Future<List<String>> fetchMutes(
      String roomId, int pageSize, int pageNum) async {
    return _checkResult(roomId, RoomEventsType.fetchMutes, () {
      return Client.getInstance.chatRoomManager.fetchChatRoomMuteList(
        roomId,
        pageSize: pageSize,
        pageNum: pageNum,
      );
    });
  }

  Future<void> chatroomOperating({
    required String roomId,
    required ChatroomOperationType type,
  }) {
    RoomEventsType event;
    switch (type) {
      case ChatroomOperationType.join:
        event = RoomEventsType.join;
        break;
      case ChatroomOperationType.leave:
        event = RoomEventsType.leave;
        break;
      case ChatroomOperationType.destroyed:
        event = RoomEventsType.destroyed;
        break;
    }

    return _checkResult(roomId, event, () {
      return roomService.chatroomOperating(
        roomId: roomId,
        type: type,
      );
    });
  }

  Future<void> operatingUser({
    required String roomId,
    required ChatroomUserOperationType type,
    required String userId,
  }) {
    RoomEventsType event;

    switch (type) {
      case ChatroomUserOperationType.mute:
        event = RoomEventsType.mute;
        break;
      case ChatroomUserOperationType.unmute:
        event = RoomEventsType.unmute;
        break;
      case ChatroomUserOperationType.kick:
        event = RoomEventsType.kick;
        break;
    }

    return _checkResult(roomId, event, () {
      return roomService.operatingUser(
        roomId: roomId,
        type: type,
        userId: userId,
      );
    });
  }

  Future<void> sendRoomMessage({
    required String roomId,
    required String message,
    List<String>? receiver,
  }) {
    if (message.trim().isEmpty) return Future.value();
    return _checkResult(roomId, RoomEventsType.sendMessage, () {
      final String msg = EmojiMapping.replaceImageToEmoji(message);
      return roomService.sendRoomMessage(
        roomId: roomId,
        message: msg,
        receiver: receiver,
      );
    });
  }

  Future<void> sendCustomMessage({
    required String roomId,
    required String event,
    required Map<String, String> params,
    List<String>? receiver,
  }) {
    return _checkResult(roomId, RoomEventsType.sendMessage, () {
      return roomService.sendCustomMessage(
        roomId: roomId,
        event: event,
        params: params,
        receiver: receiver,
      );
    });
  }

  Future<ChatMessage?> translateMessage({
    required String roomId,
    required ChatMessage message,
    required LanguageCode language,
  }) {
    return _checkResult(roomId, RoomEventsType.translate, () {
      return roomService.translateMessage(
        roomId: roomId,
        message: message,
        language: language,
      );
    });
  }

  Future<void> recall({required String roomId, required ChatMessage message}) {
    return _checkResult(roomId, RoomEventsType.recall, () {
      return roomService.recall(
        roomId: roomId,
        message: message,
      );
    });
  }

  Future<void> report({
    required String roomId,
    required String messageId,
    required String tag,
    required String reason,
  }) {
    return _checkResult(roomId, RoomEventsType.report, () {
      return roomService.report(
        messageId: messageId,
        tag: tag,
        reason: reason,
      );
    });
  }

  Future<T> _checkResult<T>(
    String roomId,
    RoomEventsType type,
    Future<T> Function() method,
  ) async {
    T result;
    try {
      result = await method.call();
      _sendRoomEvent(roomId, type, null);
      return result;
    } on ChatError catch (e) {
      _sendRoomEvent(roomId, type, e);
      rethrow;
    }
  }

  void _sendRoomEvent(String roomId, RoomEventsType event, ChatError? error) {
    for (var element in banders) {
      element.onEventResultChanged(roomId, event, error);
    }
  }
}

extension ControllerBander on ChatroomUIKitClient {
  void bindRoomEventResponse(ChatroomEventResponse controller) {
    if (banders.contains(controller)) return;
    banders.add(controller);
  }

  void unbindRoomEventResponse(ChatroomEventResponse controller) {
    banders.remove(controller);
  }
}

mixin ChatroomEventResponse {
  void onEventResultChanged(
      String roomId, RoomEventsType type, ChatError? error) {}
}
