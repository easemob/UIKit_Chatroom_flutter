import '../../inner_headers.dart';

import 'package:flutter/material.dart';

class ChatAvatar extends StatelessWidget {
  const ChatAvatar({
    required this.width,
    required this.height,
    this.cornerRadius,
    this.margin,
    this.user,
    super.key,
  });

  final UserInfoProtocol? user;
  final double width;
  final double height;
  final CornerRadius? cornerRadius;
  final EdgeInsets? margin;

  @override
  Widget build(BuildContext context) {
    double circular = 0;
    CornerRadius radius = cornerRadius ?? ChatRoomSettings.avatarRadius;
    if (radius == CornerRadius.extraSmall) {
      circular = height / 16;
    } else if (radius == CornerRadius.small) {
      circular = height / 8;
    } else if (radius == CornerRadius.medium) {
      circular = height / 4;
    } else {
      circular = height / 2;
    }

    return Container(
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(circular)),
      ),
      margin: margin,
      width: width,
      height: height,
      child: () {
        if (user?.avatarURL?.isNotEmpty == true) {
          return ChatImageLoader.networkImage(
            image: user?.avatarURL ?? '',
            size: width,
            placeholderWidget: (ChatRoomSettings.userDefaultAvatar == null)
                ? ChatImageLoader.defaultAvatar(size: width)
                : Image.asset(ChatRoomSettings.userDefaultAvatar!),
          );
        } else {
          return ChatImageLoader.avatar(size: width);
        }
      }(),
    );
  }
}
