import 'package:chatroom_uikit/chatroom_uikit.dart';
import 'package:flutter/material.dart';

class NextPage extends StatefulWidget {
  const NextPage({super.key});

  @override
  State<NextPage> createState() => _NextPageState();
}

class _NextPageState extends State<NextPage> {
  ChatRoomController controller = ChatRoomController(roomId: 'roomId');
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('Plugin example app'),
        leading: ElevatedButton(
          child: const Text("<"),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        actions: [
          UnconstrainedBox(
            child: InkWell(
              child: const Icon(Icons.more_horiz),
              onTap: () {
                // controller.hiddenInputBar();
                controller.sendLocalMarqueeNotification(content: "你好你好你好");
                controller.sendLocalMarqueeNotification(
                    content: "我是长内容我是长内容我是长内容我是长内容我是长内容我是长内容我是长内容！");
                controller.sendLocalGiftNotification(
                    fromUserId: 'fromUserId', giftId: 'giftId');
              },
            ),
          )
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('images/chatBG.png'),
            fit: BoxFit.fill,
          ),
        ),
        child: ChatRoomUIKit(
          inputBar: ChatInputBar(
            trailing: [],
            onSend: ({required String msg}) {
              controller.sendMessage(
                content: msg,
              );
            },
          ),
          controller: controller,
          child: Stack(
            children: [
              Positioned(
                top: MediaQuery.of(context).viewInsets.top + 10,
                height: 20,
                left: 200,
                right: 80,
                child: ChatRoomMarqueeView(
                  icon: Image.asset('images/speaker.png'),
                  backgroundColor: Colors.red,
                  textStyle: const TextStyle(
                    height: 1.3,
                    color: Colors.white,
                  ),
                ),
              ),
              const Positioned(
                top: 100,
                left: 0,
                right: 0,
                height: 120,
                child: ChatRoomGiftView(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
