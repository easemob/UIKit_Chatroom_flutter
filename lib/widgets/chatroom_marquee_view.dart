import 'dart:async';

import 'package:chatroom_uikit/chatroom_uikit.dart';
import 'package:flutter/material.dart';

typedef MarqueeWidgetBuilder = Widget Function(List<String> list);

class ChatRoomMarqueeView extends StatefulWidget
    implements PreferredSizeWidget {
  const ChatRoomMarqueeView({
    super.key,
  });

  @override
  State<ChatRoomMarqueeView> createState() => _ChatRoomMarqueeViewState();

  @override
  Size get preferredSize => const Size.fromHeight(20);
}

class _ChatRoomMarqueeViewState extends State<ChatRoomMarqueeView> {
  ScrollController scrollController = ScrollController();

  List<String> showList = [];
  String? current;
  Timer? timer;
  bool isPlaying = false;
  bool needScroll = false;

  @override
  void initState() {
    super.initState();
    ChatRoomUIKit.of(context).setMarqueeCallback(onMarqueeMsgReceived);
  }

  @override
  void dispose() {
    scrollController.dispose();
    timer?.cancel();
    current = null;
    isPlaying = false;
    super.dispose();
  }

  void onMarqueeMsgReceived(String str) {
    showList.add(str);
    play();
  }

  @override
  Widget build(BuildContext context) {
    if (!isPlaying) {
      return Container();
    }

    Widget content = ListView(
      controller: scrollController,
      scrollDirection: Axis.horizontal,
      children: [Text(current ?? '')],
    );
    content = Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Icon(Icons.abc),
        Expanded(child: content),
      ],
    );
    content = SizedBox(height: 20, child: content);

    return content;
  }

  void play() {
    if (showList.isEmpty || isPlaying) return;
    isPlaying = true;
    current = showList.removeAt(0);
    TextPainter painter = TextPainter(
      text: TextSpan(
        text: current,
      ),
      textDirection: TextDirection.ltr,
    )..layout(minWidth: 0, maxWidth: double.infinity);

    needScroll = painter.size.width > MediaQuery.of(context).size.width;

    if (needScroll) {
      _showMarquee();
    } else {
      _showLabel();
    }
  }

  void _showMarquee() async {
    setState(() {});
    await Future.delayed(const Duration(seconds: 2));

    timer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      if (scrollController.positions.isEmpty) {
        timer.cancel();
        return;
      }
      double maxScrollExtent = scrollController.position.maxScrollExtent;
      double pixels = scrollController.position.pixels;
      double nextPosition = pixels + 10;
      if (nextPosition >= maxScrollExtent) {
        timer.cancel();
        Future.delayed(const Duration(seconds: 2)).then((value) async {
          clear();
          await Future.delayed(const Duration(milliseconds: 500));
          play();
        });
        return;
      }

      scrollController.animateTo(nextPosition,
          duration: const Duration(milliseconds: 300), curve: Curves.linear);
    });
  }

  void _showLabel() {
    setState(() {});
    Future.delayed(const Duration(seconds: 3)).then((value) async {
      clear();
      await Future.delayed(const Duration(milliseconds: 500));
      play();
    });
  }

  void clear() {
    if (scrollController.positions.isNotEmpty) {
      scrollController.jumpTo(0);
    }

    current = null;
    isPlaying = false;
    setState(() {});
  }
}
