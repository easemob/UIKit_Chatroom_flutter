import 'package:chatroom_uikit/chatroom_uikit.dart';

import 'package:flutter/material.dart';

typedef ChatRoomShowGiftListAction = void Function(
    List<ChatRoomGiftPageController>);

class ChatRoomGiftListView extends StatefulWidget {
  const ChatRoomGiftListView({
    required this.giftControllers,
    this.onSendTap,
    super.key,
  });

  final List<ChatRoomGiftPageController> giftControllers;
  final void Function(GiftEntityProtocol gift)? onSendTap;

  @override
  State<ChatRoomGiftListView> createState() => _ChatRoomGiftListViewState();
}

class _ChatRoomGiftListViewState extends State<ChatRoomGiftListView>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    assert(
        widget.giftControllers.isNotEmpty, "giftControllers cannot be empty");
    super.initState();
    _tabController =
        TabController(vsync: this, length: widget.giftControllers.length);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChatBottomSheetBackground(
      child: Column(
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
              fontWeight:
                  ChatUIKitTheme.of(context).font.titleMedium.fontWeight,
              fontSize: ChatUIKitTheme.of(context).font.titleMedium.fontSize,
            ),
            labelColor: (ChatUIKitTheme.of(context).color.isDark
                ? ChatUIKitTheme.of(context).color.neutralColor98
                : ChatUIKitTheme.of(context).color.neutralColor1),
            isScrollable: true,
            tabs:
                widget.giftControllers.map((e) => Tab(text: e.title)).toList(),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: widget.giftControllers
                  .map(
                    (e) => ChatRoomGiftPage(
                      giftEntities: e.gifts,
                      onSendTap: (gift) {
                        GiftEntityProtocol willSendGift = e.giftWillSend(gift);
                        widget.onSendTap?.call(willSendGift);
                        Navigator.maybeOf(context)?.pop();
                      },
                    ),
                  )
                  .toList(),
            ),
          )
        ],
      ),
    );
  }
}

class ChatRoomGiftPage extends StatefulWidget {
  const ChatRoomGiftPage({
    required this.giftEntities,
    this.placeholder,
    this.crossAxisCount = 4,
    this.mainAxisSpacing = 14.0,
    this.crossAxisSpacing = 14.0,
    this.childAspectRatio = 80.0 / 98.0,
    this.onSendTap,
    super.key,
  });

  final int crossAxisCount;

  final double mainAxisSpacing;

  final double crossAxisSpacing;

  final double childAspectRatio;

  final String? placeholder;

  final void Function(GiftEntityProtocol gift)? onSendTap;

  final List<GiftEntityProtocol> giftEntities;

  @override
  State<ChatRoomGiftPage> createState() => _ChatRoomGiftPageState();
}

class _ChatRoomGiftPageState extends State<ChatRoomGiftPage>
    with AutomaticKeepAliveClientMixin {
  int selectedIndex = -1;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return GridView.custom(
      padding: const EdgeInsets.only(left: 14, top: 4, right: 14, bottom: 0),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: widget.crossAxisCount,
        mainAxisSpacing: widget.mainAxisSpacing,
        crossAxisSpacing: widget.crossAxisSpacing,
        childAspectRatio: widget.childAspectRatio,
      ),
      childrenDelegate: SliverChildBuilderDelegate((context, position) {
        return InkWell(
          onTap: () {
            setState(() {
              selectedIndex = selectedIndex == position ? -1 : position;
            });
          },
          child: ChatRoomGiftItem(
            placeholder: widget.placeholder,
            selected: selectedIndex == position,
            gift: widget.giftEntities[position],
            onSendTap: widget.onSendTap,
          ),
        );
      }, childCount: widget.giftEntities.length),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class ChatRoomGiftItem extends StatelessWidget {
  const ChatRoomGiftItem({
    required this.gift,
    this.placeholder,
    this.onSendTap,
    this.selected = false,
    super.key,
  });

  final String? placeholder;
  final GiftEntityProtocol gift;
  final void Function(GiftEntityProtocol entity)? onSendTap;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    Widget placeholderWidget = (placeholder != null)
        ? Image.asset(placeholder!, fit: BoxFit.fill)
        : (ChatRoomSettings.defaultGiftIcon == null)
            ? Container()
            : Image.asset(
                ChatRoomSettings.defaultGiftIcon!,
              );

    Widget imageWidget = ChatImageLoader.networkImage(
      image: gift.giftIcon,
      placeholderWidget: placeholderWidget,
      fit: BoxFit.fill,
    );

    imageWidget = Container(
        padding: const EdgeInsets.fromLTRB(0, 4, 0, 2), child: imageWidget);

    List<Widget> widgets = [];
    widgets.add(
      Expanded(
        child: imageWidget,
      ),
    );

    if (selected) {
      widgets.addAll([
        Text(
          gift.giftPrice.toString(),
          style: TextStyle(
            fontWeight:
                ChatUIKitTheme.of(context).font.labelExtraSmall.fontWeight,
            fontSize: ChatUIKitTheme.of(context).font.labelExtraSmall.fontSize,
            color: (ChatUIKitTheme.of(context).color.isDark
                ? ChatUIKitTheme.of(context).color.neutralColor6
                : ChatUIKitTheme.of(context).color.neutralColor5),
          ),
        ),
        InkWell(
          onTap: () => onSendTap?.call(gift),
          child: Container(
            height: 28,
            decoration: BoxDecoration(
              color: (ChatUIKitTheme.of(context).color.isDark
                  ? ChatUIKitTheme.of(context).color.primaryColor5
                  : ChatUIKitTheme.of(context).color.primaryColor6),
            ),
            child: Center(
              child: Text(
                ChatroomLocal.sent.getString(context),
                style: TextStyle(
                  fontWeight:
                      ChatUIKitTheme.of(context).font.labelMedium.fontWeight,
                  fontSize:
                      ChatUIKitTheme.of(context).font.labelMedium.fontSize,
                  color: ChatUIKitTheme.of(context).color.neutralColor98,
                ),
              ),
            ),
          ),
        ),
      ]);
    } else {
      widgets.addAll([
        const SizedBox(height: 8),
        SizedBox(
          height: 20,
          child: Text(
            gift.giftName,
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
            softWrap: false,
            style: TextStyle(
              fontWeight: ChatUIKitTheme.of(context).font.titleSmall.fontWeight,
              fontSize: ChatUIKitTheme.of(context).font.titleSmall.fontSize,
              color: (ChatUIKitTheme.of(context).color.isDark
                  ? ChatUIKitTheme.of(context).color.neutralColor98
                  : ChatUIKitTheme.of(context).color.neutralColor1),
            ),
          ),
        ),
        SizedBox(
          height: 14,
          child: Text(
            gift.giftPrice.toString(),
            style: TextStyle(
              fontWeight:
                  ChatUIKitTheme.of(context).font.labelExtraSmall.fontWeight,
              fontSize:
                  ChatUIKitTheme.of(context).font.labelExtraSmall.fontSize,
              color: (ChatUIKitTheme.of(context).color.isDark
                  ? ChatUIKitTheme.of(context).color.neutralColor6
                  : ChatUIKitTheme.of(context).color.neutralColor5),
            ),
          ),
        ),
      ]);
    }

    Widget content = Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: widgets,
    );

    content = Container(
      clipBehavior: selected ? Clip.hardEdge : Clip.none,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: selected
              ? (ChatUIKitTheme.of(context).color.isDark
                  ? ChatUIKitTheme.of(context).color.primaryColor5
                  : ChatUIKitTheme.of(context).color.primaryColor6)
              : Colors.transparent,
        ),
      ),
      child: content,
    );

    return content;
  }
}
