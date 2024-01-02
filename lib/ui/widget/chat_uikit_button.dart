import 'package:chat_uikit_theme/theme.dart';
import 'package:flutter/material.dart';

enum ChatUIKitButtonType {
  primary,
  neutral,
  destructive,
}

class ChatUIKitButton extends StatelessWidget {
  const ChatUIKitButton.primary(
    this.text, {
    this.onTap,
    this.fontWeight,
    this.fontSize,
    this.radius = 0,
    this.borderWidth = 1,
    super.key,
  }) : type = ChatUIKitButtonType.primary;

  const ChatUIKitButton.neutral(
    this.text, {
    this.onTap,
    this.fontWeight,
    this.fontSize,
    this.radius = 0,
    this.borderWidth = 1,
    super.key,
  }) : type = ChatUIKitButtonType.neutral;

  const ChatUIKitButton.destructive(
    this.text, {
    this.onTap,
    this.fontWeight,
    this.fontSize,
    this.radius = 0,
    this.borderWidth = 1,
    super.key,
  }) : type = ChatUIKitButtonType.destructive;

  const ChatUIKitButton(
    this.text, {
    this.onTap,
    required this.type,
    this.fontWeight,
    this.fontSize,
    this.radius = 0,
    this.borderWidth = 1,
    super.key,
  });
  final String text;
  final VoidCallback? onTap;
  final ChatUIKitButtonType type;
  final double radius;
  final double borderWidth;
  final FontWeight? fontWeight;
  final double? fontSize;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        alignment: Alignment.center,
        clipBehavior: Clip.hardEdge,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(radius),
          border: Border.all(
            color: () {
              switch (type) {
                case ChatUIKitButtonType.primary:
                  return primaryBorderColor(context);
                case ChatUIKitButtonType.neutral:
                  return neutralBorderColor(context);
                case ChatUIKitButtonType.destructive:
                  return destructiveBorderColor(context);
              }
            }(),
            width: borderWidth,
          ),
          color: () {
            switch (type) {
              case ChatUIKitButtonType.primary:
                return primaryBgColor(context);
              case ChatUIKitButtonType.neutral:
                return neutralBgColor(context);
              case ChatUIKitButtonType.destructive:
                return destructiveBgColor(context);
            }
          }(),
        ),
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontWeight: fontWeight,
            fontSize: fontSize,
            color: () {
              switch (type) {
                case ChatUIKitButtonType.primary:
                  return primaryTextColor(context);
                case ChatUIKitButtonType.neutral:
                  return neutralTextColor(context);
                case ChatUIKitButtonType.destructive:
                  return destructiveTextColor(context);
              }
            }(),
          ),
        ),
      ),
    );
  }

  Color primaryBorderColor(BuildContext context) {
    return (ChatUIKitTheme.of(context).color.isDark
        ? ChatUIKitTheme.of(context).color.primaryColor6
        : ChatUIKitTheme.of(context).color.primaryColor5);
  }

  Color neutralBorderColor(BuildContext context) {
    return (ChatUIKitTheme.of(context).color.isDark
        ? ChatUIKitTheme.of(context).color.neutralColor4
        : ChatUIKitTheme.of(context).color.neutralColor7);
  }

  Color destructiveBorderColor(BuildContext context) {
    return (ChatUIKitTheme.of(context).color.isDark
        ? ChatUIKitTheme.of(context).color.neutralColor4
        : ChatUIKitTheme.of(context).color.neutralColor7);
  }

  Color primaryTextColor(BuildContext context) {
    return (ChatUIKitTheme.of(context).color.isDark
        ? ChatUIKitTheme.of(context).color.neutralColor98
        : ChatUIKitTheme.of(context).color.neutralColor1);
  }

  Color neutralTextColor(BuildContext context) {
    return (ChatUIKitTheme.of(context).color.isDark
        ? ChatUIKitTheme.of(context).color.neutralColor95
        : ChatUIKitTheme.of(context).color.neutralColor3);
  }

  Color destructiveTextColor(BuildContext context) {
    return (ChatUIKitTheme.of(context).color.isDark
        ? ChatUIKitTheme.of(context).color.errorColor6
        : ChatUIKitTheme.of(context).color.errorColor5);
  }

  Color primaryBgColor(BuildContext context) {
    return (ChatUIKitTheme.of(context).color.isDark
        ? ChatUIKitTheme.of(context).color.primaryColor6
        : ChatUIKitTheme.of(context).color.primaryColor5);
  }

  Color neutralBgColor(BuildContext context) {
    return (ChatUIKitTheme.of(context).color.isDark
        ? ChatUIKitTheme.of(context).color.neutralColor1
        : ChatUIKitTheme.of(context).color.neutralColor98);
  }

  Color destructiveBgColor(BuildContext context) {
    return (ChatUIKitTheme.of(context).color.isDark
        ? ChatUIKitTheme.of(context).color.neutralColor1
        : ChatUIKitTheme.of(context).color.neutralColor98);
  }
}
