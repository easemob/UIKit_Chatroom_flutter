import 'package:chatroom_uikit/chatroom_uikit.dart';

import 'package:chatroom_uikit/utils/extension.dart';
import 'package:chatroom_uikit/utils/time_tool.dart';
import 'package:chatroom_uikit/ui/component/chatroom_report_list_view.dart';

import 'package:flutter/material.dart';

class ChatroomMessageListView extends StatefulWidget {
  const ChatroomMessageListView({
    this.onTap,
    this.onLongPress,
    this.itemBuilder,
    this.reportController,
    super.key,
  });

  final Widget Function(ChatMessage msg)? itemBuilder;
  final void Function(BuildContext content, ChatMessage msg)? onTap;
  final void Function(BuildContext content, ChatMessage msg)? onLongPress;
  final DefaultReportController? reportController;
  @override
  State<ChatroomMessageListView> createState() =>
      _ChatroomMessageListViewState();
}

class _ChatroomMessageListViewState extends State<ChatroomMessageListView>
    with ChatroomResponse, GiftResponse {
  List<ChatMessage> list = [];
  bool isScrolling = false;
  bool canScroll = true;
  ValueNotifier<int> unreadCount = ValueNotifier(0);
  final scrollController = ScrollController();

  late ChatReportController reportController;

  @override
  void initState() {
    super.initState();
    ChatRoomUIKitClient.instance.roomService.bindResponse(this);
    ChatRoomUIKitClient.instance.giftService.bindResponse(this);

    reportController = widget.reportController ?? DefaultReportController();
    scrollController.addListener(() {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        if (scrollController.offset >=
            scrollController.position.maxScrollExtent - 30) {
          canScroll = true;
          if (unreadCount.value != 0) {
            unreadCount.value = 0;
          }
        } else {
          canScroll = false;
        }
      });
    });
  }

  void hasRecalled(String msgId) {
    list.removeWhere((element) => element.msgId == msgId);
    setState(() {});
  }

  void hasTransform(ChatMessage message) {
    final index = list.indexWhere((element) => element.msgId == message.msgId);
    if (index != -1) {
      list[index] = message;
      setState(() {});
    }
  }

  @override
  void dispose() {
    scrollController.dispose();
    ChatRoomUIKitClient.instance.roomService.unbindResponse(this);
    ChatRoomUIKitClient.instance.giftService.unbindResponse(this);
    super.dispose();
  }

  @override
  void onMessageReceived(String roomId, List<ChatMessage> msgs) {
    if (ChatRoomUIKit.roomController(context)?.roomId == roomId) {
      setState(() {
        list.addAll(msgs);
      });
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        if (!canScroll) {
          unreadCount.value++;
          return;
        } else {
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
    ChatMessage msg,
  ) {
    if (ChatRoomSettings.enableMsgListGift) {
      onMessageReceived(roomId, [msg]);
    }
  }

  @override
  void onUserJoined(String roomId, List<ChatMessage> msgs) {
    onMessageReceived(roomId, msgs);
  }

  @override
  void onMessageRecalled(String roomId, List<ChatMessage> msgs) {
    if (ChatRoomUIKit.roomController(context)?.roomId == roomId) {
      setState(() {
        list.removeWhere((element) {
          return msgs.any((msg) => msg.msgId == element.msgId);
        });
      });
    }
  }

  @override
  void onMessageTransformed(String roomId, ChatMessage message) {
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

  void tapAction(ChatMessage msg) {
    widget.onTap?.call(context, msg);
  }

  void longPressAction(ChatMessage msg) {
    if (widget.onLongPress != null) {
      widget.onLongPress?.call(context, msg);
    } else {
      if (msg.isGiftMsg() || msg.isJoinNotify()) return;
      String? roomId = ChatRoomUIKit.roomController(context)?.roomId;
      String? ownerId = ChatRoomUIKit.roomController(context)?.ownerId;
      if (roomId?.isNotEmpty == true) {
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
              items: [
                ChatBottomSheetItem.normal(
                  label: ChatroomLocal.bottomSheetTranslate.getString(context),
                  onTap: () async {
                    Navigator.of(context).pop();
                    try {
                      await ChatRoomUIKitClient.instance.translateMessage(
                          roomId: msg.conversationId!,
                          message: msg,
                          language: LanguageConvertor.instance
                              .targetLanguage(context));
                    } catch (e) {
                      vLog(e.toString());
                    }
                  },
                ),
                ChatBottomSheetItem.normal(
                  label: ChatroomLocal.bottomSheetDelete.getString(context),
                  onTap: () async {
                    Navigator.of(context).pop();
                    try {
                      await ChatRoomUIKitClient.instance
                          .recall(roomId: msg.conversationId!, message: msg);
                    } catch (e) {
                      vLog(e.toString());
                    }
                  },
                ),
                if (ChatRoomUIKit.roomController(context)?.ownerId ==
                    Client.getInstance.currentUserId)
                  ChatBottomSheetItem.normal(
                    label: ChatroomLocal.bottomSheetMute.getString(context),
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ChatBottomSheetItem.destructive(
                  label: ChatroomLocal.bottomSheetReport.getString(context),
                  onTap: () {
                    Navigator.of(context).pop();
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
                        return ChatroomReportListView(
                          roomId: roomId!,
                          messageId: msg.msgId,
                          owner: ownerId,
                          controllers: [reportController],
                        );
                      },
                    );
                  },
                ),
              ],
            );
          },
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget content = ListView.separated(
      physics: const AlwaysScrollableScrollPhysics(),
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
                  return ChatRoomTextListTile(msg);
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

    // content = ShaderMask(
    //   shaderCallback: (rect) {
    //     return const LinearGradient(
    //       begin: Alignment.bottomCenter,
    //       end: Alignment.topCenter,
    //       stops: [0.98, 1],
    //       colors: [Colors.black, Colors.transparent],
    //     ).createShader(Rect.fromLTRB(0, 0, rect.width, rect.height));
    //   },
    //   blendMode: BlendMode.dstIn,
    //   child: content,
    // );

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
            color: (ChatUIKitTheme.of(context).color.isDark
                ? ChatUIKitTheme.of(context).color.neutralColor1
                : ChatUIKitTheme.of(context).color.neutralColor98),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.keyboard_arrow_down,
                size: 18,
                color: (ChatUIKitTheme.of(context).color.isDark
                    ? ChatUIKitTheme.of(context).color.primaryColor6
                    : ChatUIKitTheme.of(context).color.primaryColor5),
              ),
              const SizedBox(width: 2),
              Expanded(
                flex: 0,
                child: Text(
                  '${value >= 99 ? '99+' : value} ${ChatroomLocal.newMessage.getString(context)}',
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontWeight:
                        ChatUIKitTheme.of(context).font.labelMedium.fontWeight,
                    fontSize:
                        ChatUIKitTheme.of(context).font.labelMedium.fontSize,
                    color: (ChatUIKitTheme.of(context).color.isDark
                        ? ChatUIKitTheme.of(context).color.primaryColor6
                        : ChatUIKitTheme.of(context).color.primaryColor5),
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
  final ChatMessage msg;
  @override
  State<ChatRoomJoinListTile> createState() => _ChatRoomJoinListTileState();
}

class _ChatRoomJoinListTileState extends State<ChatRoomJoinListTile> {
  @override
  Widget build(BuildContext context) {
    return ChatRoomListTile(
      widget.msg,
      child: TextSpan(text: " ${ChatroomLocal.joined.getString(context)}"),
    );
  }
}

class ChatRoomGiftListTile extends StatefulWidget {
  const ChatRoomGiftListTile(this.msg, {super.key});
  final ChatMessage msg;

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
            TextSpan(text: 'Sent \'@${gift.giftName}\''),
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
  final ChatMessage msg;

  @override
  State<ChatRoomTextListTile> createState() => _ChatRoomTextListTileState();
}

class _ChatRoomTextListTileState extends State<ChatRoomTextListTile> {
  @override
  Widget build(BuildContext context) {
    String content = '';
    if (widget.msg.body.type == BodyType.TXT) {
      content = (widget.msg.body as TextBody).content;
    }
    return ChatRoomListTile(
      widget.msg,
      child: TextSpan(
        children: [
          const WidgetSpan(child: Padding(padding: EdgeInsets.only(left: 4))),
          TextSpan(text: ":${EmojiMapping.replaceEmojiBack(content)}"),
        ],
      ),
    );
  }
}

class ChatRoomListTile extends StatefulWidget {
  const ChatRoomListTile(this.msg, {this.child, super.key});
  final ChatMessage msg;
  final TextSpan? child;
  @override
  State<ChatRoomListTile> createState() => _ChatRoomListTileState();
}

class _ChatRoomListTileState extends State<ChatRoomListTile> {
  @override
  Widget build(BuildContext context) {
    List<InlineSpan> list = [];
    // time
    if (ChatRoomSettings.enableMsgListTime) {
      list.add(TextSpan(text: TimeTool.timeStrByMs(widget.msg.serverTime)));
    }

    UserInfoProtocol? user = widget.msg.getUserEntity();

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
                      : Image.asset(
                          ChatRoomSettings.defaultIdentify!,
                          width: 15,
                          height: 15,
                        ),
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
                  image: user?.avatarURL ?? '',
                  size: 18,
                  placeholderWidget:
                      (ChatRoomSettings.userDefaultAvatar == null)
                          ? ChatImageLoader.defaultAvatar(size: 18)
                          : Image.asset(
                              ChatRoomSettings.userDefaultAvatar!,
                            ),
                );
              } else {
                return ChatImageLoader.avatar(size: 18);
              }
            }(),
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
              color: (ChatUIKitTheme.of(context).color.isDark
                  ? ChatUIKitTheme.of(context).color.primaryColor8
                  : ChatUIKitTheme.of(context).color.primaryColor8),
              fontWeight:
                  ChatUIKitTheme.of(context).font.labelMedium.fontWeight,
              fontSize: ChatUIKitTheme.of(context).font.labelMedium.fontSize,
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
          color: Colors.white,
          fontSize: ChatUIKitTheme.of(context).font.bodyMedium.fontSize,
          fontWeight: ChatUIKitTheme.of(context).font.bodyMedium.fontWeight,
        ),
        children: list,
      ),
    );

    content = Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: ChatUIKitTheme.of(context).color.barrageColor1),
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
      child: content,
    );

    content = Align(
      alignment: Alignment.centerLeft,
      child: content,
    );

    return content;
  }
}
