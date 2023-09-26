import 'package:chatroom_uikit/controllers/chatroom_controller.dart';
import 'package:flutter/material.dart';

import '../tools/chat_provider.dart';

class ChatRoomMarqueeView extends StatefulWidget
    implements PreferredSizeWidget {
  const ChatRoomMarqueeView({super.key});

  @override
  State<ChatRoomMarqueeView> createState() => _ChatRoomMarqueeViewState();

  @override
  Size get preferredSize => const Size.fromHeight(20);
}

class _ChatRoomMarqueeViewState extends State<ChatRoomMarqueeView> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ChatProvider.of<ChatRoomController>(context);
    return Builder(
      builder: (context) {
        return Container(
          color: Colors.red,
        );
      },
    );
  }
}
