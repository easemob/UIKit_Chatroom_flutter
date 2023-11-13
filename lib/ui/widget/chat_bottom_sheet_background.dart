import 'package:chatroom_uikit/chatroom_uikit.dart';
import 'package:flutter/material.dart';

class ChatBottomSheetBackground extends StatefulWidget {
  const ChatBottomSheetBackground(
      {required this.child, this.showGrip = true, super.key});

  final Widget child;
  final bool showGrip;

  @override
  State<ChatBottomSheetBackground> createState() =>
      _ChatBottomSheetBackgroundState();
}

class _ChatBottomSheetBackgroundState extends State<ChatBottomSheetBackground> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: (ChatUIKitTheme.of(context).color.isDark
          ? ChatUIKitTheme.of(context).color.neutralColor1
          : ChatUIKitTheme.of(context).color.neutralColor98),
      child: Column(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(3)),
              color: widget.showGrip
                  ? (ChatUIKitTheme.of(context).color.isDark
                      ? ChatUIKitTheme.of(context).color.neutralColor3
                      : ChatUIKitTheme.of(context).color.neutralColor8)
                  : Colors.transparent,
            ),
            margin: const EdgeInsets.symmetric(vertical: 6),
            height: 5,
            width: 36,
          ),
          Expanded(child: widget.child),
        ],
      ),
    );
  }
}
