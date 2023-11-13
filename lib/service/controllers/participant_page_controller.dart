import 'package:chatroom_uikit/chatroom_uikit.dart';

import 'package:flutter/widgets.dart';

abstract class ChatRoomParticipantPageController {
  String title(BuildContext context, String? roomId, String? ownerId);

  Future<List<String>> reloadUsers(String roomId, String ownerId);

  Future<List<String>> loadMoreUsers(String roomId, String ownerId);

  Future<Map<String, String>> reloadUsersDetail(
      String roomId, List<String> userIds) {
    return Future(() => {for (var item in userIds) item: ''});
  }

  List<ChatEventItemAction>? itemMoreActions(
    BuildContext context,
    String? roomId,
    String? ownerId,
  ) {
    return null;
  }

  Widget emptyBackground(BuildContext context) {
    return ChatImageLoader.empty();
  }
}

class ChatEventItemAction {
  const ChatEventItemAction({
    required this.title,
    this.onPressed,
    this.highlight = false,
  });
  final String title;
  final bool highlight;
  final dynamic Function(
          BuildContext context, String roomId, String userId, dynamic data)?
      onPressed;
}
