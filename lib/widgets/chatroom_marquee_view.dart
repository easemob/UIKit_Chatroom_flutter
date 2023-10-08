import 'dart:async';

import 'package:chatroom_uikit/chatroom_uikit.dart';
import 'package:flutter/material.dart';

typedef MarqueeWidgetBuilder = Widget Function(List<String> list);

class ChatRoomMarqueeView extends StatefulWidget
    implements PreferredSizeWidget {
  const ChatRoomMarqueeView({
    this.icon,
    this.textStyle,
    this.backgroundColor,
    super.key,
  });

  final Widget? icon;
  final TextStyle? textStyle;
  final Color? backgroundColor;

  @override
  State<ChatRoomMarqueeView> createState() => _ChatRoomMarqueeViewState();

  @override
  Size get preferredSize => const Size.fromHeight(20);
}

class _ChatRoomMarqueeViewState extends State<ChatRoomMarqueeView> {
  ScrollController scrollController = ScrollController();

  double maxSize = 0;
  List<String> showList = [];
  String? current;
  Timer? timer;
  bool isPlaying = false;
  bool needScroll = false;

  StreamSubscription<dynamic>? _sub;

  @override
  void initState() {
    super.initState();
    ChatRoomUIKit.of(context)?.setMarqueeCallback(onMarqueeMsgReceived);
  }

  @override
  void dispose() {
    scrollController.dispose();
    timer?.cancel();
    current = null;
    isPlaying = false;
    _sub?.cancel();
    super.dispose();
  }

  void onMarqueeMsgReceived(String str) {
    showList.add(str);
    play();
  }

  @override
  Widget build(BuildContext context) {
    Widget content;
    if (!isPlaying) {
      content = Container();
    } else {
      content = Text(
        current ?? '',
        style: widget.textStyle,
      );

      if (needScroll) {
        content = ListView(
          controller: scrollController,
          scrollDirection: Axis.horizontal,
          children: [content],
        );
      }

      content = Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          () {
            if (widget.icon != null) {
              return Container(
                padding: const EdgeInsets.only(left: 5, top: 0, bottom: 1),
                height: 20,
                decoration: BoxDecoration(
                  color: widget.backgroundColor,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(10),
                    bottomLeft: Radius.circular(10),
                  ),
                ),
                clipBehavior: Clip.hardEdge,
                child: SizedBox(
                  width: 14,
                  height: 14,
                  child: widget.icon!,
                ),
              );
            }
            return Container();
          }(),
          () {
            Widget ret = Container(
              padding: EdgeInsets.only(
                  left: widget.icon == null ? 9 : 3,
                  right: 10,
                  top: 0,
                  bottom: 1),
              height: 20,
              decoration: BoxDecoration(
                color: widget.backgroundColor,
                borderRadius: BorderRadius.only(
                  topLeft: widget.icon == null
                      ? const Radius.circular(10)
                      : Radius.zero,
                  bottomLeft: widget.icon == null
                      ? const Radius.circular(10)
                      : Radius.zero,
                  topRight: const Radius.circular(10),
                  bottomRight: const Radius.circular(10),
                ),
              ),
              clipBehavior: Clip.hardEdge,
              child: content,
            );

            if (needScroll) {
              ret = Expanded(
                child: ret,
              );
            }
            return ret;
          }(),
        ],
      );
    }

    content = WillPopScope(
      child: content,
      onWillPop: () async {
        showList.clear();
        ChatRoomUIKit.of(context)?.setMarqueeCallback(null);
        return false;
      },
    );

    return LayoutBuilder(
      builder: (context, constraints) {
        maxSize = constraints.maxWidth;
        return content;
      },
    );
  }

  void play() {
    if (showList.isEmpty || isPlaying) return;
    isPlaying = true;
    current = showList.removeAt(0);
    TextPainter painter = TextPainter(
      text: TextSpan(
        text: current,
        style: widget.textStyle,
      ),
      textDirection: TextDirection.ltr,
    )..layout(minWidth: 0, maxWidth: double.infinity);

    final length = maxSize - (widget.icon != null ? 38 : 19);

    needScroll = painter.size.width > length;

    if (needScroll) {
      _showMarquee();
    } else {
      _showLabel();
    }
  }

  void _showMarquee() async {
    update();
    await Future.delayed(const Duration(seconds: 2));
    double maxScrollExtent = scrollController.position.maxScrollExtent;
    timer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      if (scrollController.positions.isEmpty) {
        timer.cancel();
        return;
      }

      double pixels = scrollController.position.pixels;
      double nextPosition = pixels + 10;
      if (nextPosition > maxScrollExtent) {
        scrollController.animateTo(maxScrollExtent,
            duration: const Duration(milliseconds: 300), curve: Curves.linear);

        timer.cancel();
        _sub = Future.delayed(const Duration(seconds: 2))
            .then((value) {
              clear();
              return Future.delayed(const Duration(milliseconds: 500));
            })
            .then((value) {
              play();
            })
            .asStream()
            .listen(
              (event) {},
            );
        return;
      }

      scrollController.animateTo(nextPosition,
          duration: const Duration(milliseconds: 300), curve: Curves.linear);
    });
  }

  void _showLabel() async {
    update();
    _sub = Future.delayed(const Duration(seconds: 2))
        .then((value) {
          clear();
          return Future.delayed(const Duration(milliseconds: 500));
        })
        .then((value) {
          play();
        })
        .asStream()
        .listen(
          (event) {},
        );
  }

  void clear() {
    if (scrollController.positions.isNotEmpty) {
      scrollController.jumpTo(0);
    }

    current = null;
    isPlaying = false;
    update();
  }

  void update() {
    if (mounted) {
      setState(() {});
    }
  }
}
