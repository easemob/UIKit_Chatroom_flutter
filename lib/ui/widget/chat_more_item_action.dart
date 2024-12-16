import '../../inner_headers.dart';
import 'package:flutter/widgets.dart';

class ChatMoreItemAction {
  const ChatMoreItemAction({
    required this.title,
    this.onPressed,
    this.highlight = false,
  });
  final String title;
  final bool highlight;
  final void Function(
    BuildContext context,
    String roomId,
    String userId,
    UserInfoProtocol? user,
  )? onPressed;
}
