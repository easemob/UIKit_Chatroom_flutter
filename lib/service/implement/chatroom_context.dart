
import '../../inner_headers.dart';

class ChatroomContext {
  static ChatroomContext? _instance;
  static ChatroomContext get instance => _instance ??= ChatroomContext._();

  String? ownerId;
  String? roomId;

  ChatroomContext._();

  final Map<String, UserInfoProtocol> userInfosMap = {};

  List<String> muteList = [];

  Future<Map<String, UserInfoProtocol>?> getUserInfo(
      List<String> userIds) async {
    final tmp = userInfosMap.values.where(
      (element) => userIds.contains(element.userId),
    );
    final ret = {for (var value in tmp) value.userId: value};

    if (tmp.length == userIds.length) {
      return ret;
    }

    List<String> unCachedUserIds = [];
    for (var element in userIds) {
      if (!userInfosMap.containsKey(element)) {
        unCachedUserIds.add(element);
      }
    }

    List<UserInfoProtocol> fetched =
        await ChatroomUIKitClient.instance.fetchUserInfos(
      userIds: unCachedUserIds,
    );

    ret.addAll({for (var value in fetched) value.userId: value});

    return ret;
  }

  void updateUserInfos(List<UserInfoProtocol> userInfos) {
    for (var element in userInfos) {
      userInfosMap[element.userId] = element;
    }
  }

  bool get isOwner {
    return Client.getInstance.currentUserId == ownerId;
  }
}
