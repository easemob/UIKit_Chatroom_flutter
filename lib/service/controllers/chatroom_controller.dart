// ignore_for_file: empty_catches
import 'package:flutter/material.dart';

import '../../inner_headers.dart';






class ChatRoomUIKitEvent {
  static String userJoinEvent = 'CHATROOMUIKITUSERJOIN';
  static String userInfo = 'chatroom_uikit_userInfo';
  static String giftEvent = 'CHATROOMUIKITGIFT';
  static String gift = 'chatroom_uikit_gift';
}

/// All business service errors
enum RoomEventsType {
  join,
  leave,
  destroyed,
  kick,
  mute,
  unmute,
  translate,
  recall,
  report,
  fetchParticipants,
  fetchMutes,
  sendMessage,
  fetchPinnedMessages,
  pinMessage,
  unpinMessage,
}

class ChatroomEventListener {
  ChatroomEventListener(
    this.onEventResultChanged,
  );
  final void Function(RoomEventsType type, ChatError? error)?
      onEventResultChanged;
}

class ChatroomController with ChatroomResponse, ChatroomEventResponse {
  ChatroomController({
    required this.roomId,
    required this.ownerId,
    this.listener,
    this.giftControllers,
    List<ChatroomParticipantPageController>? participantControllers,
  }) {
    List<ChatroomParticipantPageController> list = [DefaultMembersController()];
    if (ownerId == Client.getInstance.currentUserId) {
      list.add(DefaultMutesController());
    }

    this.participantControllers = participantControllers ?? list;
    ChatroomUIKitClient.instance.roomService.bindResponse(this);
    ChatroomUIKitClient.instance.bindRoomEventResponse(this);
  }
  final String roomId;
  final String ownerId;
  final ChatroomEventListener? listener;
  bool isOwner() {
    return ownerId == Client.getInstance.currentUserId;
  }

  late final List<ChatroomParticipantPageController> participantControllers;

  /// 礼物列表
  final Future<List<ChatroomGiftPageController>?>? giftControllers;

  // late final String _eventKey;

  // ignore: unused_field
  ChatInputBarState? _inputBarState;

  VoidCallback? _showParticipantsViewAction;
  ChatroomShowGiftListAction? _showGiftsViewAction;

  void dispose() {
    ChatroomContext.instance.muteList.clear();
    ChatroomUIKitClient.instance.roomService.unbindResponse(this);
    ChatroomUIKitClient.instance.unbindRoomEventResponse(this);
  }

  @override
  void onEventResultChanged(
      String roomId, RoomEventsType type, ChatError? error) {
    if (roomId == this.roomId) {
      listener?.onEventResultChanged?.call(type, error);
    }
  }
}

extension Actions on ChatroomController {
  void showParticipantPages() {
    _showParticipantsViewAction?.call();
  }

  void showGiftSelectPages() {
    giftControllers?.then((value) {
      if (value?.isNotEmpty == true) {
        _showGiftsViewAction?.call(value!);
      }
    });
  }

  void hiddenInputBar() {
    _inputBarState?.hiddenInputBar();
  }
}

extension ChatroomImplement on ChatroomController {
  Future<void> chatroomOperating(
    ChatroomOperationType type,
  ) async {
    try {
      await ChatroomUIKitClient.instance.chatroomOperating(
        roomId: roomId,
        type: type,
      );
    } on ChatError {}
  }

  Future<void> operatingUser(
    String roomId,
    ChatroomUserOperationType type,
    String userId,
  ) async {
    try {
      await ChatroomUIKitClient.instance.operatingUser(
        roomId: roomId,
        userId: userId,
        type: type,
      );
    } on ChatError {}
  }

  Future<void> sendMessage(String content) async {
    try {
      await ChatroomUIKitClient.instance.sendRoomMessage(
        roomId: roomId,
        message: content,
      );
    } on ChatError {}
  }

  Future<void> sendGift(GiftEntityProtocol gift) async {
    try {
      await ChatroomUIKitClient.instance.sendGift(
        roomId: roomId,
        gift: gift,
      );
    } on ChatError {}
  }

  Future<Message?> translateMessage({
    required Message message,
    required LanguageCode languageCode,
  }) async {
    try {
      return await ChatroomUIKitClient.instance.translateMessage(
          roomId: roomId, message: message, language: languageCode);
    } on ChatError {
      return Future.value();
    }
  }

  Future<void> recall(
      {required String roomId, required Message message}) async {
    try {
      await ChatroomUIKitClient.instance.recall(
        roomId: roomId,
        message: message,
      );
    } on ChatError {}
  }

  Future<void> report({
    required String messageId,
    required String tag,
    required String reason,
  }) async {
    try {
      await ChatroomUIKitClient.instance.report(
        roomId: roomId,
        messageId: messageId,
        tag: tag,
        reason: reason,
      );
    } on ChatError {}
  }
}

extension ChatUIKitExt on ChatroomController {
  void setInputBarState(ChatInputBarState? state) {
    _inputBarState = state;
  }

  void setShowParticipantsViewCallback(VoidCallback? callback) {
    _showParticipantsViewAction = callback;
  }

  void setShowGiftsViewCallback(ChatroomShowGiftListAction? callback) {
    _showGiftsViewAction = callback;
  }
}
