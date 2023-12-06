abstract class UserInfoProtocol {
  String get userId;
  String? get nickname;
  String? get avatarURL;
  String? get identify;
  int? get gender;
  String? get searchKeyword => nickname ?? userId;
}

abstract class UserService {
  /// Bind user state changed listener
  /// - Parameter listener: UserStateChangedListener
  void bindResponse(UserStateChangedResponse response);

  /// Unbind user state changed listener
  /// - Parameter listener: UserStateChangedListener
  void unbindResponse(UserStateChangedResponse response);

  /// Get user info by userIds.The frequency of api usage for free users is 100 times in 1 second.Upgrading the package can increase the usage.
  /// - Parameters:
  ///   - userIds: userIds
  ///   - completion: completion
  Future<List<UserInfoProtocol>> fetchUserInfos(
      {required List<String> userIds});

  /// Update user info.The frequency of api usage for free users is 100 times in 1 second.Upgrading the package can increase the usage.
  /// - Parameters:
  ///   - userInfo: UserInfoProtocol
  ///   - completion:
  Future<void> updateUserInfo({UserInfoProtocol? user});

  /// Login SDK
  /// - Parameters:
  ///   - userId: user id
  Future<void> login(
      {required String userId,
      required String tokenOrPwd,
      bool isPassword = false});

  /// Logout SDK
  /// - Parameter completion: Callback,success or failure
  Future<void> logout();

  void dispose();

  UserInfoProtocol? userFromJson(Map<String, dynamic>? json);
  Map<String, dynamic>? userToJson(UserInfoProtocol? giftEntityProtocol);
}

abstract class UserStateChangedResponse {
  /// User login at other device
  /// - Parameter device: Other device name
  void onUserLoginOtherDevice(String device);

  /// User token will expired,when you need to fetch chat token  re-login.
  void onUserTokenWillExpired();

  /// User token expired,when you need to fetch chat token  re-login.
  void onUserTokenDidExpired();

  /// Chatroom socket connection state changed listener.
  /// - Parameter state: ConnectionState
  void onSocketConnectionStateChanged(bool isConnect);

  /// The user account did removed by server.
  void userAccountDidRemoved();

  /// The method called on user did forbid by server.
  void userDidForbidden();
}
