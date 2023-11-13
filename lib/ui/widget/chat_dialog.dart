import 'package:chatroom_uikit/chatroom_uikit.dart';
import 'package:flutter/material.dart';

enum ChatDialogRectangleBorderType {
  circular,
  filletCorner,
  rightAngle,
}

Future<T> showChatDialog<T>(
  BuildContext context, {
  required List<ChatDialogItem<dynamic>> items,
  String? subTitle,
  String? title,
  List<String>? hiddenList,
  ChatDialogRectangleBorderType borderType =
      ChatDialogRectangleBorderType.circular,
}) async {
  return await showDialog(
    context: context,
    builder: (context) {
      return ChatDialog(
        title: title,
        subTitle: subTitle,
        hiddenList: hiddenList,
        items: items,
      );
    },
  );
}

class ChatDialog<T> extends StatelessWidget {
  const ChatDialog({
    required this.items,
    this.subTitle,
    this.title,
    this.hiddenList,
    this.borderType = ChatDialogRectangleBorderType.circular,
    super.key,
  });

  final String? title;
  final String? subTitle;
  final List<ChatDialogItem> items;
  final ChatDialogRectangleBorderType borderType;
  final List<String>? hiddenList;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width - 50;
    return Dialog(
      clipBehavior: Clip.hardEdge,
      shape: ContinuousRectangleBorder(
        borderRadius: BorderRadius.circular(() {
          switch (borderType) {
            case ChatDialogRectangleBorderType.circular:
              return 16.0;
            case ChatDialogRectangleBorderType.filletCorner:
              return 8.0;
            case ChatDialogRectangleBorderType.rightAngle:
              return 0.0;
          }
        }()),
      ),
      child: SizedBox(
        width: width,
        child: _buildContent(context),
      ),
    );
  }

  _buildContent(BuildContext context) {
    Widget content = Container(
      padding: const EdgeInsets.fromLTRB(0, 12, 0, 16),
      color: (ChatUIKitTheme.of(context).color.isDark
          ? ChatUIKitTheme.of(context).color.neutralColor1
          : ChatUIKitTheme.of(context).color.neutralColor98),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (title?.isNotEmpty == true)
            Padding(
              padding: const EdgeInsets.only(top: 12, left: 16, right: 16),
              child: Text(
                title!,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight:
                      ChatUIKitTheme.of(context).font.titleLarge.fontWeight,
                  fontSize: ChatUIKitTheme.of(context).font.titleLarge.fontSize,
                  color: ChatUIKitTheme.of(context).color.isDark
                      ? ChatUIKitTheme.of(context).color.neutralColor98
                      : Colors.black,
                ),
              ),
            ),
          if (subTitle?.isNotEmpty == true)
            Container(
              padding: const EdgeInsets.only(top: 12, left: 16, right: 16),
              child: Text(
                subTitle!,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight:
                      ChatUIKitTheme.of(context).font.labelMedium.fontWeight,
                  fontSize:
                      ChatUIKitTheme.of(context).font.labelMedium.fontSize,
                  color: (ChatUIKitTheme.of(context).color.isDark
                      ? ChatUIKitTheme.of(context).color.neutralColor6
                      : ChatUIKitTheme.of(context).color.neutralColor5),
                ),
              ),
            ),
          () {
            if (items.isEmpty) return Container();
            List<Widget> widgets = [];
            for (var item in items) {
              widgets.add(
                InkWell(
                  onTap: item.onTap,
                  child: Container(
                    height: 48,
                    decoration: BoxDecoration(
                      borderRadius: () {
                        if (borderType ==
                            ChatDialogRectangleBorderType.circular) {
                          return BorderRadius.circular(24);
                        } else if (borderType ==
                            ChatDialogRectangleBorderType.filletCorner) {
                          return BorderRadius.circular(4);
                        } else if (borderType ==
                            ChatDialogRectangleBorderType.rightAngle) {
                          return BorderRadius.circular(0);
                        }
                      }(),
                      border: Border.all(
                        width: 1,
                        color: () {
                          if (item.type == ChatDialogItemType.destructive) {
                            return (ChatUIKitTheme.of(context).color.isDark
                                ? ChatUIKitTheme.of(context).color.errorColor6
                                : ChatUIKitTheme.of(context).color.errorColor5);
                          } else if (item.type == ChatDialogItemType.confirm) {
                            return (ChatUIKitTheme.of(context).color.isDark
                                ? ChatUIKitTheme.of(context).color.primaryColor6
                                : ChatUIKitTheme.of(context)
                                    .color
                                    .primaryColor5);
                          } else {
                            return (ChatUIKitTheme.of(context).color.isDark
                                ? ChatUIKitTheme.of(context).color.neutralColor4
                                : ChatUIKitTheme.of(context)
                                    .color
                                    .neutralColor7);
                          }
                        }(),
                      ),
                      color: () {
                        if (item.type == ChatDialogItemType.destructive) {
                          return (ChatUIKitTheme.of(context).color.isDark
                              ? ChatUIKitTheme.of(context).color.errorColor6
                              : ChatUIKitTheme.of(context).color.errorColor5);
                        } else if (item.type == ChatDialogItemType.confirm) {
                          return (ChatUIKitTheme.of(context).color.isDark
                              ? ChatUIKitTheme.of(context).color.primaryColor6
                              : ChatUIKitTheme.of(context).color.primaryColor5);
                        }
                      }(),
                    ),
                    child: Center(
                      child: Text(
                        () {
                          switch (item.type) {
                            case ChatDialogItemType.destructive:
                              return item.label ??
                                  ChatroomLocal.dialogDelete.getString(context);
                            case ChatDialogItemType.confirm:
                              return item.label ??
                                  ChatroomLocal.dialogConfirm
                                      .getString(context);
                            case ChatDialogItemType.normal:
                              return item.label ??
                                  ChatroomLocal.dialogCancel.getString(context);
                          }
                        }(),
                        style: TextStyle(
                          fontSize: ChatUIKitTheme.of(context)
                              .font
                              .headlineSmall
                              .fontSize,
                          fontWeight: ChatUIKitTheme.of(context)
                              .font
                              .headlineSmall
                              .fontWeight,
                          color: () {
                            if (item.type == ChatDialogItemType.destructive) {
                              return (ChatUIKitTheme.of(context).color.isDark
                                  ? ChatUIKitTheme.of(context)
                                      .color
                                      .neutralColor98
                                  : ChatUIKitTheme.of(context)
                                      .color
                                      .neutralColor98);
                            } else if (item.type ==
                                ChatDialogItemType.confirm) {
                              return (ChatUIKitTheme.of(context).color.isDark
                                  ? ChatUIKitTheme.of(context)
                                      .color
                                      .neutralColor98
                                  : ChatUIKitTheme.of(context)
                                      .color
                                      .neutralColor98);
                            } else {
                              return ChatUIKitTheme.of(context).color.isDark
                                  ? ChatUIKitTheme.of(context)
                                      .color
                                      .neutralColor98
                                  : Colors.black;
                            }
                          }(),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }
            if (items.length > 2) {
              return Padding(
                padding: const EdgeInsets.fromLTRB(12, 20, 12, 8),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: () {
                    return widgets
                        .map(
                          (e) => Padding(
                            padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
                            child: e,
                          ),
                        )
                        .toList();
                  }(),
                ),
              );
            } else {
              return Padding(
                padding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  mainAxisSize: MainAxisSize.max,
                  children: () {
                    return widgets
                        .map(
                          (e) => Expanded(
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(6, 12, 6, 0),
                              child: e,
                            ),
                          ),
                        )
                        .toList();
                  }(),
                ),
              );
            }
          }()
        ],
      ),
    );

    content = ListView(
      physics: const BouncingScrollPhysics(),
      shrinkWrap: true,
      children: [content],
    );
    content = Scrollbar(
      child: content,
    );
    return content;
  }
}

enum ChatDialogItemType {
  confirm,
  normal,
  destructive,
}

class ChatDialogItem<T> {
  ChatDialogItem.destructive({
    this.label,
    required this.onTap,
    this.style,
  }) : type = ChatDialogItemType.destructive;

  ChatDialogItem.cancel({
    this.label,
    required this.onTap,
    this.style,
  }) : type = ChatDialogItemType.normal;

  ChatDialogItem.confirm({
    this.label,
    required this.onTap,
    this.style,
  }) : type = ChatDialogItemType.confirm;

  const ChatDialogItem({
    required this.label,
    this.style,
    required this.onTap,
    required this.type,
  });

  final ChatDialogItemType type;
  final String? label;
  final TextStyle? style;
  final Future<T> Function()? onTap;
}
