import 'package:chatroom_uikit/chatroom_uikit.dart';
import 'package:flutter/material.dart';

class ChatRoomGiftView extends StatefulWidget {
  const ChatRoomGiftView({super.key});

  @override
  State<ChatRoomGiftView> createState() => _ChatRoomGiftViewState();
}

class _ChatRoomGiftViewState extends State<ChatRoomGiftView> {
  @override
  void initState() {
    super.initState();
    ChatRoomUIKit.of(context)?.giftCallback = onGiftReceived;
  }

  void onGiftReceived(String userId, String giftId) {
    debugPrint('onGiftReceived: $userId, $giftId');
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.red,
      height: 120,
      child: ListView(),
    );
  }
}

class ChatRoomGiftItem extends StatelessWidget {
  const ChatRoomGiftItem({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
