import 'package:flutter/widgets.dart';

class ChatImageLoader {
  static emoji(String imageName, {double size = 36}) {
    String name = imageName.substring(2);
    return Image.asset(
      'images/emojis/$name',
      package: 'chatroom_uikit',
      width: size,
      height: size,
    );
  }

  static sendGift({double size = 36}) {
    return Image.asset(
      'images/sendGift/sendGift.png',
      package: 'chatroom_uikit',
      width: size,
      height: size,
    );
  }

  static airplane({double size = 30, Color? color}) {
    return Image.asset(
      'images/airplane/airplane.png',
      package: 'chatroom_uikit',
      width: size,
      height: size,
    );
  }

  static textKeyboard({double size = 30, Color? color}) {
    return Image.asset(
      'images/textKeyboard/textKeyboard.png',
      package: 'chatroom_uikit',
      width: size,
      height: size,
      color: color,
    );
  }

  static face({double size = 30, Color? color}) {
    return Image.asset(
      'images/face/face.png',
      package: 'chatroom_uikit',
      width: size,
      height: size,
      color: color,
    );
  }

  static avatar({double size = 30, Color? color}) {
    return Image.asset(
      'images/avatar/avatar.png',
      package: 'chatroom_uikit',
      width: size,
      height: size,
      color: color,
    );
  }

  static chatRaise({double size = 30, Color? color}) {
    return Image.asset(
      'images/chatRaise/chatRaise.png',
      package: 'chatroom_uikit',
      width: size,
      height: size,
      color: color,
    );
  }

  static more({double size = 30, Color? color}) {
    return Image.asset(
      'images/more/more.png',
      package: 'chatroom_uikit',
      width: size,
      height: size,
      color: color,
    );
  }

  static search({double size = 30, Color? color}) {
    return Image.asset(
      'images/search/search.png',
      package: 'chatroom_uikit',
      width: size,
      height: size,
      color: color,
    );
  }

  static selected({double size = 30, Color? color}) {
    return Image.asset(
      'images/selected/selected.png',
      package: 'chatroom_uikit',
      width: size,
      height: size,
      color: color,
    );
  }

  static success({double size = 30, Color? color}) {
    return Image.asset(
      'images/success/success.png',
      package: 'chatroom_uikit',
      width: size,
      height: size,
      color: color,
    );
  }

  static unselected({double size = 30, Color? color}) {
    return Image.asset(
      'images/unselected/unselected.png',
      package: 'chatroom_uikit',
      width: size,
      height: size,
      color: color,
    );
  }

  static inputChat({double size = 30, Color? color}) {
    return Image.asset(
      'images/chat/chat.png',
      package: 'chatroom_uikit',
      width: size,
      height: size,
      color: color,
    );
  }

  static delete({double size = 30, Color? color}) {
    return Image.asset(
      'images/delete/delete.png',
      package: 'chatroom_uikit',
      width: size,
      height: size,
      color: color,
    );
  }
}
