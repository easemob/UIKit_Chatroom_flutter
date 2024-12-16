import '../../../inner_headers.dart';

import 'package:flutter/material.dart';

class DefaultMembersController extends ChatroomParticipantPageController {
  int pageSize = 20;
  String cursor = '';
  bool fetchAll = false;

  @override
  Future<List<String>> loadMoreUsers(String roomId, String ownerId) async {
    if (fetchAll) return Future(() => []);

    try {
      CursorResult<String> result =
          await Client.getInstance.chatRoomManager.fetchChatRoomMembers(
        roomId,
        cursor: cursor,
        pageSize: pageSize,
      );

      if (result.cursor?.isEmpty == true) {
        fetchAll = true;
      }
      cursor = result.cursor ?? '';

      return result.data;
    } catch (e) {
      return [];
    }
  }

  @override
  Future<List<String>> reloadUsers(String roomId, String ownerId) async {
    fetchAll = false;

    try {
      CursorResult<String> result =
          await ChatroomUIKitClient.instance.fetchParticipants(
        roomId: roomId,
        pageSize: pageSize,
      );

      if (result.cursor?.isEmpty == true) {
        fetchAll = true;
      }
      cursor = result.cursor ?? '';
      result.data.remove(ownerId);
      result.data.insert(0, ownerId);
      return result.data;
    } catch (e) {
      return [];
    }
  }

  @override
  List<ChatEventItemAction>? itemMoreActions(
    final BuildContext context,
    final String? userId,
    final String? roomId,
    final String? ownerId,
  ) {
    if (Client.getInstance.currentUserId != ownerId) return null;
    return [
      if (ChatroomContext.instance.muteList.contains(userId))
        ChatEventItemAction(
          title: ChatroomLocal.bottomSheetUnmute.getString(context),
          onPressed: (context, roomId, userId, user) async {
            try {
              await ChatroomUIKitClient.instance.operatingUser(
                roomId: roomId,
                userId: userId,
                type: ChatroomUserOperationType.unmute,
              );
              // ignore: empty_catches
            } catch (e) {}
          },
        ),
      if (!ChatroomContext.instance.muteList.contains(userId))
        ChatEventItemAction(
          title: ChatroomLocal.bottomSheetMute.getString(context),
          onPressed: (context, roomId, userId, user) async {
            try {
              await ChatroomUIKitClient.instance.operatingUser(
                roomId: roomId,
                userId: userId,
                type: ChatroomUserOperationType.mute,
              );
              // ignore: empty_catches
            } catch (e) {}
          },
        ),
      ChatEventItemAction(
        title: ChatroomLocal.memberRemove.getString(context),
        highlight: true,
        onPressed: (context, roomId, userId, user) async {
          showDialog(
            context: context,
            builder: (context) {
              return ChatDialog(
                title:
                    "${ChatroomLocal.wantRemove.getString(context)} '@${user?.nickname ?? userId}'",
                items: [
                  ChatDialogItem.cancel(
                    onTap: () async {
                      Navigator.of(context).pop();
                    },
                  ),
                  ChatDialogItem.confirm(
                    onTap: () async {
                      Navigator.of(context).pop();
                      try {
                        await ChatroomUIKitClient.instance.roomService
                            .operatingUser(
                          roomId: roomId,
                          userId: userId,
                          type: ChatroomUserOperationType.kick,
                        );
                        // ignore: empty_catches
                      } catch (e) {}
                    },
                  ),
                ],
              );
            },
          );
        },
      ),
    ];
  }

  @override
  String title(BuildContext context, String? roomId, String? ownerId) {
    return ChatroomLocal.memberListTitle.getString(context);
  }
}
