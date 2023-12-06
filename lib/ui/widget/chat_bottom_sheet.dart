import 'package:chatroom_uikit/chatroom_uikit.dart';
import 'package:flutter/material.dart';

class ChatBottomSheetWidget extends StatelessWidget {
  const ChatBottomSheetWidget({
    required this.items,
    this.title,
    this.titleStyle,
    this.cancelStyle,
    super.key,
  });

  final String? title;
  final TextStyle? titleStyle;
  final List<ChatBottomSheetItem> items;
  final TextStyle? cancelStyle;
  @override
  Widget build(BuildContext context) {
    return BottomSheet(
      enableDrag: false,
      onClosing: () {},
      builder: (context) {
        return _build(context);
      },
    );
  }

  Widget _build(BuildContext context) {
    TextStyle? normalStyle = TextStyle(
      fontWeight: ChatUIKitTheme.of(context).font.bodyLarge.fontWeight,
      fontSize: ChatUIKitTheme.of(context).font.bodyLarge.fontSize,
      color: (ChatUIKitTheme.of(context).color.isDark
          ? ChatUIKitTheme.of(context).color.primaryColor6
          : ChatUIKitTheme.of(context).color.primaryColor5),
    );

    TextStyle? destructive = TextStyle(
      fontWeight: ChatUIKitTheme.of(context).font.bodyLarge.fontWeight,
      fontSize: ChatUIKitTheme.of(context).font.bodyLarge.fontSize,
      color: (ChatUIKitTheme.of(context).color.isDark
          ? ChatUIKitTheme.of(context).color.errorColor6
          : ChatUIKitTheme.of(context).color.errorColor5),
    );

    List<Widget> list = [];

    list.add(
      Container(
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(3)),
          color: (ChatUIKitTheme.of(context).color.isDark
              ? ChatUIKitTheme.of(context).color.neutralColor3
              : ChatUIKitTheme.of(context).color.neutralColor8),
        ),
        margin: const EdgeInsets.symmetric(vertical: 6),
        height: 5,
        width: 36,
      ),
    );

    if (title != null) {
      list.add(Container(
        padding: const EdgeInsets.symmetric(vertical: 13),
        child: Text(
          title!,
          style: titleStyle ??
              TextStyle(
                fontWeight:
                    ChatUIKitTheme.of(context).font.labelMedium.fontWeight,
                fontSize: ChatUIKitTheme.of(context).font.labelMedium.fontSize,
                color: (ChatUIKitTheme.of(context).color.isDark
                    ? ChatUIKitTheme.of(context).color.neutralColor6
                    : ChatUIKitTheme.of(context).color.neutralColor5),
              ),
        ),
      ));
    }

    for (var element in items) {
      if (element != items[0] || title?.isNotEmpty == true) {
        list.add(
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Divider(
              height: .5,
              color: (ChatUIKitTheme.of(context).color.isDark
                  ? ChatUIKitTheme.of(context).color.neutralColor2
                  : ChatUIKitTheme.of(context).color.neutralColor9),
            ),
          ),
        );
      }

      list.add(
        InkWell(
          onTap: () {
            element.onTap();
          },
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 17),
            alignment: Alignment.center,
            child: Text(
              element.label,
              style: element.style ??
                  (element.type == ChatBottomSheetItemType.normal
                      ? normalStyle
                      : destructive),
            ),
          ),
        ),
      );
    }

    list.add(Container(
      height: 8,
      color: (ChatUIKitTheme.of(context).color.isDark
          ? ChatUIKitTheme.of(context).color.neutralColor0
          : ChatUIKitTheme.of(context).color.neutralColor95),
    ));
    list.add(
      InkWell(
        onTap: () {
          Navigator.of(context).pop();
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 17),
          alignment: Alignment.center,
          child: Text(
            ChatroomLocal.bottomSheetCancel.getString(context),
            style: cancelStyle ??
                TextStyle(
                  fontWeight:
                      ChatUIKitTheme.of(context).font.titleMedium.fontWeight,
                  fontSize:
                      ChatUIKitTheme.of(context).font.titleMedium.fontSize,
                  color: (ChatUIKitTheme.of(context).color.isDark
                      ? ChatUIKitTheme.of(context).color.primaryColor6
                      : ChatUIKitTheme.of(context).color.primaryColor5),
                ),
          ),
        ),
      ),
    );

    Widget content = Column(
      mainAxisSize: MainAxisSize.min,
      children: list,
    );

    content = SafeArea(child: content);

    content = Container(
      decoration: BoxDecoration(
        color: (ChatUIKitTheme.of(context).color.isDark
            ? ChatUIKitTheme.of(context).color.neutralColor1
            : ChatUIKitTheme.of(context).color.neutralColor98),
      ),
      child: content,
    );

    return content;
  }
}

enum ChatBottomSheetItemType {
  normal,
  done,
  destructive,
}

class ChatBottomSheetItem {
  ChatBottomSheetItem.destructive({
    required this.label,
    required this.onTap,
    this.style,
  }) : type = ChatBottomSheetItemType.destructive;

  ChatBottomSheetItem.normal({
    required this.label,
    required this.onTap,
    this.style,
  }) : type = ChatBottomSheetItemType.normal;

  const ChatBottomSheetItem({
    required this.label,
    this.style,
    required this.onTap,
    required this.type,
  });

  final ChatBottomSheetItemType type;
  final String label;
  final TextStyle? style;
  final VoidCallback onTap;
}
