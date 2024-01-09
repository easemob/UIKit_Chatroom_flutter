import 'package:chatroom_uikit/chatroom_uikit.dart';

import 'package:chatroom_uikit_example/chatroom_list_page.dart';
import 'package:chatroom_uikit_example/chatroom_page.dart';
import 'package:chatroom_uikit_example/ui_test/my_notification.dart';

import 'package:chatroom_uikit_example/ui_test/ui_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

const String appKey = '';

void main() async {
  await ChatroomUIKitClient.instance.initWithAppkey(
    appKey,
    debugMode: true,
    autoLogin: false,
  );
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final FlutterLocalization _localization = FlutterLocalization.instance;
  bool isShow = false;

  bool isLight = true;

  @override
  void initState() {
    _localization.init(mapLocales: [
      const MapLocale('zh', ChatroomLocal.zh),
      const MapLocale('en', ChatroomLocal.en),
    ], initLanguageCode: 'zh');

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      supportedLocales: _localization.supportedLocales,
      localizationsDelegates: _localization.localizationsDelegates,
      builder: EasyLoading.init(
        builder: (context, child) {
          return NotificationListener(
            onNotification: (notification) {
              if (notification is MyNotification) {
                setState(() {
                  isLight = notification.isLight;
                });
              }
              return false;
            },
            child: ChatUIKitTheme(
              color: isLight ? ChatUIKitColor.dark() : ChatUIKitColor.light(),
              child: child!,
            ),
          );
        },
      ),
      onGenerateRoute: (settings) {
        return MaterialPageRoute(builder: (context) {
          if (settings.name == "ui_test") {
            return const UIPage();
          } else if (settings.name == "chatroom_list") {
            return const ChatRoomListPage();
          } else if (settings.name == "chatroom_page") {
            List<String?> list = settings.arguments as List<String?>;
            return ChatRoomPage(roomId: list[0]!, ownerId: list[1]!);
          } else {
            return Container();
          }
        });
      },
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String? _userId;
  String? _password;
  String? _nickname;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Locale local = Localizations.localeOf(context);
    debugPrint('local: $local');
    return Scaffold(
      appBar: AppBar(
        title: const Text('Plugin example app'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: ListView(
          children: [
            Column(
              children: [
                ElevatedButton(
                  child: const Text("ui_test"),
                  onPressed: () {
                    Navigator.of(context).pushNamed("ui_test");
                  },
                ),
                TextField(
                  decoration: const InputDecoration(
                    hintText: 'userId',
                  ),
                  onChanged: (value) {
                    _userId = value;
                  },
                ),
                TextField(
                  decoration: const InputDecoration(
                    hintText: 'token',
                  ),
                  onChanged: (value) {
                    _password = value;
                  },
                ),
                TextField(
                  decoration: const InputDecoration(
                    hintText: 'nickname',
                  ),
                  onChanged: (value) {
                    _nickname = value;
                  },
                ),
                ElevatedButton(
                  child: const Text("chatroom_list"),
                  onPressed: () {
                    // EasyLoading.showError('not support yet');
                    loginAndPushRoom();
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void pushToChatRoomList() {
    Navigator.of(context).pushNamed('chatroom_list');
    return;
  }

  Future<void> loginAndPushRoom() async {
    if (_userId?.isNotEmpty == true && (_password?.isNotEmpty == true)) {
      EasyLoading.show(status: 'login...');
      UserEntity user = UserEntity(_userId!, nickname: _nickname);
      try {
        await ChatroomUIKitClient.instance.loginWithPassword(
          userId: _userId!,
          password: _password!,
          userInfo: user,
        );
        pushToChatRoomList();
      } on ChatError catch (e) {
        if (e.code == 200) {
          ChatroomUIKitClient.instance.updateUserInfo(user: user);
          pushToChatRoomList();
        } else {
          EasyLoading.showError(e.toString());
        }
      }
      EasyLoading.dismiss();
    } else {
      EasyLoading.showError('userId or password is empty');
    }
  }
}
