import 'package:chatroom_uikit/chatroom_uikit.dart';
import 'package:flutter/widgets.dart';

abstract class ChatroomMessageListController {
  List<ChatBottomSheetItem>? listItemLongPressed({
    required BuildContext context,
    required ChatMessage message,
    required String roomId,
    required String ownerId,
  }) {
    return null;
  }

  List<ChatBottomSheetItem>? listItemOnTap({
    required BuildContext context,
    required ChatMessage message,
    required String roomId,
    required String ownerId,
  }) {
    return null;
  }
}
