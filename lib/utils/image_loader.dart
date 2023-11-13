import 'package:flutter/material.dart';

class ChatImageLoader {
  static Widget emoji(String imageName, {double size = 36}) {
    String name = imageName.substring(3, imageName.length - 1);
    return Image.asset(
      'assets/images/emojis/$name',
      package: 'chatroom_uikit',
      width: size,
      height: size,
    );
  }

  static Widget airplane({double size = 30, Color? color}) {
    return Image.asset(
      'assets/images/airplane/airplane.png',
      package: 'chatroom_uikit',
      width: size,
      height: size,
    );
  }

  static Widget textKeyboard({double size = 30, Color? color}) {
    return Image.asset(
      'assets/images/textKeyboard/textKeyboard.png',
      package: 'chatroom_uikit',
      width: size,
      height: size,
      color: color,
    );
  }

  static Widget face({double size = 30, Color? color}) {
    return Image.asset(
      'assets/images/face/face.png',
      package: 'chatroom_uikit',
      width: size,
      height: size,
      color: color,
    );
  }

  static Widget avatar({double size = 30, Color? color}) {
    return Image.asset(
      'assets/images/avatar/avatar.png',
      package: 'chatroom_uikit',
      width: size,
      height: size,
      color: color,
    );
  }

  static Widget chatRaise({double size = 30, Color? color}) {
    return Image.asset(
      'assets/images/chatRaise/chatRaise.png',
      package: 'chatroom_uikit',
      width: size,
      height: size,
      color: color,
    );
  }

  static Widget more({double size = 30, Color? color}) {
    return Image.asset(
      'assets/images/more/more.png',
      package: 'chatroom_uikit',
      width: size,
      height: size,
      color: color,
    );
  }

  static Widget search({double size = 30, Color? color}) {
    return Image.asset(
      'assets/images/search/search.png',
      package: 'chatroom_uikit',
      width: size,
      height: size,
      color: color,
    );
  }

  static Widget selected({double size = 30, Color? color}) {
    return Image.asset(
      'assets/images/selected/selected.png',
      package: 'chatroom_uikit',
      width: size,
      height: size,
      color: color,
    );
  }

  static Widget success({double size = 30, Color? color}) {
    return Image.asset(
      'assets/images/success/success.png',
      package: 'chatroom_uikit',
      width: size,
      height: size,
      color: color,
    );
  }

  static Widget unselected({double size = 30, Color? color}) {
    return Image.asset(
      'assets/images/unselected/unselected.png',
      package: 'chatroom_uikit',
      width: size,
      height: size,
      color: color,
    );
  }

  static Widget inputChat({double size = 30, Color? color}) {
    return Image.asset(
      'assets/images/chat/chat.png',
      package: 'chatroom_uikit',
      width: size,
      height: size,
      color: color,
    );
  }

  static Widget delete({double size = 30, Color? color}) {
    return Image.asset(
      'assets/images/delete/delete.png',
      package: 'chatroom_uikit',
      width: size,
      height: size,
      color: color,
    );
  }

  static Widget empty({double size = 140, Color? color}) {
    return Image.asset(
      'assets/images/empty/empty.png',
      package: 'chatroom_uikit',
      width: size,
      height: size,
      color: color,
    );
  }

  static Widget defaultGift({double size = 30, Color? color}) {
    return Image.asset(
      'assets/images/gift/default_gift.png',
      package: 'chatroom_uikit',
      width: size,
      height: size,
      color: color,
    );
  }

  static Widget defaultAvatar({double size = 30, Color? color}) {
    return Icon(Icons.perm_identity, size: size, color: color);
  }

  static Widget networkImage({
    String? image,
    Widget? placeholderWidget,
    double? size,
    BoxFit fit = BoxFit.fill,
  }) {
    if (image == null) {
      return placeholderWidget ?? Container();
    }

    return FadeInImage(
      width: size,
      height: size,
      placeholder: const NetworkImage(''),
      placeholderFit: fit,
      placeholderErrorBuilder: (context, error, stackTrace) {
        return placeholderWidget ?? Container();
      },
      image: NetworkImage(image),
      fit: fit,
      imageErrorBuilder: (context, error, stackTrace) {
        return placeholderWidget ?? Container();
      },
    );
  }
}
