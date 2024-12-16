import 'package:flutter/material.dart';

import '../../inner_headers.dart';

export '../../inner_headers.dart';

export 'chatroom_settings.dart';
export 'chatroom_uikit.dart';
export 'chatroom_localizations.dart';

export 'ui/widget/chat_uikit_button.dart';
export 'ui/widget/chat_bottom_sheet_background.dart';
export 'ui/widget/custom_tab_indicator.dart';
export 'ui/widget/chat_avatar.dart';

export 'ui/component/chatroom_report_list_view.dart';

export 'service/controllers/chatroom_controller.dart' hide ChatUIKitExt;
export 'service/controllers/chat_report_controller.dart';
export 'service/controllers/chatroom_controller.dart';

export 'service/default/controllers/default_message_list_controller.dart';
export 'service/default/controllers/default_gift_page_controller.dart';
export 'service/default/controllers/default_report_controller.dart';
export 'service/default/data/gift_entity.dart';
export 'service/default/data/user_entity.dart';

export 'service/controllers/chatroom_message_list_controller.dart';
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
export 'utils/chatroom_event_item_action.dart';

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
  List<ChatroomGiftPageController> giftServices = [];

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
      await ChatroomUIKitClient.instance.chatroomOperating(
        roomId: widget.controller.roomId,
        type: ChatroomOperationType.join,
      );
      // ignore: empty_catches
    } catch (e) {
      vLog('joinChatRoom error: $e');
    }
  }

  void showGiftsView(List<ChatroomGiftPageController> services) {
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
          onError: (error) {},
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

    content = PopScope(
      child: content,
      onPopInvoked: (finish) async {
        widget.controller.setShowParticipantsViewCallback(null);
        widget.controller.setShowGiftsViewCallback(null);
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
