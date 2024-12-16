import 'package:flutter/widgets.dart';

import '../../inner_headers.dart';

abstract class ChatroomMessageListController {
  List<ChatBottomSheetItem>? listItemLongPressed({
    required BuildContext context,
    required Message message,
    required String roomId,
    required String ownerId,
  }) {
    return null;
  }

  List<ChatBottomSheetItem>? listItemOnTap({
    required BuildContext context,
    required Message message,
    required String roomId,
    required String ownerId,
  }) {
    return null;
  }
}
