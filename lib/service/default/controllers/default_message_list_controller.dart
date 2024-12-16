
import '../../../chatroom_uikit.dart';
import '../../../inner_headers.dart';

import 'package:flutter/material.dart';

class DefaultMessageListController extends ChatroomMessageListController {
  @override
  List<ChatBottomSheetItem>? listItemLongPressed({
    required BuildContext context,
    required Message message,
    String? roomId,
    String? ownerId,
  }) {
    return [
      if (ownerId == Client.getInstance.currentUserId)
        ChatBottomSheetItem.normal(
          label: ChatroomLocal.bottomSheetPin.getString(context),
          onTap: () async {
            Navigator.of(context).pop();
            try {
              await ChatroomUIKitClient.instance.pinMessage(
                  roomId: message.conversationId!, message: message);
            } catch (e) {
              vLog(e.toString());
            }
          },
        ),
      ChatBottomSheetItem.normal(
        label: ChatroomLocal.bottomSheetTranslate.getString(context),
        onTap: () async {
          Navigator.of(context).pop();
          try {
            await ChatroomUIKitClient.instance.translateMessage(
                roomId: message.conversationId!,
                message: message,
                language: LanguageConvertor.instance.targetLanguage(context));
          } catch (e) {
            vLog(e.toString());
          }
        },
      ),
      if (message.from == Client.getInstance.currentUserId)
        ChatBottomSheetItem.normal(
          label: ChatroomLocal.bottomSheetDelete.getString(context),
          onTap: () async {
            Navigator.of(context).pop();
            try {
              await ChatroomUIKitClient.instance
                  .recall(roomId: message.conversationId!, message: message);
            } catch (e) {
              vLog(e.toString());
            }
          },
        ),
      if (ChatRoomUIKit.roomController(context)?.ownerId ==
              Client.getInstance.currentUserId &&
          message.from != Client.getInstance.currentUserId &&
          ChatroomContext.instance.muteList.contains(message.from))
        ChatBottomSheetItem.normal(
          label: ChatroomLocal.bottomSheetUnmute.getString(context),
          onTap: () {
            ChatroomUIKitClient.instance
                .operatingUser(
                  roomId: roomId!,
                  userId: message.from!,
                  type: ChatroomUserOperationType.unmute,
                )
                .then((value) {})
                .whenComplete(() {
              if (context.mounted) {
                Navigator.of(context).pop();
              }
            });
          },
        ),
      if (ChatRoomUIKit.roomController(context)?.ownerId ==
              Client.getInstance.currentUserId &&
          message.from != Client.getInstance.currentUserId &&
          ChatroomContext.instance.muteList.contains(message.from) == false)
        ChatBottomSheetItem.normal(
          label: ChatroomLocal.bottomSheetMute.getString(context),
          onTap: () {
            ChatroomUIKitClient.instance
                .operatingUser(
                  roomId: roomId!,
                  userId: message.from!,
                  type: ChatroomUserOperationType.mute,
                )
                .then((value) {})
                .whenComplete(() {
              if (context.mounted) {
                Navigator.of(context).pop();
              }
            });
          },
        ),
      ChatBottomSheetItem.destructive(
        label: ChatroomLocal.bottomSheetReport.getString(context),
        onTap: () {
          Navigator.of(context).pop();
          showModalBottomSheet(
            context: context,
            clipBehavior: Clip.hardEdge,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16.0),
                topRight: Radius.circular(16.0),
              ),
            ),
            builder: (context) {
              return ChatroomReportListView(
                roomId: roomId!,
                messageId: message.msgId,
                owner: ownerId,
              );
            },
          );
        },
      ),
    ];
  }

  @override
  List<ChatBottomSheetItem>? listItemOnTap({
    required BuildContext context,
    required Message message,
    String? roomId,
    String? ownerId,
  }) {
    return null;
  }
}
