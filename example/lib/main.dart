import 'package:chat_uikit_theme/chat_uikit_theme.dart';
import 'package:chatroom_uikit_example/next.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      builder: (context, child) {
        return ChatUIKitTheme(
          // color: Theme.of(context).brightness == Brightness.light
          //     ? ChatUIKitColor.light()
          //     : ChatUIKitColor.dark(),
          color: ChatUIKitColor.light(),
          // color: ChatUIKitColor.dark(),

          child: child!,
        );
      },
      routes: {
        "next": (context) {
          return const NextPage();
        }
      },
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
          actions: [
            UnconstrainedBox(
              child: InkWell(
                child: const Icon(Icons.more_horiz),
                onTap: () {},
              ),
            )
          ],
        ),
        body: Builder(builder: (ctx) {
          return Center(
            child: ElevatedButton(
              child: const Text("Go"),
              onPressed: () {
                Navigator.of(ctx).pushNamed("next");
              },
            ),
          );
        }),
      ),
    );
  }
}
