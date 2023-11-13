import 'package:chatroom_uikit/default/data/user_entity.dart';

class YourAppUser extends UserEntity {
  YourAppUser(super.userId, {super.nickname = '富贵儿', super.gender = 1});

  @override
  String? get avatarURL =>
      'https://accktvpic.oss-cn-beijing.aliyuncs.com/pic/sample_avatar/sample_avatar_1.png';

  @override
  String? get identify =>
      'https://accktvpic.oss-cn-beijing.aliyuncs.com/pic/sample_avatar/sample_avatar_1.png';
}
