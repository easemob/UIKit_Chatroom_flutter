import 'package:chat_uikit_theme/chat_uikit_theme.dart';
import 'package:flutter/material.dart';

import 'package:chatroom_uikit/chatroom_uikit.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ChatRoomController controller = ChatRoomController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      builder: (context, child) {
        return ChatUIKitTheme(
          // color: ChatUIKitColor.dark(),
          child: child!,
        );
      },
      home: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: ChatRoomUIKit(
          roomId: 'roomId',
          controller: controller,
          child: const Stack(
            children: [
              Center(
                child: Text('ChatRoomUIKit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
