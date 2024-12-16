import 'dart:async';
import 'dart:math';

import '../../inner_headers.dart';

import 'package:flutter/material.dart';

typedef ChatroomGiftMessageListViewBuilder = Widget? Function({
  String senderId,
  GiftEntityProtocol gift,
  UserInfoProtocol? user,
});

class ChatroomGiftMessageListView extends StatefulWidget {
  const ChatroomGiftMessageListView({
    this.giftWidgetBuilder,
    this.placeholder,
    super.key,
  });

  final ChatroomGiftMessageListViewBuilder? giftWidgetBuilder;
  final String? placeholder;

  @override
  State<ChatroomGiftMessageListView> createState() =>
      _ChatroomGiftMessageListViewState();
}

const double totalHeight = 84;
const double originHeight = 44;
const double movedHeight = 36;

class _ChatroomGiftMessageListViewState
    extends State<ChatroomGiftMessageListView>
    with GiftResponse, ChatUIKitThemeMixin {
  List<GiftReceiveModel> list = [];

  ScrollController controller = ScrollController();

  String? get placeholder => widget.placeholder;

  @override
  void initState() {
    super.initState();
    ChatroomUIKitClient.instance.giftService.bindResponse(this);
  }

  @override
  void dispose() {
    ChatroomUIKitClient.instance.giftService.unbindResponse(this);
    for (var element in list) {
      element.stopTimer();
    }
    controller.dispose();
    super.dispose();
  }

  @override
  Widget themeBuilder(BuildContext context, ChatUIKitTheme theme) {
    Widget content = CustomScrollView(
      physics: const NeverScrollableScrollPhysics(),
      controller: controller,
      slivers: [
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (BuildContext context, int index) {
              return Container(
                height: totalHeight,
                color: Colors.transparent,
              );
            },
            childCount: 1,
          ),
        ),
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (BuildContext context, int index) {
              return GiftReceiveItemWidget(
                key: ValueKey(list[index].randomKey),
                height: list.length - 1 == index ? originHeight : movedHeight,
                child: widget.giftWidgetBuilder?.call(
                      gift: list[index].gift,
                      user: list[index].userInfo,
                    ) ??
                    GiftItem(
                      list[index].gift,
                      list[index].fromUserId,
                      userInfo: list[index].userInfo,
                    ),
              );
            },
            childCount: list.length,
            findChildIndexCallback: (key) {
              final index = list.indexWhere((element) {
                return element.randomKey == (key as ValueKey<String>).value;
              });
              return index > -1 ? index : null;
            },
          ),
        ),
      ],
    );

    content = SizedBox(
      height: totalHeight,
      child: content,
    );

    return content;
  }

  @override
  void receiveGift(Object roomId, Message msg) {
    GiftEntityProtocol gift = msg.getGiftEntity()!;
    String senderId = msg.from!;
    UserInfoProtocol? user = msg.getUserEntity();
    final model = GiftReceiveModel(
      gift,
      senderId,
      userInfo: user,
      onTimeOut: (item) {
        final index = list.indexWhere((element) => element.isRunning);
        if (index == -1) {
          setState(() {
            list.clear();
          });
        }
      },
    );
    setState(() {
      list.add(model);
    });
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      controller.animateTo(
        controller.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.ease,
      );
    });
  }
}

class GiftReceiveItemWidget extends StatefulWidget {
  const GiftReceiveItemWidget({
    required this.height,
    this.hiddenTime = 3,
    this.child,
    super.key,
  });

  final double height;
  final int hiddenTime;
  final Widget? child;

  @override
  State<GiftReceiveItemWidget> createState() => _GiftReceiveItemWidgetState();
}

class _GiftReceiveItemWidgetState extends State<GiftReceiveItemWidget> {
  bool isHidden = false;
  Timer? timer;

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: isHidden ? 0 : 1,
      duration: const Duration(milliseconds: 300),
      child: AnimatedScale(
        curve: Curves.decelerate,
        alignment: Alignment.bottomLeft,
        scale: widget.height / originHeight,
        duration: const Duration(milliseconds: 300),
        child: widget.child,
      ),
    );
  }

  void startTimer() {
    timer = Timer.periodic(Duration(seconds: widget.hiddenTime), (timer) {
      stopTimer();
      setState(() {
        isHidden = true;
      });
    });
  }

  void stopTimer() {
    timer?.cancel();
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }
}

class GiftReceiveModel {
  GiftReceiveModel(
    this.gift,
    this.fromUserId, {
    this.userInfo,
    this.time = 5,
    this.onTimeOut,
  }) {
    startTimer();
  }
  final String randomKey = Random().nextInt(9999999).toString();
  final int time;

  final GiftEntityProtocol gift;
  final UserInfoProtocol? userInfo;
  final String fromUserId;

  final void Function(GiftReceiveModel item)? onTimeOut;
  Timer? timer;
  bool isRunning = false;

  void startTimer() {
    isRunning = true;
    timer = Timer.periodic(Duration(seconds: time), (timer) {
      stopTimer();
      isRunning = false;
      onTimeOut?.call(this);
    });
  }

  void stopTimer() {
    timer?.cancel();
  }
}

class GiftItem extends StatelessWidget {
  const GiftItem(
    this.gift,
    this.fromUserId, {
    this.count = 1,
    this.userInfo,
    super.key,
  });
  final String fromUserId;
  final GiftEntityProtocol gift;
  final int count;
  final UserInfoProtocol? userInfo;

  @override
  Widget build(BuildContext context) {
    final theme = ChatUIKitTheme.instance;
    return Align(
      alignment: Alignment.bottomLeft,
      child: Container(
        margin: const EdgeInsets.only(top: 4),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(22),
            color: theme.color.barrageColor1),
        height: originHeight,
        child: item(context),
      ),
    );
  }

  Widget item(BuildContext context) {
    final theme = ChatUIKitTheme.instance;
    List<Widget> list = [];

    Widget content = ChatAvatar(
      width: 36,
      height: 36,
      user: userInfo,
      margin: const EdgeInsets.all(4),
    );

    list.add(content);

    // 名字/礼物名称
    content = Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              flex: 0,
              child: Text(
                userInfo?.nickname ?? userInfo?.userId ?? fromUserId,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontWeight: theme.font.labelSmall.fontWeight,
                  fontSize: theme.font.labelSmall.fontSize,
                  color: Colors.white,
                ),
              ),
            )
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              flex: 0,
              child: Text(
                '${ChatroomLocal.giftSent.getString(context)} \'${gift.giftName}\'',
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontWeight: theme.font.bodyExtraSmall.fontWeight,
                  fontSize: theme.font.bodyExtraSmall.fontSize,
                  color: Colors.white,
                ),
              ),
            )
          ],
        ),
      ],
    );

    list.add(
      Expanded(
        flex: 0,
        child: content,
      ),
    );

    // 礼物图片
    list.add(ChatImageLoader.networkImage(
      image: gift.giftIcon,
      size: 40,
      fit: BoxFit.fill,
      placeholderWidget: ChatImageLoader.defaultGift(),
    ));

    list.add(
      Padding(
        padding: const EdgeInsets.all(6),
        child: RichText(
          text: TextSpan(
            text: 'x',
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w900,
              fontSize: 14,
              fontStyle: FontStyle.italic,
            ),
            children: [
              TextSpan(
                text: gift.count.toString(),
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w900,
                  fontSize: 18,
                  fontStyle: FontStyle.italic,
                ),
              )
            ],
          ),
        ),
      ),
    );

    content = Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: list,
    );

    content = Padding(
      padding: const EdgeInsets.only(right: 4),
      child: content,
    );

    return content;
  }
}
