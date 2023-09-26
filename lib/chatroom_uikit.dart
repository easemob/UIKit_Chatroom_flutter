import 'package:chatroom_uikit/tools/chat_provider.dart';
import 'package:chatroom_uikit/widgets/chat_input_bar.dart';
import 'package:flutter/material.dart';

import 'controllers/chatroom_controller.dart';

export 'controllers/chatroom_controller.dart';

export 'notifications/gift_notification.dart';
export './notifications/marquee_notification.dart';

export './tools/define.dart';
export './widgets/chat_input_bar.dart';
export './widgets/chatroom_marquee_view.dart';

class ChatRoomUIKit extends StatefulWidget {
  const ChatRoomUIKit({
    required this.controller,
    required this.child,
    this.inputBar,
    super.key,
  });
  final ChatRoomController controller;
  final Widget child;
  final Widget? inputBar;

  @override
  State<ChatRoomUIKit> createState() => _ChatRoomUIKitState();

  static ChatRoomController of(BuildContext context) {
    final _ChatRoomUIKitState? state =
        context.findAncestorStateOfType<_ChatRoomUIKitState>();
    return state!.widget.controller;
  }
}

class _ChatRoomUIKitState extends State<ChatRoomUIKit> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          ChatProvider(data: widget.controller, child: widget.child),
          widget.inputBar ??
              ChatInputBar(
                onSend: ({required String msg}) {
                  widget.controller.sendMessage(
                    content: msg,
                  );
                },
              ),
        ],
      ),
    );
  }
}
