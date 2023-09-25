import 'package:chatroom_uikit/widgets/chat_input_bar.dart';
import 'package:flutter/material.dart';

import 'controllers/chatroom_controller.dart';

export './controllers/chatroom_controller.dart';

export './tools/define.dart';
export './widgets/chat_input_bar.dart';

class ChatRoomUIKit extends StatefulWidget {
  const ChatRoomUIKit({
    required this.controller,
    required this.roomId,
    required this.child,
    this.inputBar,
    super.key,
  });
  final ChatRoomController controller;
  final String roomId;
  final Widget child;
  final Widget? inputBar;

  @override
  State<ChatRoomUIKit> createState() => _ChatRoomUIKitState();
}

class _ChatRoomUIKitState extends State<ChatRoomUIKit> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          widget.child,
          widget.inputBar ?? ChatInputBar(),
        ],
      ),
    );
  }
}
