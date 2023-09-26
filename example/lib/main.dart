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
  ChatRoomController controller = ChatRoomController(roomId: 'roomId');

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      builder: (context, child) {
        return ChatUIKitTheme(
          child: child!,
        );
      },
      home: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: const Text('Plugin example app'),
          actions: [
            UnconstrainedBox(
              child: InkWell(
                child: const Icon(Icons.more_horiz),
                onTap: () {
                  controller.sendLocalMarqueeNotification(
                      content: "我是长内容我是长内容我是长内容我是长内容我是长内容我是长内容我是长内容！");
                  // controller?.addRevolvingLantern(
                  //     "我是长内容我是长内容我是长内容我是长内容我是长内容我是长内容我是长内容！");
                },
              ),
            )
          ],
        ),
        body: ChatRoomUIKit(
          controller: controller,
          child: Stack(
            children: [
              InkWell(
                onTap: () {},
                child: Container(
                  color: Colors.green,
                ),
              ),
              Positioned(
                top: MediaQuery.of(context).viewInsets.top,
                height: 20,
                width: MediaQuery.of(context).size.width,
                child: const ChatRoomMarqueeView(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
