import 'package:chatroom_uikit/chatroom_uikit.dart';
import 'package:flutter/material.dart';

typedef EmojiClick = void Function(String emoji);

class ChatInputEmoji extends StatelessWidget {
  const ChatInputEmoji({
    this.deleteOnTap,
    this.crossAxisCount = 7,
    this.mainAxisSpacing = 2.0,
    this.crossAxisSpacing = 2.0,
    this.childAspectRatio = 1.0,
    this.bigSizeRatio = 0.0,
    this.emojiClicked,
    super.key,
  });

  final int crossAxisCount;

  final double mainAxisSpacing;

  final double crossAxisSpacing;

  final double childAspectRatio;

  final double bigSizeRatio;

  final EmojiClick? emojiClicked;

  final VoidCallback? deleteOnTap;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SizedBox(
          height: 280,
          child: GridView.custom(
            controller: ScrollController(),
            padding:
                const EdgeInsets.only(left: 10, top: 10, right: 10, bottom: 60),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              mainAxisSpacing: mainAxisSpacing,
              crossAxisSpacing: crossAxisSpacing,
            ),
            childrenDelegate: SliverChildBuilderDelegate((context, position) {
              return _getEmojiItemContainer(position);
            }, childCount: EmojiMapping.emojis.length),
          ),
        ),
        Positioned(
          right: 20,
          width: 36,
          bottom: 20,
          height: 36,
          child: InkWell(
            onTap: () {
              deleteOnTap?.call();
            },
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                boxShadow: ChatUIKitTheme.of(context).color.isDark
                    ? ChatUIKitShadow.darkSmall
                    : ChatUIKitShadow.lightSmall,
                borderRadius: BorderRadius.circular(24),
                color: (ChatUIKitTheme.of(context).color.isDark
                    ? ChatUIKitTheme.of(context).color.neutralColor3
                    : ChatUIKitTheme.of(context).color.neutralColor98),
              ),
              child: ChatImageLoader.delete(
                size: 40,
                color: (ChatUIKitTheme.of(context).color.isDark
                    ? ChatUIKitTheme.of(context).color.neutralColor98
                    : ChatUIKitTheme.of(context).color.neutralColor3),
              ),
            ),
          ),
        ),
      ],
    );
  }

  _getEmojiItemContainer(int index) {
    var emoji = EmojiMapping.emojiImages[index];
    return ChatExpression(emoji, bigSizeRatio, emojiClicked);
  }
}

class ChatExpression extends StatelessWidget {
  final String emojiImage;

  final double bigSizeRatio;

  final EmojiClick? emojiClicked;

  const ChatExpression(
    this.emojiImage,
    this.bigSizeRatio,
    this.emojiClicked, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    // Widget icon = Text(
    //   emoji,
    //   style: const TextStyle(fontSize: 30),
    // );
    Widget icon = ChatImageLoader.emoji(emojiImage, size: 36);
    return TextButton(
      style: ButtonStyle(
        padding: MaterialStateProperty.all(
          EdgeInsets.all(bigSizeRatio),
        ),
      ),
      onPressed: () {
        emojiClicked?.call(EmojiMapping.replaceImageToEmoji(emojiImage));
      },
      child: icon,
    );
  }
}

class EmojiMapping {
  static String replaceImageToEmoji(String str) {
    var result = str;
    for (var emoji in emojiImages) {
      result = result.replaceAll(
          emoji, EmojiMapping.emojis[emojiImages.indexOf(emoji)]);
    }
    return result;
  }

  static String replaceEmojiToImage(String str) {
    var result = str;
    for (var emoji in emojis) {
      result = result.replaceAll(emoji, emojiImages[emojis.indexOf(emoji)]);
    }
    return result;
  }

  static List<String> emojis = [
    "\u{1F600}",
    "\u{1F604}",
    "\u{1F609}",
    "\u{1F62E}",
    "\u{1F92A}",
    "\u{1F60E}",
    "\u{1F971}",
    "\u{1F974}",
    "\u{263A}",
    "\u{1F641}",
    "\u{1F62D}",
    "\u{1F610}",
    "\u{1F607}",
    "\u{1F62C}",
    "\u{1F913}",
    "\u{1F633}",
    "\u{1F973}",
    "\u{1F620}",
    "\u{1F644}",
    "\u{1F910}",
    "\u{1F97A}",
    "\u{1F928}",
    "\u{1F62B}",
    "\u{1F637}",
    "\u{1F912}",
    "\u{1F631}",
    "\u{1F618}",
    "\u{1F60D}",
    "\u{1F922}",
    "\u{1F47F}",
    "\u{1F92C}",
    "\u{1F621}",
    "\u{1F44D}",
    "\u{1F44E}",
    "\u{1F44F}",
    "\u{1F64C}",
    "\u{1F91D}",
    "\u{1F64F}",
    "\u{2764}",
    "\u{1F494}",
    "\u{1F495}",
    "\u{1F4A9}",
    "\u{1F48B}",
    "\u{2600}",
    "\u{1F31C}",
    "\u{1F308}",
    "\u{2B50}",
    "\u{1F31F}",
    "\u{1F389}",
    "\u{1F490}",
    "\u{1F382}",
    "\u{1F381}"
  ];

  static final emojiImages = [
    'U+1F600.png',
    'U+1F604.png',
    'U+1F609.png',
    'U+1F62E.png',
    'U+1F92A.png',
    'U+1F60E.png',
    'U+1F971.png',
    'U+1F974.png',
    'U+263A.png',
    'U+1F641.png',
    'U+1F62D.png',
    'U+1F610.png',
    'U+1F607.png',
    'U+1F62C.png',
    'U+1F913.png',
    'U+1F633.png',
    'U+1F973.png',
    'U+1F620.png',
    'U+1F644.png',
    'U+1F910.png',
    'U+1F97A.png',
    'U+1F928.png',
    'U+1F62B.png',
    'U+1F637.png',
    'U+1F912.png',
    'U+1F631.png',
    'U+1F618.png',
    'U+1F60D.png',
    'U+1F922.png',
    'U+1F47F.png',
    'U+1F92C.png',
    'U+1F621.png',
    'U+1F44D.png',
    'U+1F44E.png',
    'U+1F44F.png',
    'U+1F64C.png',
    'U+1F91D.png',
    'U+1F64F.png',
    'U+2764.png',
    'U+1F494.png',
    'U+1F495.png',
    'U+1F4A9.png',
    'U+1F48B.png',
    'U+2600.png',
    'U+1F31C.png',
    'U+1F308.png',
    'U+2B50.png',
    'U+1F31F.png',
    'U+1F389.png',
    'U+1F490.png',
    'U+1F382.png',
    'U+1F381.png',
  ];
}
