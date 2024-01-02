import 'package:chatroom_uikit/chatroom_uikit.dart';

import 'package:flutter/material.dart';

class ChatInputBar extends StatefulWidget {
  ChatInputBar({
    this.inputIcon,
    this.inputHint,
    this.leading,
    this.actions,
    this.textDirection,
    this.onSend,
    super.key,
  }) {
    assert(
        actions == null || actions!.length <= 4, 'can\'t more than 4 actions');
  }

  final Widget? inputIcon;
  final String? inputHint;
  final Widget? leading;
  final List<Widget>? actions;
  final TextDirection? textDirection;
  final void Function({required String msg})? onSend;

  @override
  State<ChatInputBar> createState() => ChatInputBarState();
}

enum InputType {
  normal,
  text,
  emoji,
}

class ChatInputBarState extends State<ChatInputBar> {
  @override
  void initState() {
    super.initState();
    ChatRoomUIKit.roomController(context)?.setInputBarState(this);
    focusNode = FocusNode();
    textEditingController = TextEditingController();
    focusNode.addListener(() {
      if (focusNode.hasFocus) {
        setState(() {
          _inputType = InputType.text;
        });
      }
    });
  }

  @override
  void didUpdateWidget(covariant ChatInputBar oldWidget) {
    ChatRoomUIKit.roomController(context)?.setInputBarState(this);
    super.didUpdateWidget(oldWidget);
  }

  void hiddenInputBar() {
    setState(() {
      _inputType = InputType.normal;
    });
  }

  @override
  void dispose() {
    focusNode.dispose();
    textEditingController.dispose();

    super.dispose();
  }

  InputType _inputType = InputType.normal;

  late TextEditingController textEditingController;

  late FocusNode focusNode;

  @override
  Widget build(BuildContext context) {
    Widget content = Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        _inputType == InputType.normal ? normalWidget() : inputWidget(),
        faceWidget(),
      ],
    );

    content = Padding(
      padding: focusNode.hasFocus
          ? EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom)
          : EdgeInsets.zero,
      child: content,
    );

    content = SafeArea(child: content, top: false);

    content = WillPopScope(
        child: content,
        onWillPop: () async {
          ChatRoomUIKit.roomController(context)?.setInputBarState(null);
          return true;
        });

    return content;
  }

  Widget interiorWidget() {
    return InkWell(
      onTap: () {
        setState(() {
          _inputType = InputType.text;
        });
        focusNode.requestFocus();
      },
      child: Row(
        textDirection: widget.textDirection,
        children: [
          Container(
            margin: const EdgeInsets.all(4),
            width: 24,
            child: widget.inputIcon ??
                ChatImageLoader.inputChat(
                  color: const Color.fromRGBO(255, 255, 255, 0.8),
                ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(right: 4, left: 4),
              child: Text(
                // widget.inputHint ?? 'Let\'s chat',
                widget.inputHint ?? ChatroomLocal.startChat.getString(context),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: const Color.fromRGBO(255, 255, 255, 0.8),
                  fontSize: ChatUIKitTheme.of(context).font.bodyLarge.fontSize,
                  fontWeight:
                      ChatUIKitTheme.of(context).font.bodyLarge.fontWeight,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget constrained(Widget child) {
    return Container(
      width: 38,
      height: 38,
      decoration: BoxDecoration(
        color: ChatUIKitTheme.of(context).color.isDark
            ? ChatUIKitTheme.of(context).color.barrageColor2
            : ChatUIKitTheme.of(context).color.barrageColor1,
        borderRadius: BorderRadius.circular(24),
      ),
      child: child,
    );
  }

  Widget normalWidget() {
    List<Widget> children = [];
    if (widget.leading != null) {
      children.add(Padding(
        padding: const EdgeInsets.only(left: 8),
        child: constrained(widget.leading!),
      ));
    }

    CornerRadius radius = ChatRoomSettings.inputBarRadius;

    double height = 38;
    double circle = height /
        () {
          if (radius == CornerRadius.extraSmall) {
            return 16;
          } else if (radius == CornerRadius.small) {
            return 8;
          } else if (radius == CornerRadius.medium) {
            return 4;
          } else {
            return 2;
          }
        }();

    Widget content = Container(
      height: height,
      padding: const EdgeInsets.only(left: 4, right: 4),
      decoration: BoxDecoration(
        color: ChatUIKitTheme.of(context).color.isDark
            ? ChatUIKitTheme.of(context).color.barrageColor2
            : ChatUIKitTheme.of(context).color.barrageColor1,
        borderRadius: BorderRadius.circular(circle),
      ),
      child: interiorWidget(),
    );

    content = Expanded(
        child: Padding(
      padding: const EdgeInsets.only(left: 8, right: 8),
      child: content,
    ));

    children.add(content);

    if (widget.actions != null) {
      children.addAll(
        widget.actions!.map(
          (e) => Padding(
            padding: const EdgeInsets.only(left: 8),
            child: constrained(e),
          ),
        ),
      );
    }

    content = Row(
      textDirection: widget.textDirection,
      children: children,
    );

    content = Container(
      padding: const EdgeInsets.only(left: 8, right: 16),
      height: 54,
      child: content,
    );

    return content;
  }

  Widget inputWidget() {
    List<Widget> list = [];

    CornerRadius radius = ChatRoomSettings.inputBarRadius;

    double height = 38;
    double circle = height /
        () {
          if (radius == CornerRadius.extraSmall) {
            return 16;
          } else if (radius == CornerRadius.small) {
            return 8;
          } else if (radius == CornerRadius.medium) {
            return 4;
          } else {
            return 2;
          }
        }();

    list.add(
      Expanded(
        child: Container(
          decoration: BoxDecoration(
            color: (ChatUIKitTheme.of(context).color.isDark
                ? ChatUIKitTheme.of(context).color.neutralColor2
                : ChatUIKitTheme.of(context).color.neutralColor95),
            borderRadius: BorderRadius.circular(circle),
          ),
          margin: const EdgeInsets.all(8),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: TextField(
            textDirection: widget.textDirection,
            keyboardAppearance: ChatUIKitTheme.of(context).color.isDark
                ? Brightness.dark
                : Brightness.light,
            maxLines: 4,
            minLines: 1,
            style: TextStyle(
              color: (ChatUIKitTheme.of(context).color.isDark
                  ? ChatUIKitTheme.of(context).color.neutralColor98
                  : ChatUIKitTheme.of(context).color.neutralColor1),
              fontSize: ChatUIKitTheme.of(context).font.bodyLarge.fontSize,
              fontWeight: ChatUIKitTheme.of(context).font.bodyLarge.fontWeight,
            ),
            decoration: const InputDecoration(
              border: InputBorder.none,
              isDense: true,
            ),
            controller: textEditingController,
            focusNode: focusNode,
            onTap: () {},
          ),
        ),
      ),
    );

    List<Widget> trailing = [];
    trailing.add(
      InkWell(
        onTap: () {
          setState(() {
            _inputType = _inputType == InputType.emoji
                ? InputType.text
                : InputType.emoji;
            if (_inputType == InputType.emoji) {
              focusNode.unfocus();
            } else {
              focusNode.requestFocus();
            }
          });
        },
        child: () {
          return _inputType == InputType.emoji
              ? ChatImageLoader.textKeyboard(
                  color: (ChatUIKitTheme.of(context).color.isDark
                      ? ChatUIKitTheme.of(context).color.neutralColor98
                      : ChatUIKitTheme.of(context).color.neutralColor1),
                )
              : ChatImageLoader.face(
                  color: (ChatUIKitTheme.of(context).color.isDark
                      ? ChatUIKitTheme.of(context).color.neutralColor98
                      : ChatUIKitTheme.of(context).color.neutralColor1),
                );
        }(),
      ),
    );

    trailing.add(InkWell(
      onTap: () {
        if (widget.onSend != null) {
          widget.onSend!.call(msg: textEditingController.text);
        } else {
          ChatRoomUIKit.roomController(context)
              ?.sendMessage(textEditingController.text);
        }
        textEditingController.text = '';
        setState(() {
          _inputType = InputType.normal;
        });
      },
      child: ChatImageLoader.airplane(),
    ));

    list.addAll(trailing.map(
      (e) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 11),
          child: ConstrainedBox(
            constraints: BoxConstraints.loose(const Size(30, 30)),
            child: e,
          ),
        );
      },
    ).toList());

    Widget content = Row(
      textDirection: widget.textDirection,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: list,
    );

    content = Container(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      color: (ChatUIKitTheme.of(context).color.isDark
          ? ChatUIKitTheme.of(context).color.neutralColor1
          : ChatUIKitTheme.of(context).color.neutralColor98),
      child: content,
    );

    return content;
  }

  Widget faceWidget() {
    Widget content = AnimatedContainer(
      onEnd: () {},
      curve: Curves.easeIn,
      duration: const Duration(milliseconds: 300),
      height: _inputType == InputType.emoji ? 280 : 0,
      child: Container(
        color: (ChatUIKitTheme.of(context).color.isDark
            ? ChatUIKitTheme.of(context).color.neutralColor1
            : ChatUIKitTheme.of(context).color.neutralColor98),
        child: ChatInputEmoji(
          deleteOnTap: () {
            TextSelection selection = textEditingController.selection;
            TextEditingValue value = textEditingController.value;
            if (selection.baseOffset != selection.extentOffset) {
              textEditingController.text = textEditingController.text
                  .replaceRange(selection.start, selection.end, '');
              textEditingController.selection = TextSelection.fromPosition(
                  TextPosition(offset: selection.start));
            } else if (selection.baseOffset == 0) {
              return;
            } else if (selection.baseOffset != value.text.length) {
              String subText = value.text.substring(0, selection.start);
              subText = subText.characters.skipLast(1).toString();
              String text = subText.characters.skipLast(1).toString() +
                  value.text.substring(selection.start);
              TextSelection newSelection = TextSelection.fromPosition(
                  TextPosition(offset: subText.length));

              textEditingController.value = TextEditingValue(
                text: text,
                selection: newSelection,
              );
            } else {
              String text = value.text.characters.skipLast(1).toString();
              TextSelection newSelection =
                  TextSelection.fromPosition(TextPosition(offset: text.length));

              textEditingController.value = TextEditingValue(
                text: text,
                selection: newSelection,
              );
            }
          },
          emojiClicked: (emoji) {
            TextSelection selection = textEditingController.selection;
            if (selection.baseOffset != selection.extentOffset) {
              textEditingController.text = textEditingController.text
                  .replaceRange(selection.start, selection.end, emoji);
              textEditingController.selection = TextSelection.fromPosition(
                  TextPosition(offset: selection.start + emoji.length));
            } else if (selection.baseOffset == 0) {
              textEditingController.text =
                  emoji + textEditingController.text.substring(selection.start);
              textEditingController.selection = TextSelection.fromPosition(
                  TextPosition(offset: selection.start + emoji.length));
            } else {
              textEditingController.text =
                  textEditingController.text.substring(0, selection.start) +
                      emoji +
                      textEditingController.text.substring(selection.start);
              textEditingController.selection = TextSelection.fromPosition(
                  TextPosition(offset: selection.start + emoji.length));
            }
          },
        ),
      ),
    );

    return content;
  }
}
