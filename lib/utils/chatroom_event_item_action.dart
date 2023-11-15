import 'package:flutter/widgets.dart';

class ChatEventItemAction {
  const ChatEventItemAction({
    required this.title,
    this.onPressed,
    this.highlight = false,
  });
  final String title;
  final bool highlight;
  final dynamic Function(
          BuildContext context, String roomId, String userId, dynamic data)?
      onPressed;
}
