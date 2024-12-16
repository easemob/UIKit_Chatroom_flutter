import 'dart:async';
import '../../inner_headers.dart';
import 'package:flutter/material.dart';

class ChatroomPinMessageWidgetController {
  ChatroomPinMessageWidgetController();

  bool isShowMore = false;
  _ChatroomPinMessageWidgetState? _state;
  void showMore(bool show) {
    if (isShowMore == show) return;
    _state?.linesNumChange();
    isShowMore = show;
  }

  void _attach(_ChatroomPinMessageWidgetState state) {
    _state = state;
  }

  void _detach() {
    _state = null;
  }
}

const double kScrollBarWidth = 2;
const kScrollBtnWidth = 28.0 - kScrollBarWidth;
const double kScrollAreaMaxHeight = 98;
const double kAreaHorizontalPadding = 8;
const double kAreaVerticalPadding = 4;
const int kMaxLines = 5;

class ChatroomPinMessageWidget extends StatefulWidget {
  const ChatroomPinMessageWidget(
      {required this.roomId, this.controller, this.pinIcon, super.key});
  final ChatroomPinMessageWidgetController? controller;
  final Image? pinIcon;
  final String roomId;

  @override
  State<ChatroomPinMessageWidget> createState() =>
      _ChatroomPinMessageWidgetState();
}

class _ChatroomPinMessageWidgetState extends State<ChatroomPinMessageWidget>
    with ChatUIKitThemeMixin, ChatroomResponse {
  late ChatroomPinMessageWidgetController _controller;
  int maxLines = 2;
  final ValueNotifier<double> _alignmentY = ValueNotifier(-1.0);
  final ValueNotifier<bool> showScrollBar = ValueNotifier(false);
  StreamSubscription? sub;
  Message? pinMsg;
  bool hasMoreBtn = false;
  bool needScroll = false;
  @override
  void initState() {
    _controller = widget.controller ?? ChatroomPinMessageWidgetController();
    _controller._attach(this);
    Client.getInstance.chatManager.addEventHandler(
      'pinMessage',
      ChatEventHandler(
        onMessagePinChanged: onMessagePinChanged,
      ),
    );

    ChatroomUIKitClient.instance.roomService.bindResponse(this);

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      fetchPinedMessage();
    });

    super.initState();
  }

  @override
  Widget themeBuilder(BuildContext context, ChatUIKitTheme theme) {
    if (pinMsg == null) {
      return const SizedBox();
    }

    UserInfoProtocol? user =
        ChatroomContext.instance.userInfosMap[pinMsg?.from];

    String str = (pinMsg!.body as TextBody).content;

    return LayoutBuilder(
      builder: (context, constraints) {
        double maxWidth = constraints.maxWidth - kScrollBtnWidth;

        final style = TextStyle(
            fontWeight: theme.font.bodyMedium.fontWeight,
            fontSize: theme.font.bodyMedium.fontSize,
            color: theme.color.isDark
                ? theme.color.neutralColor98
                : theme.color.neutralColor98);

        TextSpan span = TextSpan(
          children: [
            WidgetSpan(
              alignment: PlaceholderAlignment.middle,
              child: ChatImageLoader.pinMessage(),
            ),
            WidgetSpan(
              alignment: PlaceholderAlignment.middle,
              child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: ChatAvatar(user: user, width: 18, height: 18)),
            ),
            TextSpan(
                text: user?.nickname ?? user?.userId ?? '',
                style: TextStyle(
                    fontWeight: theme.font.labelMedium.fontWeight,
                    fontSize: theme.font.labelMedium.fontSize,
                    color: theme.color.isDark
                        ? theme.color.primaryColor8
                        : theme.color.primaryColor8)),
            const WidgetSpan(child: SizedBox(width: 4)),
            TextSpan(
              text: str,
              style: style,
            ),
          ],
        );

        List<PlaceholderDimensions> dimensions = [
          const PlaceholderDimensions(
            size: Size(8 + 18, 8 + 18),
            alignment: PlaceholderAlignment.middle,
          ),
          const PlaceholderDimensions(
            size: Size(8 + 26, 8 + 18),
            alignment: PlaceholderAlignment.middle,
          ),
          const PlaceholderDimensions(
            size: Size(0 + 4, 0),
            alignment: PlaceholderAlignment.middle,
          )
        ];

        Size size = Size.zero;
        // 正常情况下文字占用的size
        Size normalSize = lineSize(span, 9999, maxWidth, dimensions);

        // 一行时的size；
        Size oneLineSize = lineSize(span, 1, maxWidth, dimensions);

        // 两行时的size；
        Size twoLineSize = lineSize(span, 2, maxWidth, dimensions);

        // 最大行数时的size；
        Size maxSize = lineSize(span, kMaxLines, maxWidth, dimensions);

        hasMoreBtn = false;
        needScroll = false;
        if (oneLineSize.height >= normalSize.height) {
          maxLines = 1;
          size = oneLineSize;
        } else if (twoLineSize.height >= normalSize.height) {
          maxLines = 2;
          size = twoLineSize;
        } else if (normalSize.height > twoLineSize.height &&
            normalSize.height <= maxSize.height) {
          hasMoreBtn = true;
          if (_controller.isShowMore) {
            maxLines = kMaxLines;
            size = maxSize;
          } else {
            maxLines = 2;
            size = twoLineSize;
          }
        } else {
          hasMoreBtn = true;
          if (_controller.isShowMore) {
            needScroll = true;
            maxLines = 9999;
            size = maxSize;
          } else {
            maxLines = 2;
            size = twoLineSize;
          }
        }

        Widget content = RichText(
          text: span,
          maxLines: _controller.isShowMore ? 9999 : maxLines,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.start,
          softWrap: true,
        );

        if (_controller.isShowMore) {
          content = ListView(
            padding: const EdgeInsets.all(0),
            children: [content],
          );

          content = NotificationListener(
            onNotification: _handleScrollNotification,
            child: Stack(
              children: [
                content,
                if (needScroll)
                  Positioned(
                    width: 2,
                    right: 0,
                    top: 0,
                    bottom: 0,
                    child: ValueListenableBuilder(
                      valueListenable: showScrollBar,
                      builder: (context, value, child) {
                        return ValueListenableBuilder(
                          valueListenable: _alignmentY,
                          builder: (context, value, child) {
                            value = value.clamp(-1.0, 1.0);
                            return Container(
                              alignment: Alignment(1, value),
                              child: Container(
                                height: 63,
                                width: kScrollBarWidth,
                                decoration: BoxDecoration(
                                  color: theme.color.isDark
                                      ? theme.color.neutralColor98
                                      : theme.color.neutralColor98,
                                  borderRadius: BorderRadius.circular(2),
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  )
              ],
            ),
          );
        }

        content = Row(
          children: [
            Expanded(child: content),
            if (hasMoreBtn)
              InkWell(
                onTap: showInfo,
                child: SizedBox(
                  width: kScrollBtnWidth,
                  child: Align(
                    alignment: Alignment.bottomRight,
                    child: Icon(
                      _controller.isShowMore
                          ? Icons.expand_less
                          : Icons.expand_more,
                      size: 14,
                      color: theme.color.isDark
                          ? theme.color.neutralColor98
                          : theme.color.neutralColor98,
                    ),
                  ),
                ),
              ),
          ],
        );

        content = Container(
          width: size.width + (hasMoreBtn ? kScrollBtnWidth : 0),
          height: size.height,
          constraints: BoxConstraints(
            maxHeight: kScrollAreaMaxHeight,
            minHeight: oneLineSize.height,
          ),
          padding: const EdgeInsets.only(
            left: kAreaHorizontalPadding,
            right: kAreaHorizontalPadding,
            bottom: kAreaVerticalPadding,
            top: kAreaVerticalPadding,
          ),
          decoration: BoxDecoration(
            color: theme.color.isDark
                ? Colors.black.withOpacity(0.2)
                : Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: content,
        );

        content = InkWell(
          onLongPress: longPressedActions,
          child: content,
        );
        return content;
      },
    );
  }

  bool _handleScrollNotification(ScrollNotification notification) {
    final ScrollMetrics metrics = notification.metrics;
    _alignmentY.value = -1 + (metrics.pixels / metrics.maxScrollExtent) * 2;
    showScrollBar.value = true;
    sub?.cancel();
    sub = Future.delayed(const Duration(milliseconds: 3000), () {})
        .asStream()
        .listen((event) {
      showScrollBar.value = false;
    });

    return true;
  }

  void linesNumChange() {
    setState(() {});
    if (_controller.isShowMore) {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        _alignmentY.value = -1;
        sub?.cancel();
        showScrollBar.value = false;
      });
    }
  }

  void showInfo() {
    _controller.showMore(!_controller.isShowMore);
  }

  void onMessagePinChanged(String msgId, String convId,
      MessagePinOperation operation, MessagePinInfo pinInfo) async {
    if (convId == widget.roomId) {
      if (operation == MessagePinOperation.Unpin) {
        if (pinMsg?.msgId == msgId) {
          pinMsg = null;
          _controller.isShowMore = false;
          setState(() {});
        }
      } else {
        pinMsg = await Client.getInstance.chatManager.loadMessage(msgId);
        setState(() {});
      }
    }
  }

  Future<void> fetchPinedMessage() async {
    try {
      List<Message> list = await ChatroomUIKitClient.instance
          .fetchPinnedMessages(roomId: widget.roomId);

      if (list.isNotEmpty) {
        pinMsg = list.first;
        setState(() {});
      }
    } catch (_) {}
  }

  Future<void> longPressedActions() async {
    ChatroomController? controller = ChatRoomUIKit.roomController(context);

    if (controller?.ownerId == Client.getInstance.currentUserId &&
        controller?.ownerId != null) {
      if (mounted) {
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
                    label: ChatroomLocal.bottomSheetUnpin.getString(context),
                    onTap: () async {
                      Navigator.of(context).pop();
                      try {
                        ChatroomUIKitClient.instance.unpinMessage(
                          roomId: widget.roomId,
                          message: pinMsg!,
                        );
                        setState(() {
                          pinMsg = null;
                        });
                      } catch (e) {
                        rethrow;
                      }
                    })
              ],
            );
          },
        );
      }
    }
  }

  @override
  void dispose() {
    sub?.cancel();
    _controller._detach();
    Client.getInstance.chatManager.removeEventHandler('pinMessage');
    ChatroomUIKitClient.instance.roomService.unbindResponse(this);
    super.dispose();
  }

  Size pinMsgSize(String text, TextStyle style, double maxWidth) {
    TextPainter textPainter = TextPainter(
      textDirection: TextDirection.ltr,
      text: TextSpan(text: text, style: style),
    )..layout(maxWidth: maxWidth);

    return textPainter.size;
  }

  Size lineSize(
    InlineSpan span,
    int maxLines,
    double maxWidth,
    List<PlaceholderDimensions>? dimensions,
  ) {
    TextPainter textPainter = TextPainter(
      maxLines: maxLines,
      text: span,
      textDirection: TextDirection.ltr,
    )
      ..setPlaceholderDimensions(dimensions)
      ..layout(maxWidth: maxWidth);
    return textPainter.size;
  }

  @override
  void onPinChanged(bool isPin, Message message) {
    if (widget.roomId != message.conversationId) return;
    if (pinMsg?.msgId == message.msgId) {
      if (!isPin) {
        setState(() {
          pinMsg = null;
        });
      }
    } else {
      if (isPin) {
        setState(() {
          pinMsg = message;
        });
      }
    }
  }
}
