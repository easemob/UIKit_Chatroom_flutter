import 'package:chatroom_uikit/chatroom_uikit.dart';

import 'package:flutter/material.dart';

class ChatroomReportListView extends StatefulWidget {
  const ChatroomReportListView({
    required this.roomId,
    required this.messageId,
    this.controller,
    this.owner,
    super.key,
  });

  final ChatReportController? controller;
  final String messageId;
  final String roomId;
  final String? owner;

  @override
  State<ChatroomReportListView> createState() => _ChatroomReportListViewState();
}

class _ChatroomReportListViewState extends State<ChatroomReportListView>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  late ChatReportController controller;

  @override
  void initState() {
    super.initState();
    controller = widget.controller ?? DefaultReportController();
    _tabController = TabController(vsync: this, length: 1);
  }

  @override
  Widget build(BuildContext context) {
    return ChatBottomSheetBackground(
      child: _buildContent(),
    );
  }

  Widget _buildContent() {
    return Column(
      children: [
        TabBar(
          dividerColor: Colors.transparent,
          indicator: CustomTabIndicator(
            radius: 2,
            color: ChatUIKitTheme.of(context).color.isDark
                ? ChatUIKitTheme.of(context).color.primaryColor6
                : ChatUIKitTheme.of(context).color.primaryColor5,
            size: const Size(28, 4),
          ),
          controller: _tabController,
          labelStyle: TextStyle(
            fontWeight: ChatUIKitTheme.of(context).font.titleMedium.fontWeight,
            fontSize: ChatUIKitTheme.of(context).font.titleMedium.fontSize,
          ),
          labelColor: (ChatUIKitTheme.of(context).color.isDark
              ? ChatUIKitTheme.of(context).color.neutralColor98
              : ChatUIKitTheme.of(context).color.neutralColor1),
          isScrollable: true,
          tabs: [controller].map((e) => Tab(text: e.title(context))).toList(),
        ),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [controller]
                .map((e) => ChatReportPage(
                      roomId: widget.roomId,
                      messageId: widget.messageId,
                      owner: widget.owner,
                      controller: e,
                    ))
                .toList(),
          ),
        )
      ],
    );
  }
}

class ChatReportPage extends StatefulWidget {
  const ChatReportPage({
    required this.controller,
    required this.messageId,
    required this.roomId,
    this.owner,
    super.key,
  });
  final String? owner;
  final String roomId;
  final String messageId;
  final ChatReportController controller;
  @override
  State<ChatReportPage> createState() => _ChatReportPageState();
}

class _ChatReportPageState extends State<ChatReportPage> {
  String? selectedKey;

  final scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    Map<String, String> items =
        widget.controller.reportList(context, widget.messageId);

    Widget content = CustomScrollView(
      controller: scrollController,
      slivers: [
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (BuildContext context, int index) {
              return Text(
                ChatroomLocal.violationOptions.getString(context),
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    fontWeight:
                        ChatUIKitTheme.of(context).font.titleSmall.fontWeight,
                    fontSize:
                        ChatUIKitTheme.of(context).font.titleSmall.fontSize,
                    color: (ChatUIKitTheme.of(context).color.isDark
                        ? ChatUIKitTheme.of(context).color.neutralColor6
                        : ChatUIKitTheme.of(context).color.neutralColor5)),
              );
            },
            childCount: 1,
          ),
        ),
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (BuildContext context, int index) {
              return InkWell(
                onTap: () {
                  setState(() {
                    selectedKey == items.keys.toList()[index];
                  });
                },
                child: () {
                  String reasonKey = items.keys.toList()[index];
                  String value = items[reasonKey]!;
                  return tile(
                    value,
                    reasonKey,
                    selectedKey == reasonKey,
                  );
                }(),
              );
            },
            childCount: items.length,
          ),
        ),
      ],
    );

    content = Column(
      children: [
        Expanded(child: content),
        Container(
          margin: const EdgeInsets.fromLTRB(0, 8, 0, 8),
          height: 40,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            mainAxisSize: MainAxisSize.max,
            children: [
              Expanded(
                child: ChatUIKitButton.neutral(
                  ChatroomLocal.bottomSheetCancel.getString(context),
                  radius: 24,
                  fontWeight:
                      ChatUIKitTheme.of(context).font.headlineSmall.fontWeight,
                  fontSize:
                      ChatUIKitTheme.of(context).font.headlineSmall.fontSize,
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ChatUIKitButton.primary(
                  ChatroomLocal.reportButtonClickMenuTitle.getString(context),
                  radius: 24,
                  fontWeight:
                      ChatUIKitTheme.of(context).font.headlineSmall.fontWeight,
                  fontSize:
                      ChatUIKitTheme.of(context).font.headlineSmall.fontSize,
                  onTap: () {
                    widget.controller.report(
                      context,
                      widget.roomId,
                      widget.messageId,
                      selectedKey!,
                      items[selectedKey]!,
                    );
                    Navigator.of(context).pop();
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );

    content = Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
      child: content,
    );

    content = SafeArea(child: content);

    return content;
  }

  Widget tile(
    String title,
    String titleKey,
    bool selected,
  ) {
    return SizedBox(
      height: 54,
      child: Row(
        children: [
          Text(
            title,
            style: TextStyle(
                fontWeight:
                    ChatUIKitTheme.of(context).font.titleMedium.fontWeight,
                fontSize: ChatUIKitTheme.of(context).font.titleMedium.fontSize,
                color: (ChatUIKitTheme.of(context).color.isDark
                    ? ChatUIKitTheme.of(context).color.neutralColor98
                    : ChatUIKitTheme.of(context).color.neutralColor1)),
          ),
          Expanded(child: Container()),
          selected
              ? Icon(Icons.radio_button_checked,
                  size: 21.33,
                  color: (ChatUIKitTheme.of(context).color.isDark
                      ? ChatUIKitTheme.of(context).color.neutralColor6
                      : ChatUIKitTheme.of(context).color.primaryColor5))
              : Icon(Icons.radio_button_unchecked,
                  size: 21.33,
                  color: (ChatUIKitTheme.of(context).color.isDark
                      ? ChatUIKitTheme.of(context).color.neutralColor8
                      : ChatUIKitTheme.of(context).color.neutralColor7))
        ],
      ),
    );
  }
}
