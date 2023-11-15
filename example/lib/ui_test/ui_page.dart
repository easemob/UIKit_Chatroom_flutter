import 'dart:convert';

import 'package:chatroom_uikit/chatroom_uikit.dart';
import 'package:chatroom_uikit_example/ui_test/my_notification.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class UIPage extends StatefulWidget {
  const UIPage({super.key});

  @override
  State<UIPage> createState() => _UIPageState();
}

class _UIPageState extends State<UIPage> {
  late ChatroomController controller;

  bool isLight = false;
  @override
  void initState() {
    super.initState();
    controller = ChatroomController(
      roomId: 'roomId',
      ownerId: 'ownerId',
      giftControllers: () async {
        List<DefaultGiftPageController> service = [];
        final value = await rootBundle.loadString('data/Gifts.json');
        Map<String, dynamic> map = json.decode(value);
        for (var element in map.keys.toList()) {
          service.add(
            DefaultGiftPageController(
              title: element,
              gifts: () {
                List<GiftEntityProtocol> list = [];
                map[element].forEach((element) {
                  GiftEntityProtocol? gift = ChatroomUIKitClient
                      .instance.giftService
                      .giftFromJson(element);
                  if (gift != null) {
                    list.add(gift);
                  }
                });
                return list;
              }(),
            ),
          );
        }
        return service;
      }(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('Plugin example app'),
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('images/chat_bg.png'),
            fit: BoxFit.fill,
          ),
        ),
        child: InkWell(
          onTap: () {
            controller.hiddenInputBar();
          },
          child: ChatRoomUIKit(
            controller: controller,
            inputBar: ChatInputBar(
              trailing: [
                InkWell(
                  onTap: () => {
                    controller.showParticipantPages(),
                  },
                  child: const Icon(
                    Icons.more_vert,
                    color: Colors.white,
                  ),
                ),
                InkWell(
                  onTap: () {
                    controller.showGiftSelectPages();
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(3),
                    child: Image.asset('images/send_gift.png'),
                  ),
                ),
              ],
            ),
            child: (context) {
              return Stack(
                children: [
                  Positioned(
                    top: MediaQuery.of(context).viewInsets.top + 10,
                    height: 20,
                    left: 20,
                    right: 20,
                    child: ChatroomGlobalBroadcastView(
                      icon: Image.asset('images/speaker.png'),
                    ),
                  ),
                  Positioned(
                    top: MediaQuery.of(context).viewInsets.top + 100,
                    height: 20,
                    left: 20,
                    right: 20,
                    child: Center(
                      child: Switch(
                          value: isLight,
                          onChanged: (value) {
                            isLight = value;
                            MyNotification(isLight).dispatch(context);
                            setState(() {});
                          },
                          activeColor: Colors.white),
                    ),
                  ),
                  const Positioned(
                    left: 16,
                    width: 227,
                    height: 84,
                    bottom: 300,
                    child: ChatroomGiftMessageListView(),
                  ),
                  const Positioned(
                    left: 16,
                    right: 78,
                    height: 204,
                    bottom: 90,
                    child: ChatroomMessageListView(),
                  )
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
