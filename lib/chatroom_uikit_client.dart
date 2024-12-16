import 'inner_headers.dart';

import 'package:flutter/widgets.dart';





class ChatroomUIKitClient {
  static ChatroomUIKitClient? _instance;
  static ChatroomUIKitClient get instance =>
      _instance ??= ChatroomUIKitClient();

  void unInit() {
    _instance?.responses.clear();
    ChatroomContext.instance.userInfosMap.clear();
    ChatroomContext.instance.muteList.clear();
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

  final List<ChatroomEventResponse> responses = [];

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
      debugMode: debugMode,
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
  /// login with password.
  ///
  /// Param [userId] user id.
  ///
  /// Param [password] user password.
  ///
  /// Param [userInfo] user info, [UserInfoProtocol] is a protocol, you can implement it by yourself
  Future<void> loginWithPassword({
    required String userId,
    required String password,
    UserInfoProtocol? userInfo,
  }) async {
    await userService.login(
      userId: userId,
      tokenOrPwd: password,
      isPassword: true,
    );
    updateUserInfo(user: userInfo);
  }

  /// login with token.
  ///
  /// Param [userId] user id.
  ///
  /// Param [token] user token.
  ///
  /// Param [userInfo] user info, [UserInfoProtocol] is a protocol, you can implement it by yourself
  ///
  Future<void> loginWithToken({
    required String userId,
    required String token,
    UserInfoProtocol? userInfo,
  }) async {
    await userService.login(
      userId: userId,
      tokenOrPwd: token,
      isPassword: false,
    );
    updateUserInfo(user: userInfo);
  }

  /// logout.
  Future<void> logout() {
    return userService.logout();
  }

  /// fetch user info.
  ///
  /// Param [userIds] user id list.
  Future<List<UserInfoProtocol>> fetchUserInfos({
    required List<String> userIds,
  }) {
    return userService.fetchUserInfos(userIds: userIds);
  }

  /// update user info.
  ///
  /// Param [user] user info. [UserInfoProtocol] is a protocol, you can implement it by yourself
  ///
  Future<void> updateUserInfo({
    UserInfoProtocol? user,
  }) {
    if (user == null) return Future.value();
    return userService.updateUserInfo(user: user);
  }

  /// refresh token,
  /// if you use token to login, you need to refresh token when token expired.
  ///
  /// Param [token] user token.
  ///
  Future<void> refreshToken({required String token}) {
    return Client.getInstance.renewAgoraToken(token);
  }
}

extension ChatRoomServiceAction on ChatroomUIKitClient {
  /// fetch chat room members.
  ///
  /// Param [roomId] chat room id.
  ///
  /// Param [pageSize] page size.
  ///
  /// Param [cursor] cursor. see [CursorResult.cursor].
  Future<CursorResult<String>> fetchParticipants({
    required String roomId,
    int pageSize = 20,
    String? cursor,
  }) {
    return _checkResult(roomId, RoomEventsType.fetchParticipants, () {
      return Client.getInstance.chatRoomManager.fetchChatRoomMembers(
        roomId,
        cursor: cursor,
        pageSize: pageSize,
      );
    });
  }

  /// fetch chat room mute members.
  ///
  /// Param [roomId] chat room id.
  ///
  /// Param [pageSize] page size.
  ///
  /// Param [pageNum] page number.
  Future<List<String>> fetchMutes({
    required String roomId,
    int pageSize = 20,
    int pageNum = 1,
  }) async {
    return _checkResult(roomId, RoomEventsType.fetchMutes, () {
      return Client.getInstance.chatRoomManager.fetchChatRoomMuteList(
        roomId,
        pageSize: pageSize,
        pageNum: pageNum,
      );
    });
  }

  /// chat room operation method.
  ///
  /// Param [roomId] chat room id.
  ///
  /// Param [type] chat room operation type. see [ChatroomOperationType].
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

  /// operating chat room user.
  ///
  /// Param [roomId] chat room id.
  ///
  /// Param [type] chat room user operation type. see [ChatroomUserOperationType].
  ///
  /// Param [userId] user id.
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

  /// send room message.
  ///
  /// Param [roomId] chat room id.
  ///
  /// Param [message] message content.
  ///
  /// Param [receiver] receiver id list.
  Future<void> sendRoomMessage({
    required String roomId,
    required String message,
    List<String>? receiver,
  }) {
    if (message.trim().isEmpty) return Future.value();
    return _checkResult(roomId, RoomEventsType.sendMessage, () {
      final String msg = EmojiMapping.replaceEmojiToImage(message);
      return roomService.sendRoomMessage(
        roomId: roomId,
        message: msg.trim(),
        receiver: receiver,
      );
    });
  }

  Future<List<Message>> fetchPinnedMessages({required String roomId}) async {
    return _checkResult(roomId, RoomEventsType.fetchPinnedMessages, () {
      return roomService.fetchPinnedMessages(roomId: roomId);
    });
  }

  Future<void> pinMessage(
      {required String roomId, required Message message}) async {
    return _checkResult(roomId, RoomEventsType.pinMessage, () async {
      await roomService.pinMessage(roomId: roomId, message: message);
    });
  }

  Future<void> unpinMessage(
      {required String roomId, required Message message}) async {
    return _checkResult(roomId, RoomEventsType.unpinMessage, () {
      return roomService.unpinMessage(roomId: roomId, message: message);
    });
  }

  /// send custom message.
  ///
  /// Param [roomId] chat room id.
  ///
  /// Param [event] custom event.
  ///
  /// Param [params] custom params.
  ///
  /// Param [receiver] receiver id list.
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

  /// translate message.
  ///
  /// Param [roomId] chat room id.
  ///
  /// Param [message] message content.
  ///
  /// Param [language] translate language.
  ///
  /// Return [Message] translate message.
  Future<Message?> translateMessage({
    required String roomId,
    required Message message,
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

  /// recall message.
  /// default support recall message which is sent in 2 minutes. you can change it by backend. room owner can recall any message.
  ///
  /// Param [roomId] chat room id.
  ///
  /// Param [message] message content.
  ///
  Future<void> recall({
    required String roomId,
    required Message message,
  }) {
    return _checkResult(roomId, RoomEventsType.recall, () {
      return roomService.recall(
        roomId: roomId,
        message: message,
      );
    });
  }

  /// report message.
  ///
  /// Param [roomId] chat room id.
  ///
  /// Param [messageId] message id.
  ///
  /// Param [tag] report tag.
  ///
  /// Param [reason] report reason.
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
    for (var element in responses) {
      element.onEventResultChanged(roomId, event, error);
    }
  }
}

extension ControllerResponses on ChatroomUIKitClient {
  /// bind room event response.
  ///
  /// Param [response] room event response.
  ///
  /// ```dart
  ///
  /// class ChatRoomListPage extends StatefulWidget {
  ///  @override
  /// State<StatefulWidget> createState() => _ChatRoomListPageState();
  ///
  ///
  ///
  void bindRoomEventResponse(ChatroomEventResponse response) {
    if (responses.contains(response)) return;
    responses.add(response);
  }

  /// unbind room event response.
  ///
  /// Param [response] room event response.
  void unbindRoomEventResponse(ChatroomEventResponse response) {
    responses.remove(response);
  }
}

mixin ChatroomEventResponse {
  /// room event response.
  ///
  /// Param [roomId] chat room id.
  ///
  /// Param [type] room event type. see [RoomEventsType].
  ///
  /// Param [error] error.
  void onEventResultChanged(
    String roomId,
    RoomEventsType type,
    ChatError? error,
  ) {}
}
