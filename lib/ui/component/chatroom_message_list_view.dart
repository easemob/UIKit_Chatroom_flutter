import '../../inner_headers.dart';

import 'package:flutter/material.dart';



class ChatroomMessageListView extends StatefulWidget {
  const ChatroomMessageListView({
    this.onTap,
    this.onLongPress,
    this.itemBuilder,
    this.controller,
    super.key,
  });

  final Widget Function(Message msg)? itemBuilder;
  final void Function(BuildContext content, Message msg)? onTap;
  final void Function(BuildContext content, Message msg)? onLongPress;
  final ChatroomMessageListController? controller;

  @override
  State<ChatroomMessageListView> createState() =>
      _ChatroomMessageListViewState();
}

class _ChatroomMessageListViewState extends State<ChatroomMessageListView>
    with ChatroomResponse, GiftResponse, ChatUIKitThemeMixin {
  List<Message> list = [];
  bool isScrolling = false;
  bool canScroll = true;
  ValueNotifier<int> unreadCount = ValueNotifier(0);
  final scrollController = ScrollController();

  late ChatroomMessageListController controller;

  @override
  void initState() {
    super.initState();
    ChatroomUIKitClient.instance.roomService.bindResponse(this);
    ChatroomUIKitClient.instance.giftService.bindResponse(this);

    controller = widget.controller ?? DefaultMessageListController();
    scrollController.addListener(() {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        if (scrollController.hasClients) {
          if (scrollController.offset >=
              scrollController.position.maxScrollExtent - 30) {
            canScroll = true;
            if (unreadCount.value != 0) {
              unreadCount.value = 0;
            }
          } else {
            canScroll = false;
          }
        }
      });
    });
  }

  @override
  void dispose() {
    scrollController.dispose();
    ChatroomUIKitClient.instance.roomService.unbindResponse(this);
    ChatroomUIKitClient.instance.giftService.unbindResponse(this);
    super.dispose();
  }

  @override
  void onMessageReceived(String roomId, List<Message> msgs) {
    if (ChatRoomUIKit.roomController(context)?.roomId == roomId) {
      setState(() {
        list.addAll(msgs);
      });
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        if (!canScroll &&
            !msgs
                .any((element) => element.direction == MessageDirection.SEND)) {
          unreadCount.value++;
          return;
        } else {
          canScroll = true;
          scrollController.animateTo(
            scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 100),
            curve: Curves.linear,
          );
        }
      });
    }
  }

  @override
  void receiveGift(
    String roomId,
    Message msg,
  ) {
    if (ChatRoomSettings.enableMsgListGift) {
      onMessageReceived(roomId, [msg]);
    }
  }

  @override
  void onUserJoined(String roomId, List<Message> msgs) {
    onMessageReceived(roomId, msgs);
  }

  @override
  void onMessageRecalled(String roomId, List<Message> msgs) {
    if (ChatRoomUIKit.roomController(context)?.roomId == roomId) {
      setState(() {
        list.removeWhere((element) {
          return msgs.any((msg) => msg.msgId == element.msgId);
        });
      });
    }
  }

  @override
  void onMessageTransformed(String roomId, Message message) {
    if (roomId == ChatRoomUIKit.roomController(context)?.roomId) {
      setState(() {
        final index =
            list.indexWhere((element) => element.msgId == message.msgId);
        if (index > -1) {
          list[index] = message;
        }
      });
    }
  }

  void tapAction(Message msg) {
    widget.onTap?.call(context, msg);
  }

  void longPressAction(Message msg) {
    if (widget.onLongPress != null) {
      widget.onLongPress?.call(context, msg);
    } else {
      if (msg.isGiftMsg() || msg.isJoinNotify()) return;
      String? roomId = ChatRoomUIKit.roomController(context)?.roomId;
      String? ownerId = ChatRoomUIKit.roomController(context)?.ownerId;

      List<ChatBottomSheetItem>? actions = controller.listItemLongPressed(
        context: context,
        message: msg,
        roomId: roomId!,
        ownerId: ownerId!,
      );

      if (actions?.isNotEmpty == true) {
        showModalBottomSheet(
          context: context,
          clipBehavior: Clip.hardEdge,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(16.0),
              topRight: Radius.circular(16.0),
            ),
          ),
          builder: (context) {
            return ChatBottomSheetWidget(
              items: actions!,
            );
          },
        );
      }
    }
  }

  @override
  Widget themeBuilder(BuildContext context, ChatUIKitTheme theme) {
    Widget content = ListView.separated(
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.zero,
      controller: scrollController,
      itemCount: list.length,
      itemBuilder: (context, index) {
        final msg = list[index];
        return InkWell(
          key: ValueKey(msg.msgId),
          onLongPress: () {
            longPressAction(msg);
          },
          onTap: () {
            tapAction(msg);
          },
          child: widget.itemBuilder?.call(msg) ??
              () {
                if (msg.isGiftMsg()) {
                  return ChatRoomGiftListTile(msg);
                } else if (msg.isJoinNotify()) {
                  return ChatRoomJoinListTile(msg);
                } else {
                  if (msg.body.type == BodyType.TXT) {
                    return ChatRoomTextListTile(msg);
                  } else {
                    return const SizedBox();
                  }
                }
              }(),
        );
      },
      findChildIndexCallback: (key) {
        final index = list.indexWhere((element) {
          return element.msgId == (key as ValueKey<String>).value;
        });

        return index > -1 ? index : null;
      },
      separatorBuilder: (context, index) {
        return const SizedBox(height: 4);
      },
    );

    content = NotificationListener(
      child: content,
      onNotification: (notification) {
        if (notification is ScrollStartNotification) {
          isScrolling = true;
        }
        if (notification is ScrollEndNotification) {
          isScrolling = false;
        }
        return false;
      },
    );

    content = Stack(
      children: [
        content,
        Positioned(
          bottom: 0,
          left: 0,
          height: 26,
          // right: 0,
          child: unreadBubble(),
        )
      ],
    );

    return content;
  }

  Widget unreadBubble() {
    return ValueListenableBuilder(
      valueListenable: unreadCount,
      builder: (context, value, child) {
        if (value == 0) return const Offstage();

        Widget content = Container(
          constraints: const BoxConstraints(maxHeight: 26, maxWidth: 181),
          padding: const EdgeInsets.fromLTRB(6, 4, 16, 4),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(13),
            color: (theme.color.isDark
                ? theme.color.neutralColor1
                : theme.color.neutralColor98),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.keyboard_arrow_down,
                size: 18,
                color: (theme.color.isDark
                    ? theme.color.primaryColor6
                    : theme.color.primaryColor5),
              ),
              const SizedBox(width: 2),
              Expanded(
                flex: 0,
                child: Text(
                  '${value >= 99 ? '99+' : value} ${ChatroomLocal.newMessage.getString(context)}',
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontWeight: theme.font.labelMedium.fontWeight,
                    fontSize: theme.font.labelMedium.fontSize,
                    color: (theme.color.isDark
                        ? theme.color.primaryColor6
                        : theme.color.primaryColor5),
                  ),
                ),
              )
            ],
          ),
        );

        content = Align(
          alignment: Alignment.bottomLeft,
          child: content,
        );

        content = InkWell(
          onTap: () {
            scrollController.animateTo(
                scrollController.position.maxScrollExtent,
                duration: const Duration(microseconds: 100),
                curve: Curves.linear);
          },
          child: content,
        );

        return content;
      },
    );
  }
}

class ChatRoomJoinListTile extends StatefulWidget {
  const ChatRoomJoinListTile(this.msg, {super.key});
  final Message msg;
  @override
  State<ChatRoomJoinListTile> createState() => _ChatRoomJoinListTileState();
}

class _ChatRoomJoinListTileState extends State<ChatRoomJoinListTile>
    with ChatUIKitThemeMixin {
  @override
  Widget themeBuilder(BuildContext context, ChatUIKitTheme theme) {
    return ChatRoomListTile(
      widget.msg,
      child: TextSpan(
          text: " ${ChatroomLocal.joined.getString(context)}",
          style: TextStyle(
            color: theme.color.isDark
                ? theme.color.secondaryColor7
                : theme.color.secondaryColor8,
          )),
    );
  }
}

class ChatRoomGiftListTile extends StatefulWidget {
  const ChatRoomGiftListTile(this.msg, {super.key});
  final Message msg;

  @override
  State<ChatRoomGiftListTile> createState() => _ChatRoomGiftListTileState();
}

class _ChatRoomGiftListTileState extends State<ChatRoomGiftListTile> {
  @override
  Widget build(BuildContext context) {
    if (widget.msg.getGiftEntity() != null) {
      UserInfoProtocol? user = widget.msg.getUserEntity();
      GiftEntityProtocol gift = widget.msg.getGiftEntity()!;
      return ChatRoomListTile(
        widget.msg,
        child: TextSpan(
          children: [
            const WidgetSpan(child: Padding(padding: EdgeInsets.only(left: 4))),
            TextSpan(
                text:
                    '${ChatroomLocal.giftSent.getString(context)} \'@${gift.giftName}\''),
            WidgetSpan(
              child: Container(
                clipBehavior: Clip.hardEdge,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(9)),
                ),
                width: 18,
                height: 18,
                margin: const EdgeInsets.only(left: 4),
                child: () {
                  if (user?.avatarURL?.isNotEmpty == true) {
                    return ChatImageLoader.networkImage(
                      image: gift.giftIcon,
                      size: 18,
                      placeholderWidget:
                          (ChatRoomSettings.defaultGiftIcon == null)
                              ? Container()
                              : Image.asset(
                                  ChatRoomSettings.defaultGiftIcon!,
                                ),
                    );
                  } else {
                    return ChatImageLoader.avatar(size: 18);
                  }
                }(),
              ),
              alignment: PlaceholderAlignment.middle,
            ),
          ],
        ),
      );
    } else {
      return Container();
    }
  }
}

class ChatRoomTextListTile extends StatefulWidget {
  const ChatRoomTextListTile(this.msg, {super.key});
  final Message msg;

  @override
  State<ChatRoomTextListTile> createState() => _ChatRoomTextListTileState();
}

class _ChatRoomTextListTileState extends State<ChatRoomTextListTile> {
  String? content;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.msg.body.type == BodyType.TXT) {
      TextBody body = widget.msg.body as TextBody;
      body.translations?.forEach((key, value) {
        if (key.contains(
            LanguageConvertor.instance.targetLanguage(context).code)) {
          content = value;
        }
      });

      content ??= body.content;
    }

    content = EmojiMapping.replaceEmojiToImage(content!);

    List<InlineSpan> list = [];
    List<EmojiIndex> indexList = [];

    String tmpStr = content!;
    for (var element in EmojiMapping.emojiImages) {
      int indexFirst = 0;
      do {
        indexFirst = tmpStr.indexOf(element, indexFirst);
        if (indexFirst == -1) {
          break;
        }

        indexList.add(EmojiIndex(
          emoji: element,
          index: indexFirst,
          length: element.length,
        ));
        indexFirst += element.length;
      } while (indexFirst != -1);
    }

    indexList.sort((a, b) => a.index.compareTo(b.index));
    EmojiIndex? lastIndex;
    for (final emojiIndex in indexList) {
      if (lastIndex == null) {
        list.add(TextSpan(text: content!.substring(0, emojiIndex.index)));
      } else {
        list.add(
          TextSpan(
            text: content!.substring(
              lastIndex.index + lastIndex.length,
              emojiIndex.index,
            ),
          ),
        );
      }
      list.add((WidgetSpan(
          child: ChatImageLoader.emoji(emojiIndex.emoji, size: 20))));

      lastIndex = emojiIndex;
    }

    if (lastIndex != null) {
      list.add(
        TextSpan(
          text: content!.substring(lastIndex.index + lastIndex.emoji.length),
        ),
      );
    } else {
      list.add(
        TextSpan(text: content),
      );
    }

    return ChatRoomListTile(
      widget.msg,
      child: TextSpan(
        children: [
          const WidgetSpan(child: Padding(padding: EdgeInsets.only(left: 4))),
          TextSpan(children: list),
        ],
      ),
    );
  }
}

class ChatRoomListTile extends StatefulWidget {
  const ChatRoomListTile(this.msg, {this.child, super.key});
  final Message msg;
  final TextSpan? child;
  @override
  State<ChatRoomListTile> createState() => _ChatRoomListTileState();
}

class _ChatRoomListTileState extends State<ChatRoomListTile>
    with ChatUIKitThemeMixin {
  @override
  Widget themeBuilder(BuildContext context, ChatUIKitTheme theme) {
    List<InlineSpan> list = [];
    // time
    if (ChatRoomSettings.enableMsgListTime) {
      list.add(TextSpan(text: TimeTool.timeStrByMs(widget.msg.serverTime)));
    }

    UserInfoProtocol? user =
        ChatroomContext.instance.userInfosMap[widget.msg.from];

    if (ChatRoomSettings.enableMsgListIdentify) {
      if (user?.identify?.isNotEmpty == true) {
        list.add(WidgetSpan(
          child: () {
            if (user?.identify?.isNotEmpty == true) {
              return Container(
                clipBehavior: Clip.hardEdge,
                decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(7.5))),
                margin: const EdgeInsets.only(left: 4),
                width: 15,
                height: 15,
                child: ChatImageLoader.networkImage(
                  image: user?.identify ?? '',
                  size: 15,
                  placeholderWidget: (ChatRoomSettings.defaultIdentify == null)
                      ? Container()
                      : Image.asset(ChatRoomSettings.defaultIdentify!,
                          width: 15, height: 15),
                ),
              );
            } else {
              return Container();
            }
          }(),
          alignment: PlaceholderAlignment.middle,
        ));
      }
    }

    if (ChatRoomSettings.enableMsgListAvatar) {
      list.add(
        WidgetSpan(
          child: ChatAvatar(
            width: 18,
            height: 18,
            user: user,
            margin: const EdgeInsets.only(left: 4),
          ),
          alignment: PlaceholderAlignment.middle,
        ),
      );
    }
    if (ChatRoomSettings.enableMsgListNickname) {
      list.add(
        TextSpan(children: [
          const WidgetSpan(
            child: Padding(
              padding: EdgeInsets.only(left: 4),
            ),
          ),
          TextSpan(
            text: user?.nickname?.isNotEmpty == true
                ? user?.nickname
                : widget.msg.from,
            style: TextStyle(
              color: (theme.color.isDark
                  ? theme.color.primaryColor8
                  : theme.color.primaryColor8),
              fontWeight: theme.font.labelMedium.fontWeight,
              fontSize: theme.font.labelMedium.fontSize,
            ),
          ),
        ]),
      );
    }

    if (widget.child != null) {
      list.add(widget.child!);
    }

    Widget content = Text.rich(
      TextSpan(
        style: TextStyle(
          height: 1,
          color: Colors.white,
          fontSize: theme.font.bodyMedium.fontSize,
          fontWeight: theme.font.bodyMedium.fontWeight,
        ),
        children: list,
      ),
    );

    content = Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: theme.color.isDark
              ? theme.color.barrageColor1
              : theme.color.barrageColor2),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: content,
    );

    content = Align(
      alignment: Alignment.centerLeft,
      child: content,
    );

    return content;
  }
}
