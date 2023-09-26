import 'package:flutter/material.dart';
import 'package:chat_uikit_theme/chat_uikit_theme.dart';

import '../tools/image_loader.dart';
import 'chat_input_emoji.dart';

class ChatInputBar extends StatefulWidget {
  ChatInputBar({
    this.inputIcon,
    this.inputHint,
    this.leading,
    this.trailing,
    this.textDirection,
    this.onSend,
    super.key,
  }) {
    assert(trailing == null || trailing!.length <= 4,
        'can\'t more than 4 actions');
  }

  final Widget? inputIcon;
  final String? inputHint;
  final Widget? leading;
  final List<Widget>? trailing;
  final TextDirection? textDirection;
  final void Function({required String msg})? onSend;

  @override
  State<ChatInputBar> createState() => _ChatInputBarState();
}

enum InputType {
  normal,
  text,
  emoji,
}

class _ChatInputBarState extends State<ChatInputBar> {
  @override
  void initState() {
    super.initState();
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

    content = SafeArea(
      maintainBottomViewPadding: true,
      minimum:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: content,
    );
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
            child: widget.inputIcon ?? const Icon(Icons.chat),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(right: 4, left: 4),
              child: Text(
                widget.inputHint ?? 'Let\'s chat',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget constrained(Widget child) {
    return SizedBox(
      width: 38,
      height: 38,
      child: child,
    );
  }

  Widget normalWidget() {
    List<Widget> children = [];
    if (widget.leading != null) {
      children.add(Padding(
        padding: const EdgeInsets.only(left: 8, right: 8),
        child: constrained(widget.leading!),
      ));
    }

    Widget content = Container(
      height: 38,
      padding: const EdgeInsets.only(left: 4, right: 4),
      decoration: BoxDecoration(
        color: Colors.red,
        borderRadius: BorderRadius.circular(24),
      ),
      child: interiorWidget(),
    );

    content = Expanded(
        child: Padding(
      padding: const EdgeInsets.only(left: 8, right: 8),
      child: content,
    ));

    children.add(content);

    if (widget.trailing != null) {
      children.addAll(
        widget.trailing!.map(
          (e) => Padding(
            padding: const EdgeInsets.only(left: 8, right: 8),
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
      padding: const EdgeInsets.only(left: 8, right: 8),
      height: 54,
      color: Colors.blue,
      child: Padding(
        padding: const EdgeInsets.only(left: 8, right: 8),
        child: content,
      ),
    );

    return content;
  }

  Widget inputWidget() {
    List<Widget> list = [];

    list.add(
      Expanded(
        child: Container(
          decoration: BoxDecoration(
            color: ChatUIKitTheme.of(context)?.color.isDark ?? false
                ? ChatUIKitTheme.of(context)?.color.neutralColor2
                : ChatUIKitTheme.of(context)?.color.neutralColor95,
            borderRadius: BorderRadius.circular(16),
          ),
          margin: const EdgeInsets.all(8),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: TextField(
            textDirection: widget.textDirection,
            maxLines: 4,
            minLines: 1,
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
              ? ChatImageLoader.textKeyboard()
              : ChatImageLoader.face();
        }(),
      ),
    );

    trailing.add(InkWell(
      onTap: () {
        widget.onSend?.call(msg: textEditingController.text);
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
      color: ChatUIKitTheme.of(context)?.color.isDark ?? false
          ? ChatUIKitTheme.of(context)?.color.neutralColor1
          : ChatUIKitTheme.of(context)?.color.neutralColor98,
      child: content,
    );

    // content = Padding(
    //   padding: EdgeInsets.only(
    //     bottom: MediaQuery.of(context).viewInsets.bottom,
    //   ),
    //   child: content,
    // );

    return content;
  }

  Widget faceWidget() {
    Widget content = AnimatedContainer(
      onEnd: () {},
      curve: Curves.easeIn,
      duration: const Duration(milliseconds: 300),
      height: _inputType == InputType.emoji ? 280 : 0,
      child: const ChatInputEmoji(),
    );

    // content = SafeArea(
    //   maintainBottomViewPadding: true,
    //   child: content,
    // );
    return content;
  }
}
