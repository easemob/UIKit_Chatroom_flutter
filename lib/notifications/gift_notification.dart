import 'package:flutter/material.dart';

class ChatRoomGiftNotification extends Notification {
  const ChatRoomGiftNotification({
    required this.fromUserId,
    required this.giftId,
  });
  final String giftId;
  final String fromUserId;
}
