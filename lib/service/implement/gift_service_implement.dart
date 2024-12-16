import 'dart:convert';

import '../../inner_headers.dart';

class GiftServiceImplement extends GiftService {
  List<GiftResponse> responses = [];

  GiftServiceImplement() {
    _addListener();
  }

  @override
  void dispose() {
    _removeListener();
  }

  @override
  void bindResponse(GiftResponse response) {
    if (responses.contains(response)) return;
    responses.add(response);
  }

  @override
  void unbindResponse(GiftResponse response) {
    responses.remove(response);
  }

  @override
  Future<void> sendGift(
    String roomId,
    GiftEntityProtocol gift,
    UserInfoProtocol? user,
  ) async {
    await ChatroomUIKitClient.instance.sendCustomMessage(
      roomId: roomId,
      event: ChatRoomUIKitEvent.giftEvent,
      params: {
        ChatRoomUIKitEvent.gift: json.encode(giftToJson(gift)),
      },
    );
  }

  @override
  GiftEntityProtocol? giftFromJson(Map<String, dynamic>? json) {
    if (json?.isNotEmpty == true) {
      return GiftEntity.fromJson(json!);
    } else {
      return null;
    }
  }

  @override
  Map<String, dynamic>? giftToJson(GiftEntityProtocol? giftEntityProtocol) {
    if (giftEntityProtocol != null) {
      return (giftEntityProtocol as GiftEntity).toJson();
    } else {
      return null;
    }
  }
}

extension ChatEventsListener on GiftServiceImplement {
  void _addListener() {
    Client.getInstance.chatManager.addEventHandler(
      'GiftServiceImplement',
      ChatEventHandler(
        onMessagesReceived: (messages) {
          onMessagesReceived(messages);
        },
      ),
    );
    Client.getInstance.chatManager.addMessageEvent(
      'GiftServiceImplement',
      MessageEvent(
        onSuccess: (msgId, msg) {
          onMessagesReceived([msg]);
        },
      ),
    );
  }

  void _removeListener() {
    Client.getInstance.chatManager.removeEventHandler('GiftServiceImplement');
    Client.getInstance.chatManager.removeMessageEvent('GiftServiceImplement');
  }

  void onMessagesReceived(List<Message> msgs) {
    for (var msg in msgs) {
      if (msg.isGiftMsg() && msg.chatType == ChatType.ChatRoom) {
        final gift = msg.getGiftEntity();
        if (gift != null) {
          for (var response in responses) {
            response.receiveGift(
              msg.conversationId!,
              msg,
            );
          }
        }
      }
    }
  }
}
