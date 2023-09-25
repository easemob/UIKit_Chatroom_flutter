import '../listeners/chatroom_gift_listener.dart';
import '../listeners/chatroom_listener.dart';
import '../tools/define.dart';

class ChatRoomController {
  ChatRoomController({
    this.roomListener,
    this.giftListener,
  }) {
    _eventKey = 'ChatRoomController';
    _addEvent();
  }
  final ChatRoomListener? roomListener;
  final ChatRoomGiftListener? giftListener;

  late final String _eventKey;

  void _addEvent() {
    _addChatEvent();
    _addRoomEvent();
  }

  void _removeEvent() {
    _removeChatEvent();
    _removeRoomEvent();
  }

  void dispose() {
    _removeEvent();
  }
}

extension ChatroomImplement on ChatRoomController {
  Future<void> chatroomOperating({
    required String roomId,
    required ChatroomOperationType type,
  }) async {
    switch (type) {
      case ChatroomOperationType.join:
        await Client.getInstance.chatRoomManager.joinChatRoom(roomId);
        break;
      case ChatroomOperationType.leave:
        await Client.getInstance.chatRoomManager.leaveChatRoom(roomId);
        break;
    }
  }

  Future<String?> fetchAnnouncement({required String roomId}) async {
    return await Client.getInstance.chatRoomManager
        .fetchChatRoomAnnouncement(roomId);
  }

  Future<void> updateAnnouncement({
    required String roomId,
    required String announcement,
  }) async {
    await Client.getInstance.chatRoomManager.updateChatRoomAnnouncement(
      roomId,
      announcement,
    );
  }

  Future<void> operatingUser({
    required String roomId,
    required String userId,
    required ChatroomUserOperationType type,
  }) async {
    switch (type) {
      // case ChatroomUserOperationType.addAdministrator:
      // case ChatroomUserOperationType.removeAdministrator:
      case ChatroomUserOperationType.block:
        await Client.getInstance.chatRoomManager
            .blockChatRoomMembers(roomId, [userId]);
        break;
      case ChatroomUserOperationType.unblock:
        await Client.getInstance.chatRoomManager
            .unBlockChatRoomMembers(roomId, [userId]);
        break;
      case ChatroomUserOperationType.mute:
        await Client.getInstance.chatRoomManager
            .muteChatRoomMembers(roomId, [userId]);
        break;
      case ChatroomUserOperationType.unmute:
        await Client.getInstance.chatRoomManager
            .unMuteChatRoomMembers(roomId, [userId]);
        break;
      case ChatroomUserOperationType.kick:
        await Client.getInstance.chatRoomManager
            .removeChatRoomMembers(roomId, [userId]);
        break;
      default:
        break;
    }
  }

  Future<void> sendMessage({
    required String roomId,
    required String content,
    List<String>? toUsers,
  }) async {
    // todo: add user info.
  }

  Future<void> sendCustomMessage({
    required String roomId,
    required String content,
    required String event,
    Map<String, String>? infoMap,
    List<String>? toUsers,
  }) async {
    // todo:
  }

  Future<ChatMessage> translateMessage({
    required ChatMessage message,
  }) async {
    // todo: need languages.
    return await Client.getInstance.chatManager
        .translateMessage(msg: message, languages: ['zh-cn']);
  }

  Future<void> sendJoinMessage({
    required String roomId,
  }) async {
    // todo:
  }

  Future<void> recall({required String messageId}) async {
    await Client.getInstance.chatManager.recallMessage(messageId);
  }

  Future<void> report({
    required String messageId,
    required String tag,
    required String reason,
  }) async {
    await Client.getInstance.chatManager.reportMessage(
      messageId: messageId,
      tag: tag,
      reason: reason,
    );
  }
}

extension RoomEvent on ChatRoomController {
  void _addRoomEvent() {
    Client.getInstance.chatRoomManager.addEventHandler(
      _eventKey,
      RoomEventHandler(),
    );
  }

  void _removeRoomEvent() {
    Client.getInstance.chatRoomManager.removeEventHandler(_eventKey);
  }
}

extension ChatEvent on ChatRoomController {
  void _addChatEvent() {
    Client.getInstance.chatManager.addEventHandler(
      _eventKey,
      ChatEventHandler(),
    );
  }

  void _removeChatEvent() {
    Client.getInstance.chatManager.removeEventHandler(_eventKey);
  }
}
