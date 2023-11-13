import 'package:chatroom_uikit/chatroom_uikit.dart';

import 'package:flutter/material.dart';

export 'package:chat_uikit_theme/chat_uikit_theme.dart';
export 'package:flutter_localization/flutter_localization.dart';
export 'package:extended_text_library/extended_text_library.dart';

export 'chatroom_uikit_client.dart';
export 'chatroom_settings.dart';
export 'chatroom_uikit.dart';
export 'chatroom_localizations.dart';

export 'ui/widget/chat_uikit_button.dart';
export 'ui/widget/chat_bottom_sheet_background.dart';
export 'ui/widget/custom_tab_indicator.dart';

export 'service/controllers/chatroom_controller.dart' hide ChatUIKitExt;
export 'service/controllers/chat_report_controller.dart';
export 'service/controllers/chatroom_controller.dart';

export 'default/controllers/default_gift_page_controller.dart';
export 'default/controllers/default_report_controller.dart';
export 'default/data/gift_entity.dart';
export 'default/data/user_entity.dart';

export 'service/controllers/participant_page_controller.dart';
export 'service/controllers/gift_page_controller.dart';

export 'service/implement/chatroom_service_implement.dart';
export 'service/implement/gift_service_implement.dart';
export 'service/implement/user_service_implement.dart';
export 'service/implement/chatroom_context.dart';

export 'service/protocol/gift_service.dart';
export 'service/protocol/chatroom_service.dart';
export 'service/protocol/user_service.dart';

export 'utils/define.dart';
export 'utils/image_loader.dart';
export 'utils/chatroom_enums.dart';
export 'utils/language_convertor.dart';

export 'ui/widget/chat_bottom_sheet.dart';
export 'ui/widget/chat_dialog.dart';
export 'ui/widget/chat_input_bar.dart';
export 'ui/widget/chat_input_emoji.dart';

export 'ui/component/chatroom_gift_list_view.dart';
export 'ui/component/chatroom_gift_message_list_view.dart';
export 'ui/component/chatroom_global_broad_cast_view.dart';
export 'ui/component/chatroom_message_list_view.dart';
export 'ui/component/chatroom_participants_list_view.dart';

class ChatRoomUIKit extends StatefulWidget {
  const ChatRoomUIKit({
    required this.controller,
    this.child,
    this.inputBar,
    super.key,
  });
  final ChatroomController controller;

  final WidgetBuilder? child;
  final Widget? inputBar;

  @override
  State<ChatRoomUIKit> createState() => ChatRoomUIKitState();

  static ChatRoomUIKitState? of(BuildContext context) {
    final ChatRoomUIKitState? state =
        context.findAncestorStateOfType<ChatRoomUIKitState>();
    return state;
  }

  static ChatroomController? roomController(BuildContext context) {
    final ChatRoomUIKitState? state =
        context.findAncestorStateOfType<ChatRoomUIKitState>();
    return state?.widget.controller;
  }
}

class ChatRoomUIKitState extends State<ChatRoomUIKit> {
  List<ChatRoomGiftPageController> giftServices = [];

  @override
  void didUpdateWidget(covariant ChatRoomUIKit oldWidget) {
    if (oldWidget.controller != widget.controller) {
      widget.controller.setShowParticipantsViewCallback(showParticipantsView);
      widget.controller.setShowGiftsViewCallback(showGiftsView);
      oldWidget.controller.dispose();
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void initState() {
    super.initState();
    widget.controller.setShowParticipantsViewCallback(showParticipantsView);
    widget.controller.setShowGiftsViewCallback(showGiftsView);

    joinChatRoom();
  }

  void joinChatRoom() async {
    try {
      await ChatRoomUIKitClient.instance.chatroomOperating(
        roomId: widget.controller.roomId,
        type: ChatroomOperationType.join,
      );
      // ignore: empty_catches
    } catch (e) {
      vLog('joinChatRoom error: $e');
    }
  }

  void showGiftsView(List<ChatRoomGiftPageController> services) {
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
        return ChatRoomGiftListView(
          giftControllers: services,
          onSendTap: (gift) {
            widget.controller.sendGift(gift);
          },
        );
      },
    );
  }

  void showParticipantsView() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      clipBehavior: Clip.hardEdge,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16.0),
          topRight: Radius.circular(16.0),
        ),
      ),
      builder: (ctx) {
        return ChatroomParticipantsListView(
          roomId: widget.controller.roomId,
          ownerId: widget.controller.ownerId,
          services: widget.controller.participantControllers,
          onError: (error) {
            // widget.controller.roomListener?.onErrorOccur?.call(error: error);
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget content = Stack(
      children: [
        () {
          if (widget.child != null) {
            return widget.child!(context);
          } else {
            return Container();
          }
        }(),
        widget.inputBar ??
            ChatInputBar(
              onSend: ({required String msg}) {
                widget.controller.sendMessage(msg);
              },
            ),
      ],
    );

    content = WillPopScope(
      child: content,
      onWillPop: () async {
        widget.controller.setShowParticipantsViewCallback(null);
        widget.controller.setShowGiftsViewCallback(null);
        return true;
      },
    );

    return content;
  }

  @override
  void dispose() {
    widget.controller
        .chatroomOperating(ChatroomOperationType.leave)
        .then((value) => null)
        .catchError((e) {});
    widget.controller.dispose();
    super.dispose();
  }
}
