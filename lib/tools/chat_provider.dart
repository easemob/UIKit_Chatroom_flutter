import 'package:flutter/widgets.dart';

class ChatProvider<T extends ChatUIKitChangeNotifier> extends StatefulWidget {
  final T data;
  final Widget child;
  const ChatProvider({
    super.key,
    required this.data,
    required this.child,
  });

  static T of<T>(BuildContext context) {
    final widget =
        context.dependOnInheritedWidgetOfExactType<ChatShareDataWidget<T>>();
    return widget!.data;
  }

  @override
  State<ChatProvider<T>> createState() => _ChatProviderState<T>();
}

class _ChatProviderState<T extends ChatUIKitChangeNotifier>
    extends State<ChatProvider<T>> {
  void update() {
    setState(() {});
  }

  @override
  void initState() {
    widget.data.addListener(update);
    super.initState();
  }

  @override
  void dispose() {
    widget.data.removeListener(update);
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant ChatProvider<T> oldWidget) {
    if (widget.data != oldWidget.data) {
      oldWidget.data.removeListener(update);
      widget.data.addListener(update);
      if (widget.data.needSaveData) {
        widget.data.updateData(oldWidget.data);
      }
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return ChatShareDataWidget<T>(
      data: widget.data,
      child: widget.child,
    );
  }
}

class ChatShareDataWidget<T> extends InheritedWidget {
  const ChatShareDataWidget({
    super.key,
    required super.child,
    required this.data,
  });

  final T data;

  @override
  bool updateShouldNotify(ChatShareDataWidget<T> oldWidget) {
    return true;
  }
}

abstract class ChatUIKitChangeNotifier extends ChangeNotifier {
  @protected
  void updateData(data);

  @protected
  bool get needSaveData;
}
