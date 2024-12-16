import '../../inner_headers.dart';

abstract class ChatRoomService {
  /// Description Binding a listener to receive callback events.
  ///
  /// Param [response] : ChatResponseListener
  void bindResponse(ChatroomResponse response);

  /// Description Unbind the listener.
  ///
  /// Param [response]: ChatResponseListener
  void unbindResponse(ChatroomResponse response);

  /// Description Chatroom operation events.
  /// - Parameters:
  ///   - roomId: chatroom id
  ///   - userId: user id
  ///   - type: ChatroomOperationType
  Future<void> chatroomOperating({
    required String roomId,
    required ChatroomOperationType type,
  });

  /// Description Get chatroom announcement.
  Future<String?> fetchAnnouncement({required String roomId});

  /// Description Update chatroom announcement
  /// - Parameters:
  ///   - roomId: chatroom id
  ///   - announcement: announcement content
  ///   - completion: Updated callback,what if success or error.
  Future<void> updateAnnouncement({
    required String roomId,
    required String announcement,
  });

  /// Description Various operations of group owners or administrators on users.
  /// - Parameters:
  ///   - roomId: chatroom id
  ///   - userId: user id
  ///   - type: ChatroomUserOperationType
  ///   - completion: callback,what if success or error.
  Future<void> operatingUser({
    required String roomId,
    required ChatroomUserOperationType type,
    required String userId,
  });

  /// Description Send targeted text messages to some members of the chat room

  /// - Parameters:
  ///   - userIds: [UserId]
  ///   - roomId: chatroom id
  ///   - content: content text
  ///   - completion: Send callback,what if success or error.
  Future<void> sendRoomMessage({
    required String roomId,
    required String message,
    List<String>? receiver,
  });

  /// Description Send targeted custom messages to some members of the chat room
  /// - Parameters:
  ///   - userIds: userIds description
  ///   - roomId: [UserId]
  ///   - eventType: A constant String value that identifies the type of event.
  ///   - infoMap: Extended Information
  ///   - completion: Send callback,what if success or error.
  Future<void> sendCustomMessage({
    required String roomId,
    required String event,
    required Map<String, String> params,
    List<String>? receiver,
  });

  Future<List<Message>> fetchPinnedMessages({required String roomId});

  Future<void> pinMessage({required String roomId, required Message message});

  Future<void> unpinMessage({required String roomId, required Message message});

  /// Description Translate the specified message
  /// - Parameters:
  ///   - message: ChatMessage kind of text message.
  ///   - completion: Translate callback,what if success or error.
  Future<Message> translateMessage({
    required String roomId,
    required Message message,
    required LanguageCode language,
  });

  /// Report illegal message.
  /// - Parameters:
  ///   - messageId: message id
  ///   - tag: Illegal type defined at console.
  ///   - reason: reason
  ///   - completion: Report callback,what if success or error.
  Future<void> recall({required String roomId, required Message message});

  /// Report illegal message.
  /// - Parameters:
  ///   - messageId: message id
  ///   - tag: Illegal type defined at console.
  ///   - reason: reason
  ///   - completion: Report callback,what if success or error.
  Future<void> report({
    required String messageId,
    required String tag,
    required String reason,
  });

  void dispose();
}

mixin ChatroomResponse {
  /// Received message from chatroom participants.
  /// - Parameters:
  ///   - roomId: chatroom id
  ///   - message: EMChatMessage
  void onMessageReceived(String roomId, List<Message> msgs) {}

  /// When some one recall a message,the method will call.
  /// - Parameters:
  ///   - roomId: chatroom id
  ///   - message: ChatMessage
  ///   - userId: call recall user id
  void onMessageRecalled(String roomId, List<Message> msgs) {}

  /// When admin publish global notify message,the method will called.
  /// - Parameters:
  ///   - roomId: chatroom id
  ///   - notifyMessage: ChatMessage
  void onGlobalNotifyReceived(String roomId, List<Message> notifyMessages) {}

  /// When a user joins a chatroom.The method carry user info for display.
  /// - Parameters:
  ///   - roomId: chatroom id
  ///   - message: ``ChatMessage``
  void onUserJoined(String roomId, List<Message> msgs) {}

  /// When some user leave chatroom.
  /// - Parameters:
  ///   - roomId: chatroom id
  ///   - userId: user id
  void onUserLeave(String roomId, String userId) {}

  /// When chatroom announcement updated.The method will called.
  /// - Parameters:
  ///   - roomId: chatroom id
  ///   - announcement: announcement
  void onAnnouncementUpdate(String roomId, String announcement) {}

  /// When some user kicked out by owner.
  /// - Parameters:
  ///   - roomId: chatroom id
  ///   - userId: user id
  ///   - reason: reason
  void onUserBeKicked(String roomId, ChatroomBeKickedReason reason) {}

  /// When some room participants were muted,then method will call notify Administrator.
  /// - Parameters:
  ///   - roomId: chatroom id
  ///   - userId: UserId were muted
  ///   - operatorId: Operator user id
  void onUserMuted(String roomId, List<String> userIds) {}

  /// When some room participants were unmuted,then method will call notify Administrator.
  /// - Parameters:
  ///   - roomId: chatroom id
  ///   - userId: UserId were muted
  ///   - operatorId: Operator user id
  void onUserUnmuted(String roomId, List<String> userIds) {}

  void onMessageTransformed(String roomId, Message message) {}

  void onPinChanged(bool isPin, Message message) {}
}
