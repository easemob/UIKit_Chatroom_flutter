
# 聊天室 UIKit 介绍

本产品主要为了解决大部分用户的泛娱乐业务场景下对聊天室的绝大部分用户需求，主要为用户解决直接集成 SDK 繁琐，复杂度高，部分 api 体验不好（在用户侧开发者来看）等问题。致力于打造集成简单，自由度高，流程简单，文档说明足够详细的聊天室 UIKit 产品。

## 开发环境要求

- sdk: '>=3.0.0 <4.0.0'
- flutter: ">=3.3.0"

对于 `iOS` 应用：

- Xcode 13+;
- ios 11+;

对于 `Android` 应用：

- minSDKVersion 21

release 时需要在在 `xxx/android/app/proguard-rules.pro` 中设置免混淆规则：

```java
-keep class com.hyphenate.** {*;}
-dontwarn  com.hyphenate.**
```

## 安装 UIKit 到项目中

```sh
flutter pub get add chatroom_uikit
```

## 运行 example

[example](./example/README.md)

## 项目结构

项目的主要结构如下：

```sh
.
├── chatroom_localizations.dart // 国际化工具
├── chatroom_settings.dart // 组件配置
├── chatroom_uikit.dart // ChatroomUIKit 组件
├── chatroom_uikit_client.dart // ChatroomUIKit 初始化类。
├── service // 基础服务组件。
│   ├── controllers // UI 组件协议
│   │   ├── chat_report_controller.dart
│   │   ├── chat_text_editing_controller.dart
│   │   ├── chatroom_controller.dart
│   │   ├── chatroom_message_list_controller.dart
│   │   ├── gift_page_controller.dart
│   │   └── participant_page_controller.dart
│   ├── default
│   │   ├── controllers // UI 组件协议实现
│   │   │   ├── default_gift_page_controller.dart
│   │   │   ├── default_members_controller.dart
│   │   │   ├── default_message_list_controller.dart
│   │   │   ├── default_mutes_controller.dart
│   │   │   └── default_report_controller.dart
│   │   └── data  // UI 组件数据协议
│   │       ├── gift_entity.dart
│   │       └── user_entity.dart
│   ├── implement // 协议实现组件。
│   │   ├── chatroom_context.dart
│   │   ├── chatroom_service_implement.dart
│   │   ├── gift_service_implement.dart
│   │   └── user_service_implement.dart
│   └── protocol // 业务协议组件。
│       ├── chatroom_service.dart
│       ├── gift_service.dart
│       └── user_service.dart
├── ui // 基本UI组件
│   ├── component
│   │   ├── chatroom_gift_list_view.dart
│   │   ├── chatroom_gift_message_list_view.dart
│   │   ├── chatroom_global_broad_cast_view.dart
│   │   ├── chatroom_message_list_view.dart
│   │   ├── chatroom_participants_list_view.dart
│   │   └── chatroom_report_list_view.dart
│   └── widget
│       ├── chat_avatar.dart
│       ├── chat_bottom_sheet.dart
│       ├── chat_bottom_sheet_background.dart
│       ├── chat_dialog.dart
│       ├── chat_input_bar.dart
│       ├── chat_input_emoji.dart
│       ├── chat_more_item_action.dart
│       ├── chat_uikit_button.dart
│       └── custom_tab_indicator.dart
└── utils // 工具类
    ├── chatroom_enums.dart
    ├── chatroom_event_item_action.dart
    ├── define.dart
    ├── extension.dart
    ├── icon_image_provider.dart
    ├── image_loader.dart
    ├── language_convertor.dart
    └── time_tool.dart
```

## 进阶用法

### 初始化 聊天室UIKit

`appkey` 需要在 [console](https://docs-im-beta.easemob.com/product/enable_and_configure_IM.html#%E5%89%8D%E6%8F%90%E6%9D%A1%E4%BB%B6) 中 注册。

```dart

await ChatroomUIKitClient.instance.initWithAppkey(appKey);

```

### 登录

需要在 [`console`](https://docs-im-beta.easemob.com/product/enable_and_configure_IM.html#%E5%88%9B%E5%BB%BA-im-%E7%94%A8%E6%88%B7) 中创建 `userId`

```dart
try {
    await ChatroomUIKitClient.instance.loginWithPassword(
        userId: userId,
        password: password, // 注册 userId 是填写的 password
        userInfo: userInfo, // 实现 UserInfoProtocol 的对象，uikit 中使用 `UserEntity`。
    );
}on ChatError catch(e) {
    // error.
}
```

也可以调用 `token` 登录, `token` 获取方式参考 [文档](https://docs-im-beta.easemob.com/product/easemob_user_token.html)

```dart
try {
    await ChatroomUIKitClient.instance.loginWithToken(
        userId: userId,
        token: userToken,   // userId 对应的token
        userInfo: userInfo, // 实现 UserInfoProtocol 的对象，uikit 中使用 `UserEntity`。
    );
}on ChatError catch(e) {
    // error.
}
```

### 设置主题颜色

可以通过 `ChatUIKitTheme` 进行主题设置，默认提供了 `light` 和 `dart` 两种主题:

```dart
ChatUIKitTheme(
  color: ChatUIKitColor.light() // 亮色主题， 暗色主题为：ChatUIKitColor.dark()
  child: child,
),
```

如果需要修改主题色，可以通过修改`ChatUIKitColor` 的 `hue` 值：

```dart
ChatUIKitColor({
  this.primaryHue = 203,
  this.secondaryHue = 155,
  this.errorHue = 350,
  this.neutralHue = 203,
  this.neutralSpecialHue = 220,
  this.barrageLightness = LightnessStyle.oneHundred,
  this.isDark = false,
});
```

### 使用 chatroom_uikit 组件

1. 需要确保 `ChatUIKitTheme` 在 `ChatroomUIKit` 组件在你项目的父节点，建议将 `ChatUIKitTheme` 放到项目的根节点。

```dart

@override
  Widget build(BuildContext context) {
    return MaterialApp(
      builder: (context, child) {
        return ChatUIKitTheme(child: child!);
      },
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
      ...
    );
  }
```

2. 在需要使用 `chatroom_uikit` 时，需要先创建 `ChatroomController`, 并使 `ChatRoomUIKit` 作为 当前页面的 根节点，并将其他组件作为 `ChatRoomUIKit` 的child。

```dart
// roomId: 房间id；
// ownerId: 房主id；
ChatroomController controller = ChatroomController(roomId: roomId, ownerId: ownerId);

@override
Widget build(BuildContext context) {
  Widget content = Scaffold(
    resizeToAvoidBottomInset: false,
    appBar: AppBar(),
    body: ChatRoomUIKit(
      controller: controller,
      child: (context) {
        // 在子组件中构建页面，比如 礼物弹窗，消息列表等。
        return ...;
      },
    ),
  );

  return content;
}

```

### 使用 ChatroomMessageListView 组件

`ChatroomMessageListView` 组件用于展示聊天室消息，使用时需要确保在 `ChatRoomUIKit` 的子节点，如果要添加 `ChatroomMessageListView` 到屏幕并设置位置，可以使用如下方式：

```dart
@override
Widget build(BuildContext context) {
  Widget content = Scaffold(
    resizeToAvoidBottomInset: false,
    appBar: AppBar(),
    body: ChatRoomUIKit(
      controller: controller,
      child: (context) {
        return const Stack(
          children: [
            Positioned(
              left: 16,
              right: 78,
              height: 204,
              bottom: 90,
              child: ChatroomMessageListView(),
            )
            ...
          ],
        );
      },
    ),
  );

  return content;
}

```

`ChatroomMessageListView` 提供了点击、长按、重绘item、设置report controller的方法。

```dart
const ChatroomMessageListView({
  this.onTap,
  this.onLongPress,
  this.itemBuilder,
  this.reportController,
  this.controller,
  super.key,
});
```

`ChatroomMessageListView` 组件默认不显示礼物，如果需要展示礼物，需要修改[ChatRoomSettings](#chatroomsettings-设置)中 `enableMsgListGift` 为 `true`。

```dart
ChatRoomSettings.enableMsgListGift = true;
```

### 使用 ChatInputBar 组件

`ChatInputBar` 用于发送消息，同时可以设置更多的点击选项，位置不可配置，默认在 [chatroom_uikit](#使用-chatroom_uikit-组件) 中，如果需要设置更多的点击事件，可以在 `ChatroomUIKit` 中进行设置。

```dart
// roomId: 房间id；
// ownerId: 房主id；
ChatroomController controller = ChatroomController(roomId: roomId, ownerId: ownerId);

@override
Widget build(BuildContext context) {
  Widget content = Scaffold(
    resizeToAvoidBottomInset: false,
    appBar: AppBar(),
    body: ChatRoomUIKit(
      controller: controller,
      inputBar: ChatInputBar(),
      child: (context) {
        // 在子组件中构建页面，比如 礼物弹窗，消息列表等。
        return ...;
      },
    ),
  );

  return content;
}

```

`ChatInputBar` 提供添加按钮的方法，包括 `leading` 和 `actions`, 其中 `actions` 最多为 4 个。

```dart
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
```

### 使用 ChatRoomGiftListView 组件

如果需要选择礼物并且进行发送，需要先进行礼物的配置，这需要在 `ChatroomController` 中配置 `giftControllers`， `giftControllers` 需要传入实现了`ChatroomGiftPageController` 协议的实例, `chatroom_uikit` 中提供了 `DefaultGiftPageController`。

```dart
ChatroomController controller = ChatroomController(
      roomId: widget.roomId,
      ownerId: widget.ownerId,
      giftControllers: () async {
        List<DefaultGiftPageController> service = [];
        // 解析 礼物 json，并将结果填入 DefaultGiftPageController 的 gifts list 中。
        final value = await rootBundle.loadString('data/Gifts.json');
        Map<String, dynamic> map = json.decode(value);
        for (var element in map.keys.toList()) {
          service.add(
            DefaultGiftPageController(
              title: element,
              gifts: () {
                List<GiftEntityProtocol> list = [];
                map[element].forEach((element) {
                  // 将 json 解析为 实现 GiftEntityProtocol 协议的对象。
                  GiftEntityProtocol? gift = ChatroomUIKitClient
                      .instance.giftService
                      .giftFromJson(element);
                  if (gift != null) {
                    list.add(gift);
                  }
                });
                return list;
              }(),
            ),
          );
        }
        return service;
      }(),
    );

```

弹出礼物选择列表。可以在[ChatInputBar](#使用-chatinputbar-组件)中添加按钮弹出礼物列表的按钮。

```dart
@override
Widget build(BuildContext context) {
  Widget content = Scaffold(
    resizeToAvoidBottomInset: false,
    appBar: AppBar(),
    body: ChatRoomUIKit(
      controller: controller,
      inputBar: ChatInputBar(
        actions: [
          InkWell(
            onTap: () => controller.showGiftSelectPages(),
            child: Padding(
              padding: const EdgeInsets.all(3),
              child: Image.asset('images/send_gift.png'),
            ),
          ),
        ],
      ),
      child: (context) {
        return Container();
      },
    ),
  );

  return content;
}

```

选择礼物后，点击 `发送` 将完成发送。

礼物的展示方式有两种，

- [ChatroomMessageListView 组件](#使用-chatroommessagelistview-组件) 展示;
- [ChatroomGiftMessageListView 组件](#使用-chatroomgiftmessagelistview-组件) 展示;

### 使用 ChatroomGiftMessageListView 组件

`ChatroomGiftMessageListView` 会展示你发送和收到的礼物，使用时需要确保在 `ChatRoomUIKit` 的子节点，如果要添加 `ChatroomGiftMessageListView` 到屏幕并设置位置，可以使用如下方式：

```dart
@override
Widget build(BuildContext context) {
  // 关闭消息列表中显示礼物。
  ChatRoomSettings.enableMsgListGift = false;
  Widget content = Scaffold(
    resizeToAvoidBottomInset: false,
    appBar: AppBar(),
    body: ChatRoomUIKit(
      controller: controller,
      child: (context) {
        return const Stack(
          children: [
            Positioned(
              left: 16,
              right: 180,
              height: 84,
              bottom: 300,
              child: ChatroomGiftMessageListView(),
            ),
            ...
          ],
        );
      },
    ),
  );

  return content;
}

```

`ChatroomGiftMessageListView` 提供了设置图标，设置默认图标，的方法。

```dart
const ChatroomGiftMessageListView({
  this.giftWidgetBuilder,
  this.placeholder,
  super.key,
});
```

### 使用 ChatroomGlobalBroadcastView 组件

`ChatroomGlobalBroadcastView` 组件用于展示全局广播，使用时需要确保在 `ChatRoomUIKit` 的子节点，如果要添加 `ChatroomGlobalBroadcastView` 到屏幕并设置位置，可以使用如下方式：

```dart

@override
Widget build(BuildContext context) {
  Widget content = Scaffold(
    resizeToAvoidBottomInset: false,
    appBar: AppBar(),
    body: ChatRoomUIKit(
      controller: controller,
      child: (context) {
        return Stack(
            children: [
              Positioned(
                top: MediaQuery.of(context).viewInsets.top + 10,
                height: 20,
                left: 20,
                right: 20,
                child: const ChatroomGlobalBroadcastView(),
              ),
              ...
            ],
          );
      },
    ),
  );

  return content;
}

```

`ChatroomGlobalBroadcastView` 提供了设置图标、字体、背景颜色的方法。

```dart
const ChatroomGlobalBroadcastView({
  this.icon,
  this.textStyle,
  this.backgroundColor,
  super.key,
});
```

### ChatRoomSettings 设置

`ChatRoomSettings` 提供了简单的设置，需要在界面展示前设置

```dart
class ChatRoomSettings {
  static String? userDefaultAvatar; // 默认头像
  static String? defaultIdentify; // 默认身份标识标识图标
  static String? defaultGiftIcon; // 默认礼物图标

  static bool enableMsgListTime = true; // 消息列表是否显示时间
  static bool enableMsgListAvatar = true; // 消息列表是否显示头像
  static bool enableMsgListNickname = true; // 消息列表是否显示昵称
  static bool enableMsgListIdentify = true; // 消息列表是否显示身份标识

  static bool enableMsgListGift = false; // 消息列表中是否展示礼物

  static bool enableParticipantItemIdentify = false; // 成员列表中是否显示身份标识

  static CornerRadius inputBarRadius = CornerRadius.large; // 输入框圆角
  static CornerRadius avatarRadius = CornerRadius.large; // 头像圆角
}

```

## 许可证

MIT
