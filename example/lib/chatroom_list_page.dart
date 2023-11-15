import 'package:chatroom_uikit/chatroom_uikit.dart';
import 'package:flutter/material.dart';

class ChatRoomListPage extends StatefulWidget {
  const ChatRoomListPage({super.key});

  @override
  State<ChatRoomListPage> createState() => _ChatRoomListPageState();
}

class _ChatRoomListPageState extends State<ChatRoomListPage> {
  final List<ChatRoom> _chatRooms = [];
  int pageNumber = 0;

  @override
  void initState() {
    super.initState();
    loadRooms();
  }

  void loadRooms() async {
    try {
      PageResult<ChatRoom> result = await Client.getInstance.chatRoomManager
          .fetchPublicChatRoomsFromServer(
        pageNum: pageNumber++,
        pageSize: 200,
      );
      if (result.data?.isNotEmpty == true) {
        _chatRooms.addAll(result.data!);
        if (mounted) setState(() {});
      }
    } on ChatError catch (e) {
      vLog(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: ElevatedButton(
          onPressed: () async {
            Navigator.pop(context);
            await ChatroomUIKitClient.instance.logout();
          },
          child: const Text('Logout'),
        ),
      ),
      body: ListView.separated(
        itemBuilder: (context, index) {
          return InkWell(
            onTap: () {
              onTileTap(_chatRooms[index]);
            },
            child: ListTile(
              title: Text(
                  '${_chatRooms[index].roomId}: ${_chatRooms[index].name}'),
              subtitle: Text('owner: ${_chatRooms[index].owner}'),
            ),
          );
        },
        separatorBuilder: (context, index) {
          return const Divider(height: 0.4, indent: 5);
        },
        itemCount: _chatRooms.length,
      ),
    );
  }

  void onTileTap(ChatRoom room) {
    Navigator.of(context)
        .pushNamed('chatroom_page', arguments: [room.roomId, room.owner]);
  }
}
