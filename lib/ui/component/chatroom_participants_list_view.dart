import '../../inner_headers.dart';
import 'package:flutter/material.dart';

typedef ChatroomShowParticipantViewAction = void Function(
    String roomId, List<ChatroomParticipantPageController>?);

class ChatroomParticipantsListView extends StatefulWidget {
  const ChatroomParticipantsListView({
    required this.services,
    required this.roomId,
    required this.ownerId,
    this.itemBuilder,
    this.onError,
    super.key,
  });
  final String roomId;
  final String ownerId;
  final Widget Function(
    String userId,
    String? roomId,
  )? itemBuilder;

  final List<ChatroomParticipantPageController> services;
  final void Function(ChatError error)? onError;

  @override
  State<ChatroomParticipantsListView> createState() =>
      ChatroomParticipantsListViewState();

  static ChatroomParticipantsListViewState? of(BuildContext context) {
    final ChatroomParticipantsListViewState? state =
        context.findAncestorStateOfType<ChatroomParticipantsListViewState>();
    return state;
  }
}

class ChatroomParticipantsListViewState
    extends State<ChatroomParticipantsListView>
    with SingleTickerProviderStateMixin, ChatUIKitThemeMixin {
  late TabController _tabController;

  ValueNotifier onSearch = ValueNotifier(false);

  String get roomId => widget.roomId;
  String get ownerId => widget.ownerId;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: widget.services.length);
  }

  @override
  Widget themeBuilder(BuildContext context, ChatUIKitTheme theme) {
    String? ownerId = ChatRoomUIKit.roomController(context)?.ownerId;
    String? roomId = ChatRoomUIKit.roomController(context)?.roomId;
    Widget content = ValueListenableBuilder(
        valueListenable: onSearch,
        builder: (context, value, child) {
          Widget content = ChatBottomSheetBackground(
            showGrip: !value,
            child: Column(
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  height: value ? 0 : 44,
                  child: TabBar(
                    dividerColor: Colors.transparent,
                    indicator: CustomTabIndicator(
                      radius: 2,
                      color: theme.color.isDark
                          ? theme.color.primaryColor6
                          : theme.color.primaryColor5,
                      size: value ? Size.zero : const Size(28, 4),
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
                    tabs: widget.services
                        .map(
                          (e) => Tab(
                            text: e.title(context, roomId, ownerId),
                          ),
                        )
                        .toList(),
                  ),
                ),
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: widget.services
                        .map(
                          (service) => ChatRoomParticipantsPage(
                            service: service,
                            onError: widget.onError,
                            onSearch: (isSearch) {
                              setState(() {
                                onSearch.value = isSearch;
                              });
                            },
                          ),
                        )
                        .toList(),
                  ),
                )
              ],
            ),
          );

          content = AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeOut,
            height: value
                ? MediaQuery.of(context).size.height - 54
                : MediaQuery.of(context).size.height * 3 / 5,
            child: content,
          );
          return content;
        });

    return content;
  }
}

class ChatRoomParticipantsPage extends StatefulWidget {
  const ChatRoomParticipantsPage({
    super.key,
    required this.service,
    this.onError,
    this.onSearch,
  });

  final ChatroomParticipantPageController service;
  final void Function(ChatError e)? onError;
  final void Function(bool onSearch)? onSearch;

  @override
  State<ChatRoomParticipantsPage> createState() =>
      _ChatRoomParticipantsPageState();
}

class _ChatRoomParticipantsPageState extends State<ChatRoomParticipantsPage>
    with AutomaticKeepAliveClientMixin, ChatUIKitThemeMixin {
  List<ChatRoomParticipantItemData> list = [];
  List<String> showUsers = [];
  Map<String, String> detailsMap = {};
  bool firstLoading = true;
  bool loadingMore = false;
  late ScrollController scrollController;
  ValueNotifier isSearch = ValueNotifier(false);
  String keyword = '';
  late String roomId;
  late String ownerId;
  FocusNode focusNode = FocusNode();
  late ChatroomParticipantPageController controller;

  @override
  void initState() {
    super.initState();
    roomId = ChatroomParticipantsListView.of(context)!.roomId;
    ownerId = ChatroomParticipantsListView.of(context)!.ownerId;
    scrollController = ScrollController()
      ..addListener(() async {
        if (isSearch.value) return;
        if (scrollController.position.maxScrollExtent <
            scrollController.position.pixels + 40) {
          if (loadingMore) {
            return;
          }
          loadingMore = true;
          await loadMoreUsers();
          loadingMore = false;
        }
      });
    reloadUsers();
  }

  List<ChatRoomParticipantItemData> getList() {
    if (!isSearch.value || keyword.isEmpty) {
      return list;
    }

    List<ChatRoomParticipantItemData> result = list.where((element) {
      return element.searchKey().contains(keyword);
    }).toList();

    return result;
  }

  @override
  Widget themeBuilder(BuildContext context, ChatUIKitTheme theme) {
    super.build(context);
    if (firstLoading) {
      return firstLoadingWidget();
    }

    String? roomId = ChatroomParticipantsListView.of(context)?.roomId;
    String? ownerId = ChatroomParticipantsListView.of(context)?.ownerId;
    List<ChatRoomParticipantItemData> tmpList = getList();

    Widget content = ListView.separated(
      itemBuilder: (context, index) {
        String userId = tmpList[index].userId;
        showUsers.add(userId);
        return ChatRoomParticipantItem(
          tmpList[index],
          onDismissed: () => showUsers.remove(userId),
          onMoreAction: (widget.service
                          .itemMoreActions(context, userId, roomId, ownerId) !=
                      null &&
                  Client.getInstance.currentUserId != userId)
              ? () {
                  moreActionTap(tmpList[index]);
                }
              : null,
        );
      },
      controller: scrollController,
      separatorBuilder: (context, index) => Divider(
        indent: 68,
        color: (theme.color.isDark
            ? theme.color.neutralColor1
            : theme.color.neutralColor9),
      ),
      cacheExtent: 100,
      itemCount: tmpList.length,
    );

    if (!isSearch.value) {
      content = RefreshIndicator(
        onRefresh: () async {
          await reloadUsers();
        },
        child: content,
      );
    }

    content = NotificationListener<ScrollNotification>(
      onNotification: (notification) {
        if (notification is ScrollEndNotification) {
          updateShowUserInfo();
        }
        return false;
      },
      child: content,
    );

    content = Column(
      children: [
        searchBar(),
        () {
          if (isSearch.value != true || keyword.isNotEmpty) {
            if (tmpList.isEmpty) {
              return Align(
                heightFactor: 1.5,
                child: widget.service.emptyBackground(context),
              );
            } else {
              return Expanded(child: content);
            }
          } else {
            return Container();
          }
        }(),
      ],
    );

    content = PopScope(
      child: content,
      onPopInvoked: (didPop) async {
        focusNode.unfocus();
      },
    );

    return content;
  }

  Widget searchBar() {
    Widget content;

    content = ValueListenableBuilder(
      valueListenable: isSearch,
      builder: (context, value, child) {
        Widget content;
        if (value) {
          content = Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Container(
                  margin: const EdgeInsets.fromLTRB(16, 4, 0, 4),
                  height: 36,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(18),
                    color: (theme.color.isDark
                        ? theme.color.neutralColor2
                        : theme.color.neutralColor95),
                  ),
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(8, 6, 4, 8),
                        child: ChatImageLoader.search(
                          size: 20,
                          color: (theme.color.isDark
                              ? theme.color.neutralColor4
                              : theme.color.neutralColor6),
                        ),
                      ),
                      Expanded(
                        child: TextField(
                          style: TextStyle(
                              color: theme.color.isDark
                                  ? theme.color.neutralColor98
                                  : theme.color.neutralColor1,
                              fontWeight: theme.font.bodyLarge.fontWeight,
                              fontSize: theme.font.bodyLarge.fontSize),
                          keyboardAppearance: theme.color.isDark
                              ? Brightness.dark
                              : Brightness.light,
                          focusNode: focusNode,
                          decoration: InputDecoration(
                            border: const OutlineInputBorder(
                                borderSide: BorderSide.none),
                            contentPadding: const EdgeInsets.symmetric(
                              vertical: -8,
                            ),
                            hintText: ChatroomLocal.search.getString(context),
                            hintStyle: TextStyle(
                              fontWeight: theme.font.bodyLarge.fontWeight,
                              fontSize: theme.font.bodyLarge.fontSize,
                              color: (theme.color.isDark
                                  ? theme.color.neutralColor4
                                  : theme.color.neutralColor6),
                            ),
                          ),
                          onChanged: (value) {
                            setState(() {
                              keyword = value;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.fromLTRB(19, 4, 20, 4),
                child: InkWell(
                  onTap: () {
                    keyword = '';
                    showUsers.clear();
                    isSearch.value = false;
                    widget.onSearch?.call(false);
                    focusNode.unfocus();
                  },
                  child: Text(
                    ChatroomLocal.cancel.getString(context),
                    style: TextStyle(
                      color: (theme.color.isDark
                          ? theme.color.neutralColor6
                          : theme.color.primaryColor5),
                      fontWeight: theme.font.labelMedium.fontWeight,
                      fontSize: theme.font.labelMedium.fontSize,
                    ),
                  ),
                ),
              ),
            ],
          );
        } else {
          content = Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            height: 36,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              color: (theme.color.isDark
                  ? theme.color.neutralColor2
                  : theme.color.neutralColor95),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ChatImageLoader.search(
                  size: 22,
                  color: (theme.color.isDark
                      ? theme.color.neutralColor4
                      : theme.color.neutralColor6),
                ),
                const SizedBox(width: 5.83),
                Text(
                  ChatroomLocal.search.getString(context),
                  style: TextStyle(
                    fontWeight: theme.font.bodyLarge.fontWeight,
                    fontSize: theme.font.bodyLarge.fontSize,
                    color: (theme.color.isDark
                        ? theme.color.neutralColor4
                        : theme.color.neutralColor6),
                  ),
                ),
              ],
            ),
          );

          content = InkWell(
            onTap: () {
              isSearch.value = true;
              widget.onSearch?.call(true);
              focusNode.requestFocus();
            },
            child: content,
          );
        }

        return content;
      },
    );

    return content;
  }

  void moreActionTap(ChatRoomParticipantItemData itemData) {
    // if (!isSearch.value) {
    //   // 搜索状态下是否关闭当前模态
    //   Navigator.of(context).pop();
    // }
    Navigator.of(context).pop();
    String? ownerId = ChatroomParticipantsListView.of(context)?.ownerId;
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
        List<ChatBottomSheetItem> list = widget.service
            .itemMoreActions(context, itemData.userId, roomId, ownerId)!
            .map((e) {
          return ChatBottomSheetItem(
            label: e.title,
            onTap: () {
              Navigator.of(context).pop();
              e.onPressed?.call(
                context,
                roomId,
                itemData.userId,
                itemData.info,
              );
            },
            type: e.highlight
                ? ChatBottomSheetItemType.destructive
                : ChatBottomSheetItemType.normal,
          );
        }).toList();
        return ChatBottomSheetWidget(
          items: list,
        );
      },
    );
  }

  Future<void> reloadUsers() async {
    List<ChatRoomParticipantItemData> dataList = [];
    try {
      List<String> userIds = await widget.service.reloadUsers(roomId, ownerId);
      if (userIds.isEmpty) {
        firstLoading = false;
        if (mounted) {
          setState(() {});
        }
        return;
      }

      showUsers.clear();
      List result = await Future.wait([
        updateUserInfo(userIds),
        updateUserDetail(userIds),
      ]);

      Map<String, UserInfoProtocol>? userInfoMap = result[0];
      Map<String, String>? detailMap = result[1];

      for (var element in userIds) {
        dataList.add(ChatRoomParticipantItemData(
          element,
          info: userInfoMap?[element],
          detail: detailMap?[element],
        ));
      }

      list.clear();
      list.addAll(dataList);
    } on ChatError catch (e) {
      widget.onError?.call(e);
    }
    firstLoading = false;
    if (mounted) {
      setState(() {});
    }
  }

  Future<void> loadMoreUsers() async {
    try {
      List<String> userIds =
          await widget.service.loadMoreUsers(roomId, ownerId);
      List<ChatRoomParticipantItemData> dataList = [];
      for (var element in userIds) {
        dataList.add(ChatRoomParticipantItemData(element));
      }
      if (mounted) {
        setState(() {
          list.addAll(dataList);
        });
      }
    } on ChatError catch (e) {
      widget.onError?.call(e);
    }
  }

  Future<Map<String, UserInfoProtocol>?> updateUserInfo(
      List<String> userIds) async {
    return await ChatroomContext.instance.getUserInfo(userIds);
  }

  Future<Map<String, String>?> updateUserDetail(List<String> userIds) async {
    List<String> tmp = userIds.toList();
    tmp.removeWhere((element) => detailsMap.containsKey(element));
    if (tmp.isNotEmpty) {
      Map<String, String> details =
          await widget.service.reloadUsersDetail(roomId, tmp);
      if (details.isNotEmpty == true) {
        detailsMap.addAll(details);
      }
    }

    return detailsMap;
  }

  Future<void> updateShowUserInfo() async {
    List result = await Future.wait([
      updateUserInfo(showUsers),
      updateUserDetail(showUsers),
    ]);

    Map<String, UserInfoProtocol>? userInfoMap = result[0];
    Map<String, String> detailMap = result[1];

    for (var showUser in showUsers) {
      int index = list.indexWhere((element) => element.userId == showUser);
      if (index == -1) break;
      ChatRoomParticipantItemData data = list[index];
      list[index] = data.copyWith(
        showUser,
        info: userInfoMap?[showUser],
        detail: detailMap[showUser],
      );
    }

    showUsers.clear();
    if (mounted) {
      setState(() {});
    }
  }

  Widget firstLoadingWidget() {
    return SizedBox(
      height: 30,
      width: 30,
      child: Center(
        child: SafeArea(
          child: CircularProgressIndicator(
            strokeWidth: 2,
            color: (theme.color.isDark
                ? theme.color.neutralColor4
                : theme.color.neutralColor7),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    focusNode.dispose();
    scrollController.dispose();
    super.dispose();
  }

  @override
  bool get wantKeepAlive => true;
}

class ChatRoomParticipantItemData {
  const ChatRoomParticipantItemData(
    this.userId, {
    this.info,
    this.detail,
  });
  final String userId;
  final UserInfoProtocol? info;
  final String? detail;
  String searchKey() {
    if (info?.searchKeyword?.isNotEmpty == true) {
      return info!.searchKeyword!;
    }
    return userId;
  }

  String showName() {
    if (info?.nickname?.isNotEmpty == true) {
      return info!.nickname!;
    } else {
      return userId;
    }
  }

  ChatRoomParticipantItemData copyWith(
    String userId, {
    UserInfoProtocol? info,
    String? detail,
  }) {
    return ChatRoomParticipantItemData(
      userId,
      info: info ?? this.info,
      detail: detail ?? this.detail,
    );
  }
}

class ChatRoomParticipantItem extends StatefulWidget {
  const ChatRoomParticipantItem(
    this.user, {
    this.onDismissed,
    this.onMoreAction,
    super.key,
  });

  final ChatRoomParticipantItemData user;

  final VoidCallback? onDismissed;
  final VoidCallback? onMoreAction;

  @override
  State<ChatRoomParticipantItem> createState() =>
      _ChatRoomParticipantItemState();
}

class _ChatRoomParticipantItemState extends State<ChatRoomParticipantItem>
    with ChatUIKitThemeMixin {
  @override
  Widget themeBuilder(BuildContext context, ChatUIKitTheme theme) {
    Widget content = Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        () {
          if (widget.user.info?.identify?.isNotEmpty == true &&
              ChatRoomSettings.enableParticipantItemIdentify) {
            return Container(
              margin: const EdgeInsets.only(right: 14.7),
              width: 21.67,
              height: 21.76,
              child: ChatImageLoader.networkImage(
                image: widget.user.info?.identify ?? '',
                placeholderWidget: (ChatRoomSettings.defaultIdentify == null)
                    ? Container()
                    : Image.asset(ChatRoomSettings.defaultIdentify!),
              ),
            );
          } else {
            return Container();
          }
        }(),
        ChatAvatar(
          width: 40,
          height: 40,
          user: widget.user.info,
        ),
        Container(
          margin: const EdgeInsets.only(left: 12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.user.showName(),
                style: TextStyle(
                  fontWeight: theme.font.titleMedium.fontWeight,
                  fontSize: theme.font.titleMedium.fontSize,
                  color: (theme.color.isDark
                      ? theme.color.neutralColor98
                      : theme.color.neutralColor1),
                ),
              ),
              ...() {
                if (widget.user.detail?.isNotEmpty == true) {
                  return [
                    const SizedBox(height: 4),
                    Text(
                      widget.user.detail!,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontWeight: theme.font.bodyMedium.fontWeight,
                        fontSize: theme.font.bodyMedium.fontSize,
                        color: (theme.color.isDark
                            ? theme.color.neutralColor1
                            : theme.color.neutralColor5),
                      ),
                    )
                  ];
                } else {
                  return [Container()];
                }
              }()
            ],
          ),
        ),
        Expanded(child: Container()),
        if (widget.onMoreAction != null)
          () {
            return InkWell(
              onTap: () {
                widget.onMoreAction?.call();
              },
              child: Icon(
                Icons.more_vert,
                color: (theme.color.isDark
                    ? theme.color.neutralColor98
                    : theme.color.neutralColor6),
              ),
            );
          }()
      ],
    );

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 10, 12, 10),
      height: 60,
      color: (theme.color.isDark
          ? theme.color.neutralColor1
          : theme.color.neutralColor98),
      child: content,
    );
  }

  @override
  void dispose() {
    widget.onDismissed?.call();
    super.dispose();
  }
}
