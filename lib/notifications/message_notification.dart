import 'package:flutter/material.dart';

class ChatRoomMessageNotification extends Notification {
  const ChatRoomMessageNotification({
    required this.fromUserId,
    required this.content,
  });

  final String fromUserId;
  final String content;
}
