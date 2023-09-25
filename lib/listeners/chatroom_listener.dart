import '../tools/define.dart';

class ChatRoomListener {
  ChatRoomListener(
    this.roomId, {
    this.onMessageReceived,
    this.onMessageRecalled,
    this.onGlobalNotifyReceived,
    this.onUserJoined,
    this.onUserLeave,
    this.onAnnouncementUpdate,
    this.onUserBeKicked,
    this.onUserMuted,
    this.onUserUnmuted,
  });

  final String roomId;

  /// Received message from chatroom members.
  /// - Parameters:
  ///   - roomId: chatroom id
  ///   - message: ChatMessage
  final void Function({
    String roomId,
    ChatMessage message,
  })? onMessageReceived;

  /// When some one recall a message,the method will call.
  /// - Parameters:
  ///   - roomId: chatroom id
  ///   - message: ChatMessage
  ///   - userId: call recall user id
  final void Function({
    String roomId,
    ChatMessage message,
    String userId,
  })? onMessageRecalled;

  /// When admin publish global notify message,the method will called.
  /// - Parameters:
  ///   - roomId: chatroom id
  ///   - notifyMessage: ChatMessage
  final void Function({
    String roomId,
    ChatMessage notifyMessage,
  })? onGlobalNotifyReceived;

  /// When a user joins a chatroom.The method carry user info for display.
  /// - Parameters:
  ///   - roomId: chatroom id
  ///   - message: ChatMessage
  final void Function({
    String roomId,
    ChatMessage message,
  })? onUserJoined;

  /// When some user leave chatroom.
  /// - Parameters:
  ///   - roomId: chatroom id
  ///   - userId: user id
  final void Function({String roomId, String userId})? onUserLeave;

  /// When chatroom announcement updated.The method will called.
  /// - Parameters:
  ///   - roomId: chatroom id
  ///   - announcement: announcement

  final void Function({String roomId, String announcement})?
      onAnnouncementUpdate;

  /// When some user kicked out by owner.
  /// - Parameters:
  ///   - roomId: chatroom id
  ///   - userId: user id
  ///   - reason: reason
  final void Function({String roomId, ChatroomBeKickedReason reason})?
      onUserBeKicked;

  /// When some room members were muted,then method will call notify Administrator.
  /// - Parameters:
  ///   - roomId: chatroom id
  ///   - userId: UserId were muted
  ///   - operatorId: Operator user id
  final void Function({String roomId, String userId, String operatorId})?
      onUserMuted;

  /// When some room members were unmuted,then method will call notify Administrator.
  /// - Parameters:
  ///   - roomId: chatroom id
  ///   - userId: UserId were muted
  ///   - operatorId: Operator user id
  final void Function({String roomId, String userId, String operatorId})?
      onUserUnmuted;
}
