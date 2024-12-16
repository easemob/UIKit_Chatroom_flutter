import '../../inner_headers.dart';

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
    with SingleTickerProviderStateMixin, ChatUIKitThemeMixin {
  late TabController _tabController;

  late ChatReportController controller;

  @override
  void initState() {
    super.initState();
    controller = widget.controller ?? DefaultReportController();
    _tabController = TabController(vsync: this, length: 1);
  }

  @override
  Widget themeBuilder(BuildContext context, ChatUIKitTheme theme) {
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
            color: theme.color.isDark
                ? theme.color.primaryColor6
                : theme.color.primaryColor5,
            size: const Size(28, 4),
          ),
          controller: _tabController,
          labelStyle: TextStyle(
            fontWeight: theme.font.titleMedium.fontWeight,
            fontSize: theme.font.titleMedium.fontSize,
          ),
          labelColor: (theme.color.isDark
              ? theme.color.neutralColor98
              : theme.color.neutralColor1),
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

class _ChatReportPageState extends State<ChatReportPage>
    with ChatUIKitThemeMixin {
  String? selectedKey;

  final scrollController = ScrollController();

  @override
  Widget themeBuilder(BuildContext context, ChatUIKitTheme theme) {
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
                    fontWeight: theme.font.titleSmall.fontWeight,
                    fontSize: theme.font.titleSmall.fontSize,
                    color: (theme.color.isDark
                        ? theme.color.neutralColor6
                        : theme.color.neutralColor5)),
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
                    selectedKey = items.keys.toList()[index];
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
                  fontWeight: theme.font.headlineSmall.fontWeight,
                  fontSize: theme.font.headlineSmall.fontSize,
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
                  fontWeight: theme.font.headlineSmall.fontWeight,
                  fontSize: theme.font.headlineSmall.fontSize,
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
                fontWeight: theme.font.titleMedium.fontWeight,
                fontSize: theme.font.titleMedium.fontSize,
                color: (theme.color.isDark
                    ? theme.color.neutralColor98
                    : theme.color.neutralColor1)),
          ),
          Expanded(child: Container()),
          selected
              ? Icon(Icons.radio_button_checked,
                  size: 21.33,
                  color: (theme.color.isDark
                      ? theme.color.primaryColor6
                      : theme.color.primaryColor5))
              : Icon(Icons.radio_button_unchecked,
                  size: 21.33,
                  color: (theme.color.isDark
                      ? theme.color.neutralColor8
                      : theme.color.neutralColor7))
        ],
      ),
    );
  }
}
